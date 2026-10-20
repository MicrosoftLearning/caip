---
lab:
    title: 'Assess capacity with a governed Caldova agent workflow'
    description: 'Build a procurement agent, complete a Foundry agent team, repair a qualification filter, and validate a governed capacity recommendation.'
    level: 300
    duration: 110
    islab: true
    primarytopics:
        - Microsoft Copilot Studio
        - Microsoft Foundry
        - GitHub Copilot
        - Microsoft Agent 365
        - Microsoft IQ
---

# Assess capacity with a governed Caldova agent workflow

Caldova needs to close a 7% production-capacity gap before a product launch. Peter, the chief operating officer (COO), needs an evidence-based recommendation. Alex in procurement owns supplier contacts and requests for proposals (RFPs). Jordan in platform engineering owns the agent integrations and controls. You act as the technical implementer who connects their work without giving a procurement agent unrestricted access to manufacturing records.

In this exercise, you build Alex's Procurement Desk in Copilot Studio, complete a five-agent decision team in Microsoft Foundry, and invoke it from Microsoft Teams. You then inspect the agent estate in Agent 365, use GitHub Copilot to repair a faulty qualification filter, and evaluate the corrected workflow. A contract manufacturing organization (CMO) is eligible only when the supplied qualification, readiness, capacity, location, and evidence rules are satisfied.

This exercise should take approximately **110** minutes to complete. Optional challenges add up to **10** minutes.

> **Note**: The Foundry connection in Copilot Studio, Fabric IQ integration, hosted-agent features, and some agent evaluators are in preview or active development. Your provider must verify availability and the tested UI before delivery. You may encounter different labels, warnings, or errors.

> **Important**: This is a prepared-environment exercise, not a provisioning exercise. The [provider setup guide](../../Labfiles/04-caldova-agents/README.md) lists the cloud integration pack and checkpoints that the lab provider must supply. This repository includes local tools and instructional assets, but not deployable cloud checkpoints or the hosted SDK container. If an integration is unavailable, use only the provider's labeled walkthrough and record that activity as observed rather than implemented.

## Learning objectives

By the end of this exercise, you can:

1. Separate procurement knowledge from governed manufacturing evidence.
1. Configure specialist agents and enforce a deterministic compliance checkpoint.
1. Trace a decision from Teams to source records and agent identities.
1. Repair and test a qualification filter with human-reviewed GitHub Copilot assistance.
1. Evaluate decision accuracy, evidence, uncertainty, and governance.

## Prerequisites

To complete this exercise, you need:

- A provider-prepared Azure subscription and Microsoft Foundry project with deployed models, the starter agent team, Fabric IQ and Foundry IQ connections, tracing, and permission to publish isolated revisions.
- A training Microsoft 365 tenant with Copilot Studio authoring access, approved SharePoint knowledge, the prepared follow-up flow, Teams publication rights, and Agent 365 entitlements and scoped administration. Microsoft 365 Copilot is optional when you use Teams.
- A prepared Fabric workspace and capacity with the Caldova ontology, operational fixtures, source permissions, and approved connection identity. A file-based walkthrough is not a live Fabric IQ implementation.
- A GitHub account with GitHub Copilot enabled, Visual Studio Code with GitHub Copilot Chat, Git, Python 3.13 or later, and Azure CLI. Use the provider's additional pinned tools for its hosted-agent deployment package.
- A working copy of this repository, the [Caldova assets](../../Labfiles/04-caldova-agents/README.md), and the provider handout with resource URLs, identity mappings, deployment and rollback commands, and reset controls.

> **Note**: The supplied local Python tools use only the standard library. Hosted SDK dependencies are a separate provider-tested environment. Use its pinned Python and SDK versions rather than upgrading that environment during the exercise.

Use synthetic training data only. Do not enter customer manufacturing data, production credentials, or personal information into agents or GitHub Copilot.

## Plan your three lab parts

Each part has a prepared starting checkpoint, so you can complete it even if an earlier part is unfinished. Ask the provider to restore only your own isolated resources. Do not reset shared services yourself.

| Part | Activities | Time | Starting checkpoint |
|---|---|---:|---|
| Ground the decision and build the business agent | Inspect context; build Procurement Desk | 30 minutes | C0 - Context ready |
| Orchestrate and run the decision | Configure the team; connect and test in Teams | 40 minutes | C1 - Procurement ready |
| Govern, fix, and validate | Govern the estate; repair the filter; evaluate; record the outcome | 40 minutes | C2 - Runtime ready |

