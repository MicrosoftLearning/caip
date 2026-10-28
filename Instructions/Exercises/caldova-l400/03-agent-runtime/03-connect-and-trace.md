---
title: '03: Connect Teams and trace decisions'
layout: default
nav_order: 3
parent: 'Exercise 03: Implement and deploy the decision team'
---

# Task 03: Connect Teams and trace decisions

## Introduction

Alex's interface must reach the deployed orchestration entry point, not a similarly named prompt agent. You verify the connection protocol and follow one real request across the boundary.

## Description

In this task, you'll connect the Foundry agent, republish Procurement Desk, and trace an end-to-end decision while preserving source restrictions. **Estimated time:** 30 minutes.

## Success criteria

- Procurement questions remain local while capacity requests reach the core orchestrator.
- The Activity protocol is enabled and an actual Teams request reaches the deployed revision.
- A correlated trace proves gate-before-final behavior, correct core output, and restricted raw-data access.

## Learning resource

- [Connect to a Foundry agent from Copilot Studio](/microsoft-copilot-studio/add-agent-foundry-agent)

## Key tasks

### Key task 01: Connect the correct published runtime

The connection requires protocol support as well as the correct endpoint and agent ID.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open Procurement Desk in Copilot Studio. Select **Agents** > **Add an agent**, then select **Microsoft Foundry** under the external-agent choices.
1. Select the approved connection or create the authorized connection using the actual Foundry project endpoint. Enter the deployed orchestrator's **Agent Id**, not an SDK session ID, registry ID, or display name.
1. Use this description: `Assess Caldova LP001 launch capacity using the governed core data profile. Return evidence-backed provisional manufacturing options and unresolved readiness issues. Do not use for supplier contacts or RFP follow-up.`
1. Apply the procurement delegation addition from the [core instructions](../../../../Labfiles/04-caldova-agents/l400-core-agent-instructions.md). Keep RFP actions and core supplier identifiers separate.
1. Verify the provider's Activity endpoint preflight. This endpoint requires programmatic enablement; the portal can still display only Responses and A2A. A Responses endpoint alone isn't sufficient.
1. Test one procurement question and one core capacity question in the authoring pane. Inspect traces to verify only the capacity question reaches Foundry. If the connection reports HTTP 400 about Activity, use the tested enablement procedure rather than weakening authentication.

    **Expected result:** Routing reaches the executable new-Foundry runtime through its supported protocol.

</details>

### Key task 02: Run and trace the business request

Verify the business result and control path on the same real request.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Republish Procurement Desk and confirm the updated version in Teams. Start a new conversation with your authorized identity.
1. Submit this request to the connected service. It asks for an advisory decision, not an automatic award.

    ```input
    For core launch LP001, can Caldova cover the launch requirement internally? If not, which suppliers should Peter consider? Cite the source records, distinguish simulated operational alerts, and identify evidence still needed before quality or procurement approval.
    ```

1. Verify the 18,900-unit gap, PL003, eight delayed batches, and provisional order CMO001, CMO002, CMO006. Confirm explicit missing expiry/transfer-approval evidence and any selected replay's lead-time conflict. Don't accept fixture quantities in the answer.
1. Follow the correlation ID from Teams/Copilot Studio to the actual Foundry run. Record specialist calls, source version, deployed revision, SDK guardrail tool verdict, and final-response timestamp/order.
1. Open the cited operational references under an authorized technical identity. Verify that they support the material claims. Correlate the tool calls with source-access logs rather than treating a registry entry as proof of a read.
1. Export the real core result using the provider's adapter and retain it with the trace. Do not feed it to the fixture evaluator or manually manufacture execution fields.

    **Expected result:** One correlated request demonstrates correct core reasoning, actual execution, and the release gate.

</details>

### Key task 03: Retest boundaries after integration

A new connection can accidentally widen the data returned to the business user.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Ask Teams for raw restricted batch records and unrestricted tool details. Verify only the permitted decision summary and evidence references are returned, not restricted payloads.
1. Repeat the procurement-only source denial test and out-of-group activation test. Inspect source access and channel policy independently.
1. Ask the agent to switch to `qualification-fixture` or treat `CMO001` as `CMO-01`. Verify the production-facing endpoint refuses the profile change rather than mixing datasets.
1. Save the routing, output, access, and source-version evidence as your D3 implementation checkpoint. Record any unresolved connection failure as a defect for diagnosis, not a passed deployment.

    **Expected result:** Connecting the decision service doesn't grant Procurement Desk raw manufacturing access or expose the isolated test harness.

</details>

Congratulations! You've delivered and traced Caldova's end-to-end business interaction through the actual governed runtime.
