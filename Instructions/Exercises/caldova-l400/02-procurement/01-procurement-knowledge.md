---
title: '01: Configure procurement knowledge and boundaries'
layout: default
nav_order: 1
parent: 'Exercise 02: Build the procurement entry point'
---

# Task 01: Configure procurement knowledge and boundaries

## Introduction

Alex needs a reliable view of supplier contacts and RFP status. Procurement knowledge doesn't establish manufacturing qualification, and the agent must not gain broad operational access merely because Alex can author it.

## Description

In this task, you'll create Procurement Desk, attach approved knowledge, and test citations and refusal behavior. **Estimated time:** 25 minutes.

## Success criteria

- Procurement Desk answers an open-RFP question using resolvable procurement citations.
- It has only the approved supplier directory and RFP knowledge sources.
- It reports an unavailable decision service rather than inventing a capacity answer.

## Learning resource

- [Procurement agent instructions](../../../../Labfiles/04-caldova-agents/agent-instructions.md)
- [Supplier directory](../../../../Labfiles/04-caldova-agents/data/approved-suppliers.md) and [RFP seed](../../../../Labfiles/04-caldova-agents/data/rfp-tracker.csv)

## Key tasks

### Key task 01: Create the business-owned entry point

Keep the agent's purpose narrow until the governed decision service is connected.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open [Copilot Studio](https://copilotstudio.microsoft.com) with the assigned procurement authoring identity and select the isolated training environment from the provider handout.
1. Create an agent named `Caldova Procurement Desk` in your assigned solution or use the empty learner-specific starter. Record its actual ID so display-name duplication doesn't confuse later registry matching.
1. Apply the `Caldova Procurement Desk` instructions from `Labfiles\04-caldova-agents\agent-instructions.md`. Don't apply the fixture's capacity instructions to the procurement agent.
1. Review the provider-approved authentication settings. Preserve user/source authorization and don't enable anonymous access as a shortcut.
1. Save the agent. Confirm that it currently has no connected Foundry agent, manufacturing connector, public crawler, or broad organizational knowledge source.

    **Expected result:** The agent is scoped to procurement and cannot yet claim to execute a capacity decision.

</details>

### Key task 02: Ground answers in approved procurement sources

Use the prepared SharePoint items, not a local file attachment mistaken for a live governed source.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open the prepared procurement SharePoint site from the handout. Locate the approved supplier directory and RFP list seeded from the supplied assets. Verify RFP-01 and RFP-02 and their current status in the actual list.
1. Add only these approved procurement sources to the agent's **Knowledge** configuration. Confirm the source access identity and wait for indexing/readiness as required by the supported connector.
1. Test `Which RFPs are open, and who should Alex contact? Cite the RFP and supplier records.` Open the citations and compare the answer with the source list.
1. Test `Does being in the supplier directory prove that a supplier is qualified for manufacturing?` Verify that the answer distinguishes directory membership from quality approval.
1. Inspect the core supplier IDs alongside the procurement fixture IDs. Confirm that the agent doesn't equate `CMO001` and `CMO-01` or claim RFP-01 belongs to the top core supplier without an approved crosswalk.

    **Expected result:** Answers have correct procurement references and no inferred manufacturing qualification or cross-profile mapping.

</details>

### Key task 03: Verify the access and delegation boundary

A refusal is useful only when permissions also prevent the underlying access.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Ask `Show me the raw plant and batch records behind the launch gap.` Verify that Procurement Desk does not disclose restricted records.
1. Use the provider's authorized source-access test with the same procurement-only identity. Retain the actual denied read and inspect whether any alternate connection bypasses the restriction.
1. Ask `Can Caldova close the 7% launch-capacity gap internally?` Verify that the agent reports the decision service is not connected. Don't accept a plausible answer from model memory.
1. Save the agent version, source IDs, citation check, and denied-access evidence. Record a defect if it can read the restricted source even when its prompt says it cannot.

    **Expected result:** Procurement data is useful, manufacturing access remains restricted, and the unavailable runtime is reported explicitly.

</details>

Congratulations! You've built Alex's procurement entry point without using prompt instructions as a substitute for source authorization.
