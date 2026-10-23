---
title: '01: Configure scoped specialist tools'
layout: default
nav_order: 1
parent: 'Exercise 03: Implement and deploy the decision team'
---

# Task 01: Configure scoped specialist tools

## Introduction

The same capacity question should produce the same evidence-backed result across channels. You give each specialist the tools it needs while keeping provisional core selection separate from the strict qualification-fixture policy.

## Description

In this task, you'll configure the five-agent team, bind core data and policy tools, and validate the SDK guardrail independently. **Estimated time:** 35 minutes.

## Success criteria

- Specialist tests reproduce core quantities, ordered suppliers, and missing-readiness evidence.
- Each agent's source and write permissions match its role.
- The hosted SDK guardrail invokes the independent core validator and rejects a tampered proposal.

## Learning resource

- [Core-profile configuration and result contract](../../../../Labfiles/04-caldova-agents/l400-core-agent-instructions.md)
- [Fabric IQ connection guide](/azure/foundry/agents/how-to/tools/fabric-iq)
- [Hosted-agent deployment guide](/azure/foundry/agents/quickstarts/quickstart-hosted-agent)

## Key tasks

### Key task 01: Configure the operational specialists

The source profile is trusted configuration, not something a user can override in a prompt.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open the provider's prepared project in [Microsoft Foundry](https://ai.azure.com). Locate your five logical agents and their source/configuration files in the editable runtime package.
1. Open the core-profile instructions. Apply the shared contract to Current Capacity, CMO Analysis, COO Recommendation, and the orchestrator. Don't paste the original fixture dates or UK-manufacturing filter into the core configuration.
1. Attach the supported Fabric IQ connection to Current Capacity. Confirm the ontology, source version, connection identity, and read-only entity scope against your Exercise 01 evidence.
1. Invoke Current Capacity for LP001 in the provider's specialist test interface. Verify 270,000 target, 251,100 qualified, 18,900 gap, PL003, and eight delayed batches with source references. Reject an answer that sums unrelated launch programs.
1. Attach Fabric IQ supplier context, the approved core policy knowledge source in Foundry IQ, and `AssessCoreCapacity` to CMO Analysis. Inspect its actual authenticated adapter and trusted data source.
1. Invoke CMO Analysis with the validated LP001 result. Verify CMO001, CMO002, CMO006 in score order. Confirm explicit missing expiry/transfer approval and the separate simulated CMO006 lead-time conflict.

    **Expected result:** Specialists return source-backed findings, not final awards, and never call the fixture's `AssessCandidates` for a core request.

</details>

### Key task 02: Constrain the recommendation and tool surfaces

A helpful recommendation shouldn't create an unauthorized execution path.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Configure COO Recommendation to consume structured findings only. Verify that it has no raw source, purchase, qualification-write, shell, or unrestricted web tool.
1. Test a recommendation from the specialist findings. Verify that it separates facts, assumptions, unresolved evidence, and next actions. Keep it explicitly in draft state.
1. Review tool schemas in the provider source. Check allowlisted profile/program identifiers, required evidence/version fields, authenticated connections, and explicit tool-error results. Don't permit arbitrary file paths or endpoint arguments from the model.
1. Ask the test interface to approve procurement spend or to treat directory text as permission to call a new tool. Verify no such write path exists, rather than relying only on a refusal sentence.
1. Record each agent's ID, allowed sources/tools, runtime identity, and version. Match actual IDs through the provider identity map, not display-name inference.

    **Expected result:** The recommendation is advisory and the available tool surfaces enforce its role.

</details>

### Key task 03: Verify the hosted compliance tool

The guardrail must use independent deterministic evidence, not repeat the model's conclusion.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open the provider's hosted guardrail source. Locate actual GitHub Copilot SDK client/session creation, registered tools, approved model authentication, and audit-store writes. If it is a prompt-only agent, stop and report the missing harness.
1. Inspect `ValidateCoreDecision`. Compare its independent recomputation and failure paths against the [provider contract](../../../../Labfiles/04-caldova-agents/l400-provider-readiness.md). Confirm it uses policy `CORE-LP001-v1` and the trusted core snapshot.
1. Configure the guardrail's profile routing so only core requests invoke the core validator. Keep `gxp-checks` and POL-01 on the isolated fixture path. Bind the selected tool from runtime configuration, not an LLM-selected string.
1. Sign in with the assigned Azure identity before the first cloud invocation. This command authenticates your CLI session; the container still needs its configured runtime identity.

    ```powershell
    az login
    ```

1. Invoke the prepared guardrail test on a valid provisional core draft, then on copies with a changed gap, an unknown supplier ID, and a wrong source version. Verify a tool-derived pass only for the valid draft and explicit failures for the changed copies.
1. Inspect the SDK session, deterministic tool span, authenticated source read, and correlated audit record. A model saying `passed=true` or a healthy container isn't proof the tool ran.

    **Expected result:** Independent, profile-specific checks control the verdict and preserve source provenance.

</details>

Congratulations! You've configured role-scoped specialists and a real deterministic checkpoint for Caldova's core decision path.
