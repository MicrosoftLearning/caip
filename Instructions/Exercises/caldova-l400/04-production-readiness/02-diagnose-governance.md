---
title: '02: Diagnose integration and governance failures'
layout: default
nav_order: 2
parent: 'Exercise 04: Troubleshoot, optimize, and validate'
---

# Task 02: Diagnose integration and governance failures

## Introduction

A failed decision can originate in protocol configuration, stale code, permissions, or invalid evidence. Jordan must identify the failing boundary before making a corrective change.

## Description

In this task, you'll resolve one provider-seeded integration incident, verify agent ownership and source-access evidence, and test a harmless governance block. **Estimated time:** 30 minutes.

## Success criteria

- One integration incident has a reproducible symptom, evidence-backed cause, bounded corrective action, and successful retest.
- Six logical agents have real ownership and runtime-identity mappings.
- The isolated unapproved scraper is blocked, its invocation is denied, and permitted core decisions still work.

## Learning resource

- [Agent registry](/microsoft-365/admin/manage/agent-registry)
- [Connected Foundry agent prerequisites](/microsoft-copilot-studio/add-agent-foundry-agent)

## Key tasks

### Key task 01: Isolate and correct an integration incident

Ask the provider to enable exactly one safe incident on your isolated revision. Don't randomly break a shared integration.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Reproduce the assigned failure with the original request. Record UTC time, channel, correlation/run ID, selected profile, source version, and deployed tool revision before making changes.
1. Follow the trace to the first failed boundary. Use this table to select a targeted diagnostic, not a speculative configuration reset.

    | Symptom | Evidence to inspect | Corrective action |
    | --- | --- | --- |
    | HTTP 400 mentions Activity | Connected agent ID and programmatic protocol configuration | Apply the provider-tested Activity enablement and retest the same connection |
    | Version-not-found HTTP 404 | Project generation, agent/version ID, published entry point | Restore the correct new-Foundry published ID, not a similarly named prompt agent |
    | Source access denied | Actual connection identity, source permission, audit event | Restore only the documented source grant for that identity; never broaden tenant access |
    | Old shortlist after repair | Image digest, packaged module, selected function revision | Deploy or select the reviewed artifact and confirm the next tool span uses it |
    | Duplicate event breaches | Replay scope, EventIDs, ingestion retries | Restrict to one cohort and deduplicate; don't raise the threshold to hide duplicates |
    | Guardrail timeout | Tool span/error and bounded retry policy | Restore the tool or approved timeout; preserve Needs review until a valid verdict exists |

1. State a root-cause hypothesis in the incident log and attach the trace/source evidence that supports it. Distinguish a failed connection from a denied policy decision.
1. Apply only the provider-authorized fix or restore the known-good configuration. Record what changed and which rollback restores it. Don't rotate unrelated credentials or disable the guardrail.
1. Repeat the original request and one adjacent negative test. Verify the intended behavior and the absence of an access or profile-isolation regression.

    **Expected result:** The corrective action resolves the evidenced cause rather than masking the symptom.

</details>

### Key task 02: Verify ownership and actual runtime identity

Registry IDs, application IDs, Foundry IDs, and runtime Entra identities are different identifiers.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open the assigned administration surface in the [Microsoft 365 admin center](https://admin.microsoft.com). Locate **Agents** > **All agents** > **Registry**, or the provider's currently supported equivalent.
1. Locate Procurement Desk, Capacity Decision Orchestrator, Current Capacity, CMO Analysis, COO Recommendation, and Compliance Guardrail through the supported integration map. Don't assume internal helpers automatically become registry entries.
1. Record each logical name, accountable owner/sponsor, publisher, registry record ID, Foundry ID/version, and actual runtime identity. Resolve missing mappings with the provider rather than copying display names into identity fields.
1. Correlate one real decision with tool identities and source-access records. Verify that the observed identities match the approved connection map and have no unexpected write grants.
1. Export the provider-normalized `registry.json` for fixture evaluation. Preserve the six exact logical names from the original pack and unique runtime identity mappings. Don't hide genuinely distinct identities while removing duplicate lifecycle rows.

    **Expected result:** Ownership and observed execution are traceable without treating inventory metadata as a data-access log.

</details>

### Key task 03: Block the isolated unapproved agent

Use only the provider's harmless training object and retain an actual denial test.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Locate `Unapproved CMO Scraper`. Verify its training-only identity, owner, lack of live crawling, and isolation from every other learner's workflow.
1. Apply **Block** using your scoped administrator identity. Wait for the provider's documented propagation interval and verify the recorded state.
1. Run the provider's harmless invocation test. Retain the denial response and identity evidence. A registry label alone isn't a complete denial test.
1. Run an authorized LP001 core decision and repeat the training-group access test. Confirm the authorized workflow still operates and the blocked identity never appears in its actual invoked IDs.
1. Compare actual data-processing/storage locations with Caldova's UK requirement. Record cross-geo, preview-support, expiry evidence, electronic-record controls, retention, and human approval as unresolved release items where appropriate.

    **Expected result:** The unwanted agent is denied without disrupting the permitted workflow or overstating regulatory compliance.

</details>

Congratulations! You've diagnosed an integration boundary and verified governance through execution evidence, not just agent descriptions or inventory labels.
