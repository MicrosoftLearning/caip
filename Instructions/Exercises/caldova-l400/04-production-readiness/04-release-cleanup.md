---
title: '04: Record readiness and clean up'
layout: default
nav_order: 4
parent: 'Exercise 04: Troubleshoot, optimize, and validate'
---

# Task 04: Record readiness and clean up

## Introduction

Peter needs to understand both the provisional recommendation and the evidence that still prevents a production release. Jordan must leave the training estate in a known state without deleting shared resources.

## Description

In this task, you'll complete the release-readiness record, explain the customer outcome, and remove or restore assigned resources. **Estimated time:** 20 minutes.

## Success criteria

- A reviewer can trace customer requirements to implementation, incidents, corrective actions, versions, and validation evidence.
- The release decision states unresolved technical, data, regional, and regulatory requirements explicitly.
- Assigned billable/test resources and temporary credentials are removed or restored, with evidence retained according to policy.

## Key tasks

### Key task 01: Make the readiness decision

A completed workshop and an approved customer production release are different conclusions.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open your requirements matrix and link each row to actual evidence. Use **Passed**, **Failed**, **Blocked**, or **Not run** and identify an owner for every unresolved row.
1. Complete the following release gates. Don't use a failed or missing gate as an opportunity to weaken its threshold.

    | Gate | Required acceptance evidence |
    | --- | --- |
    | Core correctness | Exact LP001 baseline and provisional supplier order, eight delayed batches, and selected simulation cohort |
    | Runtime safety | Independent profile-specific verdict before every final output, with safe failed/missing/timeout/version-mismatch behavior |
    | Deployment | Actual reviewed revision, runtime identity, authenticated smoke test, source version, and usable rollback |
    | Access and actions | Verified procurement source boundary, training-group restriction, denied scraper, and idempotent follow-up receipt |
    | Repair and evaluation | Passing local repair/boundary tests, actual remote repair, separate 24-check fixture result, and required supported evaluator results |
    | Optimization | Recorded before/after cohort and thresholds, all safety gates retained, or verified rollback when improvement isn't established |
    | Customer readiness | Accountable quality/approval owners, expiry/transfer evidence, actual regional/data-flow approval, retention/audit design, and supported service/preview decision |

1. Record **Not approved for customer production release** if any required production evidence is unresolved. Name the specific blocker and owner rather than asserting that Agent 365 or a passed guardrail establishes GxP, GMP Annex 11, or 21 CFR Part 11 compliance.
1. Verify that the evidence pack identifies which activities you implemented, which checkpoint work was restored, and which activities were blocked or only observed.
1. Ask another learner or the instructor to locate one material claim's source record, one incident's corrective deployment, and the known-good rollback target from your evidence pack without using credentials.

    **Expected result:** The release decision is auditable and doesn't confuse training acceptance with validated regulated production operation.

</details>

### Key task 02: Explain the business outcome and remaining work

Demonstrate the two workshop outcomes through concrete artifacts, not an unmeasured return-on-investment claim.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Write a short implementation summary for Peter: the core profile identifies an 18,900-unit gap and prioritizes provisional external options while retaining evidence and routing approval to the right humans.
1. Summarize one incident using symptom, cause, corrective change, deployed version, and successful retest. State separately whether the optimization met its declared threshold or was rolled back.
1. Explain the role boundary for each product: Copilot Studio for business interaction/actions, Foundry for agent runtime/tracing/evaluation, GitHub Copilot for reviewed development and the separate SDK harness, Fabric IQ for operational meaning, Foundry IQ for approved policy, and Agent 365 for administration.
1. Identify what remains before production, including actual source freshness, complete qualification/transfer evidence, region/data-flow approval, human authority, retention, monitoring, operational ownership, and service supportability.
1. Save the final summary with links to both the implemented/deployed solution evidence and the troubleshoot/optimize/validate evidence. Don't claim measured time savings or ROI without a customer baseline.

    **Expected result:** Your summary shows both requested learning outcomes and clearly states the remaining customer responsibilities.

</details>

### Key task 03: Remove or restore only your assigned resources

Preserve approved evidence first. Shared resources and administrator-required blocks must remain intact.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Copy required evidence to the approved retention store and confirm you can open it. Exclude secrets and restrict sensitive trace/source exports.
1. Unpublish/remove your Teams installation and isolated Procurement Desk using the provider procedure. Remove your test follow-up items only after the retention check. Don't delete the shared supplier directory or qualification evidence.
1. Stop/delete your hosted runtime and fixture revisions, model deployments you exclusively own, and isolated connections using the provider's tested cleanup command. Verify no billable running revision remains assigned to you.
1. Stop the Eventstream source or revoke/rotate its training credential as directed. Clear the current terminal's simulation credential variables with these commands, which do not display their values.

    ```powershell
    Remove-Item Env:\EVENTSTREAM_CONNECTION_STRING -ErrorAction SilentlyContinue
    Remove-Item Env:\EVENTSTREAM_ENTITY_NAME -ErrorAction SilentlyContinue
    ```

1. Delete your dedicated Fabric workspace/items and dedicated Azure resource group only if the provider confirms exclusive ownership. For shared groups, have the provider remove only your named resources. Don't reset shared capacities or unblock the scraper contrary to administrator policy.
1. Remove temporary grants and local result exports after the retention check. If you activated any Python environment, run `deactivate`; the explicit interpreter paths in these tasks don't require activation. Sign out of lab accounts and retain the reviewed code changes according to the provider's submission process.
1. Verify the final resource inventory against the starting handout and record cleanup or restoration results and any provider-owned pending item.

    **Expected result:** Evidence remains available to authorized reviewers, while training-only resources and credentials don't remain active unintentionally.

</details>

Congratulations! You've implemented and deployed an evidence-backed agent solution, diagnosed and corrected implementation issues, and assessed its technical readiness without overstating production approval.

## Summary

You have successfully completed this exercise when the applicable task evidence is present and unresolved activities are labeled. You practiced core-data grounding, simulation-aware decisions, bounded actions, gated deployment, fault isolation, remote repair validation, controlled optimization, and accountable release assessment.
