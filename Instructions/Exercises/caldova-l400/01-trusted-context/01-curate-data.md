---
title: '01: Curate and verify the core data'
layout: default
nav_order: 1
parent: 'Exercise 01: Establish trusted operational context'
---

# Task 01: Curate and verify the core data

## Introduction

Peter's decision depends on the launch plan, not on whichever capacity field an agent happens to retrieve first. The core files describe a multinational operational estate, while Caldova's UK policy concerns approved processing and regulated-data handling.

## Description

In this task, you'll establish the source manifest, load six core CSVs into a Lakehouse, and validate the LP001 baseline. **Estimated time:** 25 minutes.

## Success criteria

- Six typed Delta tables contain 318 rows and pass the supplied relationship checks.
- LP001 reports 270,000 target units, 251,100 qualified units, an 18,900-unit gap, and PL003 as its binding plant.
- The evidence manifest distinguishes core data from the isolated qualification fixture.

## Learning resource

- [Core curation notebook](../../../../Allfiles/L300-TW-Data/notebooks/curate_caldova_tables.ipynb)
- [Core business definitions](../../../../Allfiles/L300-TW-Data/agent/business-context-instructions.txt)

## Key tasks

### Key task 01: Establish your working copy and source manifest

Identify exactly which assets you use before creating cloud resources.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open VS Code and use **Git: Clone** from **Ctrl+Shift+P** to clone `https://github.com/hopero929/caip.git` if you don't already have the provider's working copy. Open the folder and select the provider-approved `L400-unify-data` revision. Don't discard local changes to switch revisions.
1. Open the [workshop introduction](../index.md) and the private provider handout. Verify the assigned workspace, identities, approved regions, and evidence store. Record the repository commit and the start time in UTC.
1. Inspect `Allfiles\L300-TW-Data\data\core`. Record the six filenames, their primary keys, and the expected table mapping: launch program to `launch_program`, products to `product`, plants to `plant`, manufacturing capacity plan to `capacity_plan`, manufacturing batch schedule to `batch`, and procurement CMO evaluation to `supplier`.
1. Record `core` as the main profile. Record the JSON fixture under `Labfiles\04-caldova-agents\data` as a separate repair harness. Compare the dates, IDs, and quantities in the workshop's profile table.
1. Verify that your source manifest doesn't claim the core plants are all in the UK. Keep actual processing-location approval as a separate requirement.

    **Expected result:** The manifest identifies the correct source version and preserves the distinction between country fields, processing residency, and fixture data.

</details>

### Key task 02: Curate the source tables

Use the supplied notebook rather than manually inferring CSV types.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open the assigned workspace in [Microsoft Fabric](https://app.fabric.microsoft.com). Create a learner-owned Lakehouse named `caldova_l400` in the approved capacity. Record its actual item ID. Don't reuse a production Lakehouse.
1. Create a `caldova-data` folder under the Lakehouse's **Files** area and upload all six files from `Allfiles\L300-TW-Data\data\core`. Keep their names unchanged.
1. Import `Allfiles\L300-TW-Data\notebooks\curate_caldova_tables.ipynb` into the workspace and attach `caldova_l400` as its default Lakehouse.
1. Inspect the notebook's `DATA_ROOT` and explicit schemas. Confirm the path is `/lakehouse/default/Files/caldova-data`. Review the date conversion for ordinal supplier audit dates and the table-overwrite behavior before you run it.

    > **Warning:** The notebook overwrites its six named tables. Run it only against your isolated Lakehouse.

1. Run the notebook cells in order and inspect the row-count and relationship-validation output. Expect 10 launch programs, 25 products, five plants, 60 capacity plans, 212 batches, and six suppliers.
1. Inspect date columns for failed conversions. The supplied supplier cell uses doubled backslashes in raw regular expressions, which can prevent removal of ordinal suffixes and normalization of `Sept`. Capture the failure or null result, then remove the original `LastAuditDate` `.withColumn` transformation from the supplier CSV-read chain so `supplier` retains the source strings. Add this standalone transformation immediately after that read and before its `write_table` call. It normalizes source text without changing the business date. Rerun the cell and verify all six audit dates are non-null, including September 22, 2025 for CMO002.

    ```python
    supplier = supplier.withColumn(
        "LastAuditDate",
        F.to_date(
            F.regexp_replace(
                F.regexp_replace("LastAuditDate", r"(?i)(?<=\d)(st|nd|rd|th)", ""),
                r"(?i)\bSept\b", "Sep",
            ),
            "d MMM yyyy",
        ),
    )
    ```

    Replace the original transformation in the CSV-read chain rather than applying this code after the date has already become null. Preserve the source CSVs and retain the before/after evidence. If your prepared notebook already contains the reviewed correction, verify it instead of applying it twice.

    **Expected result:** All six tables are present, their counts sum to 318, and the tested foreign-key relationships have no orphans.

</details>

### Key task 03: Verify the decision baseline

The notebook's final queries are the reference for operational quantities and provisional supplier selection.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Run the notebook's final decision-query cell. Verify LP001, P101, the November 26, 2026 launch date in `launch_program`, the 18,900-unit gap, PL003, and eight delayed batches.
1. Compare the three LP001 capacity-plan rows with the launch plan. Note the negative availability and the separate utilization observations. Don't sum all 60 rows or treat utilization percentage as units.
1. Review the supplier query. Confirm that eligible rows satisfy sufficient capacity, `Currently valid`, zero critical findings, and `FastTrackEligible = Yes`, in order CMO001, CMO002, CMO006.
1. Record that the dataset lacks qualification-expiry dates and complete transfer approvals. Mark final approval through launch **Blocked pending quality evidence**, not passed because the supplier is currently valid.
1. Save the notebook outputs, source manifest, and item IDs in your approved evidence store. Compare them with the success criteria before proceeding.

    **Expected result:** Your baseline is reproducible from the core files and doesn't contain the repair fixture's 4,500 or 2,500-unit quantities.

</details>

Congratulations! You've established Caldova's authoritative operational baseline and a reproducible source manifest for the decision team.
