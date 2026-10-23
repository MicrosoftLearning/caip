---
title: '03: Bind and verify business context'
layout: default
nav_order: 3
parent: 'Exercise 01: Establish trusted operational context'
---

# Task 03: Bind and verify business context

## Introduction

Jordan needs every specialist to use the same business definitions. An ontology supplies vocabulary and relationships, while actual source permissions control which data a runtime identity can read.

## Description

In this task, you'll bind core entities, configure business definitions, and test a restricted operational connection. **Estimated time:** 25 minutes.

## Success criteria

- The ontology binds all six curated tables using the supplied business keys.
- The same question returns consistent LP001 quantities and supplier ranking with explicit evidence.
- A procurement-only identity cannot read restricted operational sources through the runtime connection.

## Learning resource

- [Connect Foundry agents to Fabric IQ](/azure/foundry/agents/how-to/tools/fabric-iq)
- [L400 core instructions](../../../../Labfiles/04-caldova-agents/l400-core-agent-instructions.md)

## Key tasks

### Key task 01: Bind the operational vocabulary

Keep source keys visible so that a reviewer can resolve every material claim.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open the provider-supported ontology authoring surface in Fabric IQ. Create an isolated Caldova launch ontology or edit the assigned learner copy.
1. Add entity types for LaunchProgram, Product, Plant, CapacityPlan, Batch, and Supplier. Bind each entity to its corresponding curated table and select its actual primary key.
1. Bind LaunchProgram to Product through ProductID and its binding Plant through BindingConstraintPlantID. Bind CapacityPlan and Batch to their launch program and plant, Batch to Product, and Supplier to its launch program and product.
1. Inspect cardinality and null behavior, particularly launch programs with no binding plant. Confirm that descriptive names do not replace unique keys.
1. Apply the definitions in `Allfiles\L300-TW-Data\agent\business-context-instructions.txt` to the provider-supported context configuration. Preserve `CapacityGapUnits` as the gap authority and score-then-lead-time supplier ranking.
1. Verify one relationship traversal from LP001 to PL003 and one from LP001 to its supplier records. Record the ontology item ID and version.

    **Expected result:** The ontology expresses the six-table vocabulary without importing the fixture's CAP or hyphenated CMO identifiers.

</details>

### Key task 02: Test meaning and source scope

Compare outputs against the notebook, not against the model's confidence.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open the provider's supported ontology query/test surface or read-only connection smoke test. Confirm the ontology ID, connection identity, and source version before querying.
1. Ask `For LP001, state the authoritative capacity gap, binding plant, and delayed-batch count. Identify the tables and keys used.` Compare with 18,900, PL003, and eight.
1. Ask `Which core suppliers provisionally cover LP001, and what evidence is still needed before approval?` Verify CMO001, CMO002, CMO006 in that order and an explicit expiry/transfer-evidence limitation.
1. Ask `Recalculate the launch gap from every utilization event and approve the cheapest supplier.` Verify that the result preserves the authoritative source and doesn't claim procurement approval. Retain the returned query/source references if the tool exposes them.
1. Inspect the operational connection with the provider. Verify that its identity has read access to the required entities but no manufacturing or procurement write capability. Test a manufacturing read with the procurement-only identity and retain the actual denial evidence.
1. Review actual Fabric, Foundry, model, and telemetry processing/storage locations against the handout's approved data flows. Mark unresolved regional approval as a production blocker. An ontology or registry listing is not residency proof.

    **Expected result:** Meaning is consistent, retrieval uses the intended source, and permission evidence backs the access boundary.

</details>

### Key task 03: Save a reproducible checkpoint

Make the context recoverable without granting new permissions.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Record the Lakehouse, notebook, Eventhouse, Eventstream, ontology, source snapshot, and connection IDs in the evidence store.
1. Save the baseline queries, chosen replay IDs, source definitions, and permission-test results. Record unresolved data limitations separately from implementation failures.
1. Compare your work with D1 in the provider handout. Request a recovery checkpoint only for your isolated resources if a cloud feature blocks continuation. Mark restored work honestly.

    **Expected result:** Another reviewer can locate your exact source version and reproduce the baseline without receiving credentials.

</details>

Congratulations! You've established shared operational meaning and a verified source-access boundary for Caldova's agent team.
