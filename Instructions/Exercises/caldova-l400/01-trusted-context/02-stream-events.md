---
title: '02: Replay and investigate operational signals'
layout: default
nav_order: 2
parent: 'Exercise 01: Establish trusted operational context'
---

# Task 02: Replay and investigate operational signals

## Introduction

A launch plan is a snapshot. Operational signals can reveal that the snapshot needs investigation, but they don't silently become a revised capacity plan. You retain both source meaning and event provenance.

## Description

In this task, you'll configure an Eventhouse destination, replay the supplied events, and verify a bounded set of simulated exceptions. **Estimated time:** 25 minutes.

## Success criteria

- The typed `operational_events` table receives one complete 10-event replay.
- A replay-scoped, deduplicated query returns four strict threshold breaches.
- The agent evidence distinguishes simulation, current replay time, and the frozen business plan.

## Learning resource

- [Eventstream custom endpoints](/fabric/real-time-intelligence/event-streams/add-source-custom-app)
- [Publisher](../../../../Allfiles/L300-TW-Data/event-simulator/replay_events.py) and [table/mapping/query script](../../../../Allfiles/L300-TW-Data/event-simulator/detect_operational_exceptions.kql)

## Key tasks

### Key task 01: Create the typed destination and source

Preserve the supplied event schema rather than relying on a partially inferred first event.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Create an Eventhouse in your assigned workspace and open its KQL database. Run the `.create table` statement from `detect_operational_exceptions.kql` to create `operational_events`.
1. Run the mapping statement from the same file. Confirm that `MetricValue` and `Threshold` are real numbers, `EventTime` is datetime, and the business IDs are strings.
1. Create an Eventstream with a **Custom endpoint** source. Configure the Event Hubs-compatible protocol supported by the supplied publisher.
1. Add an Eventhouse destination using the assigned KQL database, `operational_events`, and `operational_events_json` mapping. Publish the Eventstream and verify its running state.
1. Retrieve the source's connection string and entity name through the provider-approved secret mechanism. Set `EVENTSTREAM_CONNECTION_STRING` and `EVENTSTREAM_ENTITY_NAME` only in the current terminal environment. Never paste them into Git, screenshots, or agent chat.

    **Expected result:** The source is ready, the destination mapping matches all 14 fields, and only the isolated simulation identity can send events.

</details>

### Key task 02: Validate and replay the event cohort

Each publisher invocation generates new EventIDs. Select one replay cohort instead of counting everything ever received.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open a PowerShell terminal at the repository root. Create an isolated simulator environment and validate the event templates without sending anything. These commands use no cloud credential during dry run.

    ```powershell
    python -m venv .venv-caldova-stream
    .\.venv-caldova-stream\Scripts\python.exe .\Allfiles\L300-TW-Data\event-simulator\replay_events.py --dry-run
    ```

1. Verify that the dry run prints 10 JSON records and `Validated 10 simulated events.` Review their shared keys and `SourceSystem`. Dry-run EventIDs aren't the IDs of the later live replay.
1. Check whether the provider preinstalled the publisher dependency in this environment. If it is missing, install the supplied pinned manifest. This command installs the Event Hubs client, not a model SDK.

    ```powershell
    .\.venv-caldova-stream\Scripts\python.exe -m pip install -r .\Allfiles\L300-TW-Data\event-simulator\requirements.txt
    ```

1. In this same simulator terminal, use the approved secret mechanism to set `EVENTSTREAM_CONNECTION_STRING` and `EVENTSTREAM_ENTITY_NAME` if they are not already set. Run the live publisher once. The process is bounded and exits after sending the cohort.

    ```powershell
    .\.venv-caldova-stream\Scripts\python.exe .\Allfiles\L300-TW-Data\event-simulator\replay_events.py --delay-seconds 0.5
    ```

1. Record the common `SIM-` replay prefix from the actual sent IDs, start time, and completion message. If the destination wizard needs a priming event, use `--prime` first, then treat the subsequent full replay as a separate cohort.

    **Expected result:** The live command reports 10 sent events. A send message is not yet proof that the destination ingested them.

</details>

### Key task 03: Verify exceptions without double counting

Use a one-replay filter and event identity to prevent retries from inflating the result.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Query `operational_events` in the KQL database. Copy the actual replay prefix from the previous step into the query filter. This query groups matching replay prefixes so you can select exactly one cohort without inventing a new identifier.

    ```kql
    operational_events
    | where SourceSystem == "CaldovaLabSimulator"
    | extend Replay = tostring(split(EventID, "-")[1])
    | summarize UniqueEvents=dcount(EventID), FirstEvent=min(EventTime) by Replay
    | order by FirstEvent desc
    ```

1. Filter the table to the selected replay, deduplicate with `summarize arg_max(EventTime, *) by EventID`, and run the supplied LP001 threshold query over that result. Keep the condition `MetricValue > Threshold`, not `>=`.
1. Verify the four breaches: utilization 112 and 118 at PL003, deviation count 3 at PL003, and CMO006 lead time 9. The deviation count of 1 equals its threshold and isn't a breach. The final utilization 109 is below threshold.
1. Compare the CMO006 event's nine-week lead time with the core supplier's eight-week value. Record a simulated freshness conflict requiring source-owner review. Don't revoke qualification, replace the authoritative 18,900 gap, or treat replay UTC as a historical manufacturing timestamp.
1. If counts differ, inspect the selected cohort, Eventstream status, mapping, ingestion delay, and duplicates before replaying again. Retain the query and actual results as evidence.

    **Expected result:** One cohort has 10 unique events and four breaches. Any additional replay remains separately identifiable.

</details>

Congratulations! You've implemented a traceable simulation path and separated operational alerts from Caldova's authoritative launch-capacity decision.