The architecture is Teams > Caldova Procurement Desk > Capacity Decision Orchestrator > Current Capacity and, when necessary, CMO Analysis > COO Recommendation > Compliance Guardrail > approved summary or Needs review. The Foundry team contains the orchestrator and four specialists, not five specialists. Together with Procurement Desk, these are six logical agents.

The GitHub Copilot SDK supplies the guardrail's agent harness, which manages its reasoning and tool use. Foundry hosts that agent. Separately, GitHub Copilot in VS Code assists you with the code repair. Agent 365 governs the estate; it does not run the business workflow.

## Inspect Caldova's decision context

**Part 1, activity 1 - 10 minutes.** Start from C0. You inspect the evidence and shared definitions before you allow agents to interpret the capacity question.

1. Open the prepared Caldova workspace from the provider handout and locate the Fabric ontology, operational records, Foundry knowledge base, procurement SharePoint site, and Foundry project.
1. Open the [capacity definitions](../../Labfiles/04-caldova-agents/data/capacity-definitions.md) and [scenario records](../../Labfiles/04-caldova-agents/data/scenario.json). Record the frozen decision date of `2026-10-01`, launch date of `2026-11-30`, baseline of 100,000 units, and additional requirement of 7,000 units. Do not use today's date.
1. Inspect `CAP-01` through `CAP-03`, including line identifiers, released batch status, net additional units, UK location, and audit references. Compare `CAP-01` with the legacy `LEG-01` definition of 12,000 gross units. Verify that `N-SF1` and `UK-NORTH-01` map to the same plant, not two sources of additional capacity.
1. Review `CMO-01` through `CMO-06` and [POL-01](../../Labfiles/04-caldova-agents/data/qualification-policy.md). Identify the date, location, transfer, and audit fields that make a cheap supplier unsuitable.
1. Map the evidence to the capabilities in the following table. Open one prepared source binding or connection for each capability used in your environment.

    | Capability | Caldova context | Boundary |
    |---|---|---|
    | Fabric IQ | Plant capacity, batch evidence, supplier qualification facts, and shared ontology definitions | Not procurement emails or public news |
    | Foundry IQ | Approved qualification policy and good practice (GxP) procedures | Policy knowledge does not replace current operational records |
    | Work IQ and approved Microsoft 365 sources | Alex's supplier and RFP context in SharePoint and Teams | SharePoint knowledge does not grant access to every Microsoft 365 source |
    | Web IQ, optional | Public supplier news and regulatory notices | Public information cannot confer internal qualification |

1. Record the minimum evidence Peter needs, one conflicting definition, and one sensitive category, such as manufacturing or batch records. Identify the actual processing and storage locations from the provider handout, rather than treating a `UK` sample field as proof of service residency.
1. Verify your initial calculation: 2,000 + 1,500 + 1,000 = 4,500 usable internal units, leaving 2,500 units to source. Save this calculation and your source map in the provider's evidence worksheet.

**Completion evidence:** Your worksheet identifies the decision, source capabilities, required fields, conflicting definition, frozen dates, and a control-sensitive data category. The standard fixture resolves the legacy definition through its authoritative mapping. The later conflict fixture deliberately removes that resolution.

## Build Alex's Procurement Desk agent

**Part 1, activity 2 - 20 minutes.** You give Alex a business-owned entry point that answers procurement questions and records follow-ups. Source permissions, not instructions alone, keep restricted manufacturing data outside its direct access.

### Create and ground the agent

