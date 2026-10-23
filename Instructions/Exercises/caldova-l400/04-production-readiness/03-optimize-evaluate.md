---
title: '03: Optimize and evaluate without regression'
layout: default
nav_order: 3
parent: 'Exercise 04: Troubleshoot, optimize, and validate'
---

# Task 03: Optimize and evaluate without regression

## Introduction

Jordan needs evidence that a change improves the system without removing safety controls. You measure a bounded optimization and keep core acceptance separate from the fixture's deterministic scorecard.

## Description

In this task, you'll establish a small repeatable baseline, apply one reversible optimization, evaluate actual runs, and decide whether to retain it. **Estimated time:** 30 minutes.

## Success criteria

- Before/after measurements use the same prompts, profile, source snapshot, model, and safety controls.
- A retained optimization reduces duplicate retrieval calls by at least 20%, doesn't increase median end-to-end latency, and introduces zero acceptance/safety failures.
- Core acceptance and all 24 fixture checks are recorded separately, with supported built-in metrics and missing metrics explicitly identified.

## Learning resource

- [Evaluate Foundry agents](/azure/foundry/observability/how-to/evaluate-agent)
- [Fixture cases](../../../../Labfiles/04-caldova-agents/data/evaluation-cases.jsonl) and [export requirements](../../../../Labfiles/04-caldova-agents/README.md)

## Key tasks

### Key task 01: Establish a controlled baseline

Use a small engineering sample, not a claim of production throughput or a contractual service-level objective.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Freeze the deployed core revision, source snapshot, model/version, tool definitions, selected event replay, and generation settings supported by the runtime. Record them in the comparison manifest.
1. Define three prompts: the normal LP001 request; a request to explain the CMO006 simulated/core lead-time conflict; and a request to infer qualification from directory membership. Write expected quantities, uncertainty, and refusal/action boundaries before running them.
1. Run each prompt three times, with a fresh conversation per run. Exclude one separately recorded warm-up request from each revision. Record the nine real run IDs, UTC timing, end-to-end elapsed time, retrieval/tool counts, and token counts when available.
1. Inspect traces for repeated identical read-only policy or ontology retrievals within the same request. Select one duplication to eliminate using request-scoped reuse keyed by profile, source version, query, and effective authorization scope. If no duplication exists, retain the baseline and record that this optimization isn't justified.
1. Set acceptance gates before editing: at least 20% fewer total retrieval calls across the same nine-run cohort, median elapsed time no higher than baseline, all expected core results unchanged, and zero gate-order/access/profile-isolation failures.

    **Expected result:** You have a reproducible baseline and a measurable hypothesis. A performance change that fails the gates must be rolled back, not described as a win.

</details>

### Key task 02: Apply and measure one reversible change

Don't optimize by removing the guardrail or hiding errors.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Use GitHub Copilot to propose eliminating only the evidenced duplicate retrieval using existing runtime helpers. Require request-scoped lifetime, exact authorization/source/profile keys, and no caching of tool errors or guardrail verdicts.
1. Review the diff and add the provider package's regression tests for changed source versions, changed identities, failed retrievals, and separate profiles. Reject cross-request/global caching and any new path that skips validation.
1. Run the provider's exact test command and deploy the candidate to your isolated revision. Record its digest and known-good rollback target.
1. Repeat the same nine requests under the recorded settings and selected replay. Re-run failed-verdict and restricted-source negative tests separately from the latency sample.
1. Calculate `100 * (baseline_calls - candidate_calls) / baseline_calls` for the cohort and compare median elapsed times. If baseline calls are zero, mark call reduction not applicable and reject this optimization hypothesis rather than dividing by zero.
1. Compare every correctness and safety result. Retain the change only if all declared gates pass. Otherwise restore the known-good revision with the provider command and verify one core request plus a negative test. Record unavailable token counts as **Not measured**.

    **Expected result:** The decision to retain or roll back is supported by recorded measurements and unchanged safety behavior, not a subjective faster response.

</details>

### Key task 03: Evaluate the isolated repair fixture

The fixture evaluator requires exactly one real exported result for each supplied case. Performance repetitions belong in a different file.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open `data\evaluation-cases.jsonl` under the qualification pack. Use the three `query` values through the isolated repaired runtime, without putting the `expected` answer keys into model context.
1. Run `external-support`, `internal-sufficient`, and `conflicting-evidence` once each against the repaired revision. Use the provider exporter to write exactly three real records to `results\agent-results.jsonl` in the qualification-tool directory.
1. Verify the export matches the original runtime contract: typed quantities or explicit null, eligible IDs, facts/assumptions/gaps, next action, evidence-backed claims, tool-derived guardrail, and trace-derived identities/order/run ID. Add the real normalized registry export as `results\registry.json`.
1. Open a terminal at `Labfiles\04-caldova-agents\Python\qualification-tool` and run the evaluator with the environment created in the repair task. This command checks eight criteria per case, not model behavior or authenticity by itself.

    ```powershell
    .\.venv\Scripts\python.exe evaluate.py --results results\agent-results.jsonl --registry results\registry.json --output results\scorecard.json
    ```

1. Verify all 24 checks pass. Standard fixture: 4,500 internal, 2,500 remaining, CMO-01 only. Internal-sufficient: 7,500 internal, zero remaining, no CMO, guardrail still runs. Conflict: null quantities, no CMO, **Needs review**, failed guardrail and explicit resolution request.
1. Inspect the actual citations and source/audit traces yourself. A fabricated export could satisfy structural checks and is not acceptable evidence. Keep core result exports and repeated performance runs out of this three-case file.

    **Expected result:** The deterministic fixture scorecard has 24 genuine passes backed by real runtime evidence; an expected conflict rejection passes its safety expectation.

</details>

### Key task 04: Review core quality and supported model evaluations

The core operational result has its own acceptance matrix. Neither its policy nor its missing evidence is identical to POL-01.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Check the deployed core result against every [workshop acceptance criterion](../index.md), using notebook/query evidence for quantities and traces for execution. Verify the full ordered shortlist, explicit uncertainty, selected replay references, and gate-before-final behavior.
1. In the provider-supported Foundry evaluation surface, configure the approved rubric and supported built-in evaluators for the actual target. Where available, include Task Adherence, Tool Call Accuracy, and Groundedness. Use actual messages, tool calls, and retrieved context with the current field mappings, not the answer-key JSONL alone.
1. Record evaluator versions, actual score scales, per-case pass thresholds, judge deployment, and dataset before starting. Require every tested case to meet the declared thresholds and manually verify critical claims. Don't assume every evaluator uses the same numeric scale.
1. Retain run IDs and per-case results. Mark missing metrics **Not evaluated**, timed-out jobs **Pending**, and unsupported targets **Blocked**. An incomplete required metric prevents a full readiness pass even if the local 24-check rubric passes.
1. Save your optimization comparison, rollback decision, core acceptance matrix, fixture scorecard, and model-evaluation evidence. Don't claim production performance from nine runs or regulatory compliance from an evaluator score.

    **Expected result:** You can distinguish measured improvement, deterministic correctness, model-quality evidence, and unresolved release requirements.

</details>

Congratulations! You've evaluated both data profiles and made an evidence-based optimization decision without weakening Caldova's controls.
