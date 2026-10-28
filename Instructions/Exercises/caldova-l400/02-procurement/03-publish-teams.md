---
title: '03: Publish and verify audience access'
layout: default
nav_order: 3
parent: 'Exercise 02: Build the procurement entry point'
---

# Task 03: Publish and verify audience access

## Introduction

A test-pane success doesn't prove that Alex can use the published agent or that unrelated users are excluded. You test the actual business channel and its audience.

## Description

In this task, you'll publish Procurement Desk to the assigned Teams group and verify positive and negative access. **Estimated time:** 15 minutes.

## Success criteria

- An authorized Teams user can invoke the published agent and open its procurement citations.
- An out-of-group test user cannot activate the agent under the assigned availability policy.
- Published version and audience evidence are recorded without confusing activation with source authorization.

## Learning resource

- [Publish an agent to Teams](/microsoft-copilot-studio/publication-add-bot-to-microsoft-teams)

## Key tasks

### Key task 01: Publish to the training audience

Use the provider-approved publication path and don't make the agent organization-wide.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Review the agent's knowledge and action configuration, then select **Publish**. Record the published version and UTC time.
1. Open **Channels** > **Teams and Microsoft 365 Copilot** and use the provider-approved installation/publication route for the isolated tenant.
1. Restrict availability to the prepared `Caldova Launch Team` group using the provider's supported administration surface. Obtain scoped administrator approval if required.
1. Install or open the agent in Teams with the in-group test identity. Verify the name and published revision rather than testing an older installation.

    **Expected result:** The published entry point is available only through the approved training channel and audience configuration.

</details>

### Key task 02: Validate the published experience

Test the same boundaries outside the authoring pane.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Ask the open-RFP question from Teams. Verify the cited records and confirm the response comes from Procurement Desk.
1. Ask the launch-capacity question again. Verify that the decision service remains explicitly unavailable until Exercise 03 connects it.
1. Test activation with the provider's out-of-group identity after policy propagation. Capture the actual denial or unavailability result. Don't infer a denial solely from a missing search result.
1. Verify that channel activation hasn't changed manufacturing-source access. Keep audience access and source permissions as separate acceptance rows.
1. Save the publication ID/version, audience assignment, authorized interaction, and denied activation. Keep the agent deployed for the next exercise.

    **Expected result:** Teams behavior matches the published configuration, and access boundaries remain intact.

</details>

Congratulations! You've delivered a scoped business interface ready to connect to Caldova's governed technical runtime.