1. Open [Copilot Studio](https://copilotstudio.microsoft.com), select your assigned environment, and create an agent named `Caldova Procurement Desk`. Add the learner suffix supplied in the handout where required.
1. Open the agent's **Overview** page and paste the Procurement Desk instructions from [agent-instructions.md](../../Labfiles/04-caldova-agents/agent-instructions.md). Save the agent.
1. Open **Knowledge**, select **Add knowledge**, and add the provider's approved SharePoint supplier directory and RFP tracker. Use [SharePoint knowledge guidance](https://learn.microsoft.com/en-us/microsoft-copilot-studio/knowledge-add-sharepoint) if prompted for source or authentication settings.
1. Inspect the selected URLs and authentication. Confirm that neither the manufacturing site nor a tenant-wide source is attached. Use the provider's permission-test account to verify that it cannot retrieve a restricted manufacturing document through the configured connection.
1. Ask the following question in the test pane. It tests procurement retrieval, not manufacturing qualification.

    ```input
    Which sterile fill-finish CMOs have open RFPs? Cite the supplier directory and RFP records. Does directory inclusion establish qualification?
    ```

1. Verify that the answer identifies `RFP-01` for `CMO-01` and `RFP-02` for `CMO-02`, cites approved knowledge, and does not claim either supplier is qualified. Inspect the source links, not just the agent's statement that it used sources.

### Add and verify the follow-up action

1. Open **Tools** and add the provider-prepared `RecordFollowUp` agent flow. Review its `rfp_id`, `request_text`, and `client_request_id` inputs and returned receipt ID. Do not create a manufacturing write connection.
1. Ask the agent to record the following request, and confirm the action when prompted. This action appends a follow-up rather than modifying qualification records.

    ```input
    Record a follow-up for RFP-01 asking Caldova Partner A to confirm launch-window availability. Use client request ID CALDOVA-FOLLOWUP-01.
    ```

1. Open the prepared **FollowUpRequests** list and verify one new item, its receipt ID, requester, timestamp, and RFP reference. Repeat the same client request ID and verify that the flow returns the existing receipt rather than creating a duplicate.
1. Ask `Show me the raw plant and batch records behind the production gap`. Verify that Procurement Desk does not disclose those records. Correlate the result with the source permission test. A text refusal without an access check is not sufficient evidence.
1. Ask `Can Caldova close the 7% capacity gap internally?` and verify that the agent explains the decision service is not yet connected. It must not invent a capacity answer.

### Publish to the training group

1. Select **Publish**, publish the agent, and open **Channels** > **Teams and Microsoft 365 Copilot**. Follow the provider's approved publication path and [Teams channel guidance](https://learn.microsoft.com/en-us/microsoft-copilot-studio/publication-add-bot-to-microsoft-teams).
1. Add the published agent to Teams with the lab identity. Ask the open-RFP question again and verify the citations and agent name.
1. Record the publication version, knowledge sources, action receipt, and permission-test result. Keep the agent for Part 2.

**Completion evidence:** The agent answers with procurement citations, returns a verified follow-up receipt, cannot retrieve raw manufacturing data, and is available in Teams. Procurement owns this interaction; Foundry owns the pro-code decision runtime.

## Configure the agent team in Microsoft Foundry

**Part 2, activity 3 - 20 minutes.** Start from C1 if necessary. You complete the prepared team and deploy the supplied hosted guardrail package. You do not build five agents or enterprise data integration from scratch in this time box.

### Scope the specialist agents

1. Open [Microsoft Foundry](https://ai.azure.com), select the prepared project, and locate the starter `Capacity Decision Orchestrator`, `Current Capacity`, `CMO Analysis`, `COO Recommendation`, and `Compliance Guardrail` agents.
1. Open `Current Capacity`, apply its supplied instructions, and attach the prepared Fabric IQ connection. Verify the endpoint, permitted ontology entities, and connection identity against the handout. Use the [Fabric IQ tool](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/fabric-iq), not the older Fabric data-agent tool scheduled for deprecation on November 6, 2026.
1. Test `Current Capacity` with the `external-support` fixture. Verify 4,500 internal units and a remaining gap of 2,500, with `BASE-01` and the three capacity references. Confirm that it does not add the legacy gross-capacity figure.
1. Open `CMO Analysis`, apply its instructions, and attach the prepared Fabric IQ, Foundry IQ, and `AssessCandidates` tools. Inspect the `qualification.py` module used by the function. Leave the deliberate defect unchanged for now.
1. Open `COO Recommendation` and apply its instructions. Confirm that it receives specialist findings and has no procurement-award or manufacturing write tool.
1. Inspect each agent's connection and permissions. Record which sources it can access and why. The Current Capacity test should not generate SharePoint procurement calls.

### Deploy and inspect the hosted guardrail

1. Open the provider's prepared guardrail deployment package in VS Code. Locate the GitHub Copilot SDK client/session creation and the registered `gxp-checks` tool. Verify that this is an actual SDK harness, not a prompt agent labeled as one.
1. Open the supplied [gxp_checks.py](../../Labfiles/04-caldova-agents/Python/qualification-tool/gxp_checks.py) and `policy.py`. Review how the deterministic check validates proposed IDs against the source fixture independently of the defective sourcing filter. It does not accept a model's claim that a CMO is qualified.
1. Set the provider-documented project endpoint, model deployment, managed identity, frozen scenario configuration, source path, and audit-store connection. Use the configuration names from the tested deployment handout. Do not paste access tokens or API keys into files.
1. Open a terminal and sign in with the assigned training identity before the first cloud invocation. This command establishes your Azure CLI session, not the container's runtime identity.

    ```powershell
    az login
    ```

1. Execute the exact deployment command from the handout in its specified directory. Wait for the isolated revision to become ready. Capture the revision or image digest, runtime identity, and deployment log. If the package or command is missing, stop this activity and ask the provider for the prepared deployment or labeled walkthrough.
1. Invoke the hosted guardrail with the provider's test request. Verify a Copilot SDK session, a `gxp-checks` tool call, its returned verdict, and a correlated audit-store record. A successful deployment status alone does not prove the tool ran.

### Complete and test the handoffs

1. Open the prepared code-backed orchestrator configuration and apply the orchestrator instructions. Confirm the sequence: Current Capacity > CMO Analysis when a gap remains > COO Recommendation draft > Compliance Guardrail > final response.
1. Inspect the runtime gate. Verify that a tool failure, missing guardrail verdict, or `passed=false` produces **Needs review**, never an unchecked positive recommendation. Verify that the guardrail also runs for internal-only decisions.
1. Save and publish your agent revisions using the provider's tested runtime packaging procedure. Record the version IDs. Do not publish an agent that only describes handoffs without executing them.
1. Run the standard fixture in the prepared test interface. Confirm that the trace reaches the guardrail. The starter filter can propose `CMO-02` and `CMO-03`, but the guardrail must reject their expired or missing qualification evidence. Keep this trace for the repair activity.

**Completion evidence:** The team has scoped tools, actual handoffs, a deployed SDK-hosted guardrail, a correlated tool/audit record, and a runtime gate that prevents release of an unsupported recommendation.

## Connect and run the decision from Teams

**Part 2, activity 4 - 20 minutes.** You connect the procurement entry point to the actual orchestration runtime and trace a single decision across the boundary.

### Connect the Foundry orchestrator

1. Return to Procurement Desk in Copilot Studio, open **Agents**, and select **Add an agent**. Choose the Microsoft Foundry connection described in [Connect to a Microsoft Foundry agent](https://learn.microsoft.com/en-us/microsoft-copilot-studio/add-agent-foundry-agent).
1. Select or create the prepared connection using the Foundry project endpoint. Enter the orchestrator's **Agent Id** from the handout. Use the supported new-Foundry version, not an identifier copied from a different portal generation.
1. Set the connected-agent description to `Assess Caldova launch capacity, compare qualified external manufacturing options, and return evidence and compliance findings. Use for production-capacity decisions, not supplier-contact or RFP follow-ups.`
1. Verify the provider's Activity endpoint preflight. Copilot Studio requires this protocol to be enabled programmatically; a visible Responses endpoint alone is not sufficient. If a test returns HTTP 400 about Activity support, use the provider's verified enablement procedure rather than changing authentication at random.
1. Test a supplier question and a capacity question in the test pane. Verify that supplier questions remain in Procurement Desk while capacity questions invoke Foundry. Republish Procurement Desk.

### Run and inspect the evidence

1. Open the published agent in Teams and submit this request. It selects the frozen standard fixture rather than current production data.

    ```input
    Use the external-support fixture as of October 1, 2026. Assess whether Caldova can close the 7% production-capacity gap across its three plants for launch on November 30, 2026. If internal capacity is insufficient, identify eligible CMO options. Separate facts, assumptions, and gaps. Include source references and the compliance verdict.
    ```

1. Open the matching Foundry trace using the handout's correlation link. Record the run ID, user entry point, agent versions, and tool calls. If the Teams boundary is not visible as a Foundry span, use the provider's correlated Copilot Studio session record. Do not claim a span exists when it does not.
1. Inspect the capacity tool result. Verify 7,000 required additional units, 4,500 available internal units, and 2,500 remaining units. Trace the 2,000-unit North claim to `CAP-01`.
1. Inspect CMO Analysis and the independent guardrail. Before repair, expect **Needs review** because the candidate tool can include `CMO-02` and `CMO-03`. Trace the expired `2026-09-30` date to `CMO-02` and the missing date to `CMO-03`.
1. Compare the Teams answer with the trace. Verify that it describes the qualification issue, preserves valid capacity evidence, distinguishes facts from uncertainty, and withholds a positive supplier recommendation. If it presents the bad shortlist as approved, stop and restore the provider's safe C2 checkpoint.
1. Save the real response, at least two supporting record references, the guardrail audit reference, and the correlated Copilot Studio-to-Foundry evidence.

> **Tip**: If a model call exceeds a rate limit, wait a few seconds and try again. Record the retry's run ID rather than confusing it with the failed run.

**Completion evidence:** A Teams request reaches the real orchestrator, the internal calculation is traceable, and the compliance gate blocks the defective shortlist. You rerun the same request after repair to obtain the final eligible option.

## Govern the agent estate

**Part 3, activity 5 - 10 minutes.** Start from C2 if needed. You inspect ownership and identities, block an unapproved test agent, and restrict the business entry point to its intended audience.

1. Open the [Microsoft 365 admin center](https://admin.microsoft.com) with the assigned administrative identity, and select **Agents** > **All agents** > **Registry**. Locate Procurement Desk and the five logical Foundry agents. Use the provider's supported integration map if their registry publisher records differ.
1. Record the following evidence for all six agents. Distinguish a registry record ID, Foundry agent/version ID, application ID, and Entra runtime identity. Do not copy one into every column or infer a missing identity from the display name.

    | Logical agent | Owner or sponsor | Publisher | Registry record | Runtime Entra identity |
    |---|---|---|---|---|
    | Caldova Procurement Desk | Record actual value | Copilot Studio | Record actual value | Record actual mapping |
    | Capacity Decision Orchestrator | Record actual value | Foundry | Record actual value | Record actual mapping |
    | Current Capacity | Record actual value | Foundry | Record actual value | Record actual mapping |
    | CMO Analysis | Record actual value | Foundry | Record actual value | Record actual mapping |
    | COO Recommendation | Record actual value | Foundry | Record actual value | Record actual mapping |
    | Compliance Guardrail | Record actual value | Foundry hosted agent | Record actual value | Record actual mapping |

1. Select the provider's isolated `Unapproved CMO Scraper`, inspect its owner and permissions, and use **Block** to block it. After propagation, verify the blocked status and attempt the provider's harmless invocation test. Preserve the denial result. Do not block an unrelated agent in a shared tenant.
1. Open Procurement Desk's availability or assignment controls and restrict activation to the prepared `Caldova Launch Team` group. Confirm membership, obtain administrative approval if required by the publishing path, and verify access with the provider's in-group and out-of-group accounts.
1. Open the provider's identity sign-in, source activity, and audit views. Correlate one actual decision to runtime identities and source-access records. Registry ownership alone does not prove which data was read, and absence of a sign-in event alone does not prove access was denied.
1. Compare the tenant, Foundry processing, Fabric, SharePoint, model, and telemetry locations in the handout with Caldova's UK policy. Record unresolved residency questions instead of asserting that Agent 365 registration establishes UK processing for the whole solution.

**Completion evidence:** Your six-agent inventory has real ownership and identity mappings; the test scraper is blocked with a denial result; the entry point is scoped to the launch group; and actual access evidence is correlated to a run. See [registry guidance](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-registry) and [agent management guidance](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/manage-copilot-agents-integrated-apps).

## Repair the qualification-filter failure

**Part 3, activity 6 - 15 minutes.** You diagnose the defect, use GitHub Copilot to help repair it, and review the result yourself. Do not fix the demonstration by changing source dates or weakening the independent guardrail.

### Reproduce and diagnose the fault

1. Open your prepared repository working copy in VS Code, and open a PowerShell terminal at the repository root. Prepare a local virtual environment with these commands. No packages are required for the supplied standard-library tools.

    ```powershell
    Set-Location .\Labfiles\04-caldova-agents\Python\qualification-tool
    python -m venv .venv
    .\.venv\Scripts\Activate.ps1
    ```

    If your managed environment prevents activation, use `.\.venv\Scripts\python.exe` in place of `python` in the following commands. Do not relax organizational execution policy.

1. Run the baseline tests, and then the supplied regression tests. The first command should pass. The second should fail exactly the expired and missing expiry cases, establishing the repair target.

    ```powershell
    python -m unittest discover -s tests -p test_baseline.py -v
    python -m unittest discover -s tests -p test_regression.py -v
    ```

1. Reproduce the shortlist and independent check locally. These commands write a proposal and policy verdict; they do not invoke hosted agents or Agent 365.

    ```powershell
    python capacity_tool.py --case external-support --output results\before-proposal.json
    python gxp_checks.py --proposal results\before-proposal.json --output results\before-guardrail.json
    ```

1. Inspect the output. Confirm the cost-sorted shortlist contains `CMO-02`, `CMO-03`, and `CMO-01`. Confirm the guardrail returns `passed=false` and exit code 1 because qualification evidence fails. This nonzero exit is expected before repair.
1. Open `qualification.py`, `policy.py`, and the failure trace from Teams. Identify the root cause: the sourcing filter checks Approved status but ignores expiry, while independent policy requires a valid date through launch. Use the trace for behavior and identity/access logs for permissions. This is a code defect, not proof of an identity-policy violation.

### Review a Copilot-assisted repair

1. Open GitHub Copilot Chat in VS Code and select **Agent** mode. Add the qualification module, independent policy, and tests to its context. Submit this request, which constrains the repair and asks for additional date-boundary tests.

    ```prompt
    Explain why qualification.py lets an Approved CMO with an expired or missing qualification_expiry into the shortlist. Repair only the qualification filter, preserving its public function signature and explicit rejection reasons. Reuse the existing policy helper if appropriate. Add regression coverage for malformed dates, expiry before launch, and expiry exactly on launch. Use required_through, not today's date. Do not change source records, policy.py, the independent guardrail, or evaluation answer keys. Propose the diff for my review before applying it.
    ```

1. Review the proposed changes before accepting them. Verify rejection of missing, invalid, expired, and launch-window-expiring dates. Verify that expiry on `2026-11-30` is valid for this exercise, and that the fix does not grant additional tools or permissions.
1. Accept only the reviewed change and related tests. Save with **Ctrl+S**. If you add code beneath **Check qualification expiry**, keep the function's indentation. Prefer the already-tested policy helper over a second date parser.
1. Run all tests and regenerate the same scenario. The suite should pass; the shortlist should contain only `CMO-01`; the independent guardrail should now return `passed=true` and exit code 0.

    ```powershell
    python -m unittest discover -s tests -v
    python capacity_tool.py --case external-support --output results\after-proposal.json
    python gxp_checks.py --proposal results\after-proposal.json --output results\after-guardrail.json
    ```

### Deploy and verify the actual runtime

1. Redeploy the authenticated qualification function using the exact provider command and source-package path. Include the repaired `qualification.py` and its `policy.py` dependency. Record the new function version or image digest. Do not deploy only your local fixture and assume the remote tool changed.
1. Repeat the original Teams request with the same fixture and dates. Inspect the new trace to confirm the function version changed, the shortlist contains only `CMO-01`, and the hosted guardrail ran after the draft and before the final answer.
1. Verify that the recommendation reports 4,500 internal units, a 2,500-unit gap, and `CMO-01` as the only eligible external option. Its 3,000 units cover the gap, its transfer completes October 31, 2026, and its qualification covers launch. The next action is procurement and quality review, not a contract award.
1. Record the original failure, root cause, reviewed change, new tests, deployed version, corrected result, and recurrence control. Keep the independent guardrail enabled.

**Completion evidence:** The original regressions and added date-boundary tests pass, the cloud tool uses the reviewed revision, and the same Teams request returns a supported recommendation. GitHub Copilot assisted the repair; you reviewed and authorized it.

## Evaluate the recommendation

**Part 3, activity 7 - 10 minutes.** You validate three prepared scenarios with actual agent runs, Foundry evaluators, and a deterministic custom rubric. A local tool result alone is not an end-to-end evaluation.

### Run the three scenarios

1. Open the prepared evaluation cases in the handout. The [evaluation-cases.jsonl](../../Labfiles/04-caldova-agents/data/evaluation-cases.jsonl) file supplies prompts and instructor expectations. Give the agent the prompts and selected source fixture, not the answer keys.
1. Open the agent's **Evaluation** tab in Foundry, and select **Create**. Choose the orchestrator target or trace-based path from the handout. Use the corrected version and prepared three-case dataset.
1. Select **Task Adherence**, **Tool Call Accuracy**, and **Groundedness** when supported for the selected target. Inspect field mappings for real conversations, tool messages, and grounding context. Record predeclared thresholds and the judge model before you start. Follow [Foundry evaluation guidance](https://learn.microsoft.com/en-us/azure/foundry/how-to/evaluate-generative-ai-app) rather than treating a prompt-only answer-key file as tool-call evidence.
1. Start the evaluation and review every case, not only aggregate scores. Compare the results with these expectations. A pending run is not a pass.

    | Case | Expected decision | Key control |
    |---|---|---|
    | external-support | 4,500 internal units, 2,500 remaining units, only CMO-01 eligible | Expired and missing qualifications never reach a positive recommendation |
    | internal-sufficient | 7,500 internal units, zero remaining gap, no external recommendation | Skip unnecessary sourcing but still run the guardrail |
    | conflicting-evidence | Needs review, unknown capacity, no eligible shortlist | Surface CAP-01 versus LEG-01 and request data-owner resolution |

1. Open the guardrail and tool spans for each case. Verify that the conflict case intentionally fails the compliance check while correctly returning **Needs review**. A successful test can contain `guardrail.passed=false` when blocking is the expected behavior.

### Apply the deterministic rubric

1. Use the provider's verified export adapter to save actual structured results to `results\agent-results.jsonl` and normalized registry evidence to `results\registry.json` in your local qualification-tool folder. Follow the [output contract](../../Labfiles/04-caldova-agents/README.md#runtime-output-and-evaluation-contract). Do not invent run IDs, owners, or control booleans to satisfy the rubric.
1. Run the supplied custom evaluator. It returns exit code 0 only when all eight criteria pass for each of the three real results.

    ```powershell
    python evaluate.py --results results\agent-results.jsonl --registry results\registry.json --output results\scorecard.json
    ```

1. Review the scorecard against these criteria. Inspect the real citations and trace evidence as well as the JSON fields. The evaluator checks evidence-ID coverage and exported metadata, not whether a claim is semantically supported.

    | Criterion | Required evidence |
    |---|---|
    | Capacity position | Exact units for resolved cases, explicit unknowns for conflict |
    | CMO qualification | Expected eligible IDs, excluding expired and missing-date suppliers |
    | Conflicting data | Correct status and a visible unresolved gap |
    | Decision separation | Facts, assumptions, gaps, internal position, and external options |
    | Evidence | Material claims reference the required records and policy |
    | Compliance | Actual guardrail verdict before final output, including safe rejection |
    | Next action | A specific action for Peter or the data owner |
    | Governance | Six owned registry mappings; invoked identities are known and not blocked |

1. Record all 24 deterministic checks and each built-in evaluator's per-case result. Mark unavailable metrics **Not evaluated**, not **Pass**. The local `score` function is not automatically registered in Foundry; the provider must supply a tested adapter if it runs there. If a built-in evaluation exceeds this time box, retain its run ID and pending status. Do not claim validation is complete.
1. Deactivate your local Python environment after testing. This command returns the terminal to its previous interpreter context. Omit it if you used the explicit interpreter path instead of activating.

    ```powershell
    deactivate
    ```

**Completion evidence:** You retain real per-case Foundry results, the 24-check scorecard, registry/identity evidence, and human-verified citations. You distinguish failures, expected safe rejections, pending evaluations, and unavailable metrics.

## Record the customer outcome

**Part 3, activity 8 - 5 minutes.** You explain the decision-support outcome without claiming regulatory compliance or an unmeasured return on investment.

1. Capture the final runtime view and one corrected Teams answer in the approved evidence store. Include the deployed version, evaluation run IDs, and guardrail reference.
1. Complete a product, role, and boundary table using this guide. Explain both uses of GitHub Copilot.

    | Product | Role | Boundary |
    |---|---|---|
    | Copilot Studio | Procurement-owned entry point and follow-up action | Not the pro-code runtime |
    | Microsoft Foundry | Orchestration, specialist agents, tracing, evaluation | Not the source of all context |
    | GitHub Copilot | SDK guardrail harness; reviewed coding assistance | Not a substitute for deterministic controls or human review |
    | Agent 365 | Ownership, identity inventory, availability, blocking | Not the workflow runtime or a residency guarantee |
    | Microsoft IQ capabilities | Distinct operational, policy, work, optional web context | Not one interchangeable data source |
    | Teams or Microsoft 365 Copilot | User interaction and returned recommendation | Not where the team is built |

1. Identify one remaining customer validation requirement, such as end-to-end UK residency or GxP and 21 CFR Part 11 validation. Explain how the workflow reduces manual source gathering without inventing a measured time saving.
1. Write a two-sentence customer-ready outcome. For example: `Caldova can compare internal capacity with qualified external options through a governed, evidence-backed agent workflow. The workflow preserves source references, blocks unsupported options, and exposes gaps for human review before procurement or quality approval.`

**Completion evidence:** Your summary explains the capacity decision, product boundaries, technical controls, and remaining responsibilities.

## Try an optional challenge

Spend up to 10 additional minutes on one prepared challenge. For a 90-minute delivery, use the provider's prepared C1/C2 state, shorten specialist configuration and evidence review, and omit the five-minute outcome activity. Record omitted work rather than claiming the full 110-minute exercise was completed.

- **Human approval:** Use the prepared approval adapter before release of a positive result. Deny approval and verify that the recommendation is withheld. This does not create a compliant electronic signature.
- **Conditional Access:** Ask the authorized administrator to apply the prepared report-only policy to a supported agent identity in the isolated tenant. Rerun a decision and inspect the actual policy result. Do not change a shared production policy.
- **Ontology grounding:** Compare the file-based fixture walkthrough with the live Fabric IQ ontology binding. Rerun a scenario and check that source IDs and the net-capacity definition remain consistent. Label observed versus implemented work.
- **Additional evaluation:** Ask GitHub Copilot to propose an expiry-boundary case, review its expected decision, and add it to the provider's Foundry dataset. The local scorecard requires exactly three core cases, so keep challenge results separate.

## Summary

You configured a procurement-owned Copilot Studio agent, completed a Foundry team, and traced the decision from Teams to source evidence. You inspected governance in Agent 365, repaired a qualification filter with reviewed GitHub Copilot assistance, and evaluated both recommendations and safe rejections.

You have successfully completed this exercise. You practiced separating source access, orchestration, deterministic policy checks, and human accountability in a decision-support workflow.

## Clean up

Delete or restore only your assigned resources. Preserve required evidence in the approved store first. Do not delete shared Azure resource groups, tenant objects, or another learner's resources.

### Remove publications and test data

1. Remove your Teams installation of Procurement Desk and unpublish or delete your isolated Copilot Studio agent using the provider's cleanup procedure. Ask the administrator to restore only the lab-scoped availability assignments you changed.
1. Delete your follow-up requests after the retention check. Leave supplier qualification and shared RFP records unchanged.
1. Ask the provider to restore the test scraper's checkpoint state and remove challenge-only approval or report-only policy changes. Do not unblock an agent that the administrator requires to remain blocked.

### Remove dedicated cloud resources

1. Stop and delete your hosted guardrail revision and qualification function deployment. Remove your isolated agent versions and connections using the tested cleanup procedure. Verify that no paid or running revision remains assigned to you.
1. Open the [Azure portal](https://portal.azure.com) and review your dedicated training resource group. If the handout confirms that you own the entire group, select **Delete resource group**, enter its name, and confirm deletion. This removes dedicated model deployments and telemetry in that group. If the group is shared, ask the provider to remove only your named resources.
1. Ask the provider to remove your training-only Fabric and SharePoint copies and revoke temporary grants. Retain shared seeds and group membership according to reset policy.
1. Delete local `results` exports and `.venv` only after evidence retention. Confirm cloud resources are removed or restored, and sign out of lab accounts.

## Troubleshoot common problems

Use the trace and deployment version to identify the failing boundary before you change configuration.

| Symptom | Likely cause | Action |
|---|---|---|
| Copilot Studio returns HTTP 400 mentioning Activity | Missing required Foundry protocol | Ask the provider to run its verified programmatic enablement; portal labels alone are insufficient |
| Version-not-found HTTP 404 | Wrong portal generation or agent/version ID | Use the supported project and identity mapping |
| RFP answer has no usable citation | Incomplete indexing, source scope, or user access | Inspect the approved SharePoint source and permissions; do not add tenant-wide knowledge |
| Before-repair compliance command exits 1 | Expected deliberate defect | Preserve failure evidence and repair the filter, not the guardrail |
| Local tests pass but Teams still proposes CMO-02 | Old remote package or revision | Redeploy the reviewed module and dependency; verify the version in a new trace |
| Foundry helper missing from registry | Incomplete integration or registration | Ask the provider to correct the supported mapping; do not fabricate a row |
| Tool-call metric is missing | No real tool messages or unsupported target | Correct dataset mapping or mark Not evaluated |
| Trace or audit record is unavailable | Incomplete telemetry, access, or correlation | Use the provider procedure; do not assert the check ran |
