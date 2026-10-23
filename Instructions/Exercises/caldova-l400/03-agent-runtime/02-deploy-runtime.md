---
title: '02: Implement and deploy gated orchestration'
layout: default
nav_order: 2
parent: 'Exercise 03: Implement and deploy the decision team'
---

# Task 02: Implement and deploy gated orchestration

## Introduction

An agent description doesn't execute handoffs or enforce a release gate. You implement those controls in the prepared runtime and deploy your reviewed revision.

## Description

In this task, you'll complete conditional orchestration, test failure paths, and deploy an isolated runtime revision with rollback evidence. **Estimated time:** 40 minutes.

## Success criteria

- Runtime code executes the required call order and conditional sourcing.
- Missing, unsuccessful, timed-out, or cross-profile guardrail verdicts never release an unchecked draft.
- A deployed revision returns an LP001 core decision with real trace and version evidence.

## Key tasks

### Key task 01: Implement the control flow in code

Use the actual functions and typed clients in the provider package. Don't create a parallel prompt-only workflow.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open the provider's editable runtime package in VS Code. Identify its orchestration entry point, typed result models, specialist invocation helper, error/logging helper, test command, and deployment manifest.
1. Compare the existing implementation with the seven-step acceptance algorithm in the [core configuration](../../../../Labfiles/04-caldova-agents/l400-core-agent-instructions.md). Mark the missing handoffs and release checks in your working copy.
1. Use GitHub Copilot to propose a surgical implementation using this request. Review the proposed diff yourself before applying it.

    ```prompt
    In this prepared Caldova runtime, implement the core-profile acceptance algorithm using the existing typed clients and helpers. Call Current Capacity, call CMO Analysis only for a complete positive gap, then create a COO draft and invoke Compliance Guardrail before any final response. Require the actual deterministic tool verdict, matching trusted profile/source version, and required evidence. A missing/failed/error verdict or timeout must return Needs review with standard logging, never the unchecked draft. Run the guardrail for internal-only and unresolved cases too. Preserve API contracts and identity boundaries. Add tests with existing test tooling; don't invent SDK calls, credentials, source data, or successful traces. Show the diff for review.
    ```

1. Review and apply the change. Verify no exception path, streaming path, or early return exposes the draft before the gate. Validate required fields rather than treating a missing Boolean as success. Save with **Ctrl+S**.
1. Bind the server-side profile to `core` for the production-facing lab endpoint. Keep fixture selection restricted to the provider's isolated test endpoint. Preserve version and correlation IDs in the exporter.
1. Run the exact unit/type-check command documented for the provider package. Retain the command, result, and revision. If the package doesn't supply executable source and tests, mark this task **Blocked**.

    **Expected result:** The change implements control flow in executable code, with tests that exercise positive and failure paths.

</details>

### Key task 02: Test release and failure paths

A valid rejection is as important as a valid provisional recommendation.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Run the normal LP001 core request. Verify Current Capacity, CMO Analysis, COO draft, guardrail, then final output in that order.
1. Use the provider's isolated internal-sufficient test double. Verify sourcing is skipped while the guardrail still runs. Label this a control-flow test, not a change to the real LP001 source.
1. Use the safe unresolved-source test double. Verify unknown quantities remain explicit and the final answer requests data-owner resolution rather than inventing capacity.
1. Exercise missing verdict, `passed=false`, timeout, and profile/source-version mismatch using the provider's bounded test hooks. Verify **Needs review**, a logged reason, and no unchecked final recommendation for every case.
1. Verify that tool execution order and IDs come from runtime spans, not from JSON fields supplied by the model. Preserve the test results for the deployed-version comparison.

    **Expected result:** Correctness and safety checks cover every result path, not only the normal LP001 answer.

</details>

### Key task 03: Deploy and prove the deployed behavior

Deploy the reviewed artifact, then verify execution rather than relying on deployment status.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Review the provider's tested deployment command, working directory, package manifest, identity configuration, target project, and rollback command. Record the previous revision/image digest before changing it.
1. Configure the approved project endpoint, model deployment, ontology/data connections, core policy, source snapshot, and audit destination through the package's documented configuration names. Use managed identity or the documented Entra credential chain. Do not add model API keys.
1. Build and deploy using the exact commands in the private handout. Record the actual commands with secret arguments redacted, their result, image digest or version, and UTC time. Do not substitute a guessed generic command.
1. Wait for readiness and run the package's authenticated health/smoke test. Invoke LP001 through the deployed endpoint and inspect a new trace with your actual deployed revision.
1. Verify the core contract fields, ordered provisional suppliers, `CORE-LP001-v1`, source version, guardrail tool span, and audit record. Repeat one safe failed-verdict test against the isolated deployed revision.
1. Compare local and remote behavior. If remote behavior still uses old code, inspect image digest, deployment target, loaded module, and connection version before altering prompts. Retain the rollback command and known-good revision for Exercise 04.

    > **Tip:** If the model rate limit is exceeded, wait a few seconds and retry. Record the retry separately from the measured request and don't claim an incomplete run succeeded.

    **Expected result:** An actual deployed revision executes the reviewed algorithm and fails closed, with evidence linking source, identity, and version.

</details>

Congratulations! You've implemented and deployed Caldova's gated orchestration rather than merely describing an agent team.
