---
title: '02: Implement and test follow-up actions'
layout: default
nav_order: 2
parent: 'Exercise 02: Build the procurement entry point'
---

# Task 02: Implement and test follow-up actions

## Introduction

Alex should be able to record an RFP follow-up without changing supplier qualification. A retry must not create duplicate work or a fabricated success receipt.

## Description

In this task, you'll bind the prepared append-only action and test confirmation, idempotency, and invalid requests. **Estimated time:** 20 minutes.

## Success criteria

- A confirmed open-RFP request creates one real FollowUpRequests item and receipt.
- Repeating the same client request ID returns the existing receipt without a duplicate.
- A rejected or failed request creates no new item and doesn't claim success.

## Key tasks

### Key task 01: Bind the approved action

Use the supplied flow contract rather than granting general list-edit permissions.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open **Tools** for Procurement Desk and add the provider-prepared `RecordFollowUp` agent flow.
1. Map `rfp_id`, `request_text`, and `client_request_id` to the flow's actual inputs. Inspect its receipt result and error path.
1. Review the flow with the provider: it validates an open RFP and appends a FollowUpRequests item with receipt ID, RFP ID, requester, UTC timestamp, request text, and client request ID.
1. Verify that its connection cannot update supplier qualification or manufacturing records. Confirm that duplicate client IDs return the existing item rather than executing another write.
1. Save the tool configuration and confirm that agent instructions require the requester to identify an RFP and confirm the follow-up before execution.

    **Expected result:** The action's write boundary is append-only and independently enforced.

</details>

### Key task 02: Test confirmation and safe retry

Use an unused request ID for your learner so another learner's existing receipt doesn't mask a failed write.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Select an open RFP from your actual list. Ask the agent to record a follow-up for RFP-01 requesting launch-window availability, using a client request ID formed from your assigned learner alias plus `-FOLLOWUP-01`.
1. Withhold confirmation first. Verify no FollowUpRequests item is added. Then confirm the same requested action.
1. Open the actual list and verify one new item, its requester, RFP reference, timestamp, request text, and receipt. Match the receipt to the agent result.
1. Submit the identical confirmed request with the same client request ID. Verify the existing receipt is returned and the item count doesn't increase.
1. Save the action trace, receipt reference, and before/after counts in the approved evidence store. Exclude sensitive request text if the provider's evidence policy requires it.

    **Expected result:** One approved action produces one item, and a retry doesn't duplicate it.

</details>

### Key task 03: Test rejection without false success

Invalid input and tool errors must remain visible to the requester.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Ask for a follow-up against a nonexistent RFP ID with a new client request ID. Verify rejection and no new item.
1. Ask the agent to mark a supplier qualified through this flow. Verify it has no such tool capability and creates no follow-up as a substitute unless you separately request and confirm one.
1. Use the provider's isolated flow-failure test, if supplied, and verify an explicit failure response with no fabricated receipt. If no safe failure test exists, mark that test **Not run**.
1. Record the expected rejection separately from an unexpected tool failure. Keep both in the action acceptance matrix.

    **Expected result:** The agent reports what actually occurred and never substitutes a success-shaped answer for a failed write.

</details>

Congratulations! You've enabled a practical procurement action with confirmation, idempotency, and a narrow write boundary.
