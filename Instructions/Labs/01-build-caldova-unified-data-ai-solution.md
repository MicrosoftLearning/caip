---
lab:
    title: 'Build the Caldova unified data and AI solution'
    description: 'Implement a Microsoft Fabric solution that unifies launch data, detects an operational exception, and adds governed business context for a launch-capacity decision.'
    level: 300
    duration: 90
    islab: true
    primarytopics:
        - Microsoft Fabric
        - Real-Time Intelligence
        - Fabric IQ
        - OneLake catalog
---

# Build the Caldova unified data and AI solution

Caldova Pharmaceuticals is preparing to launch a next-generation therapy. Launch program `LP001` requires 270,000 units, but only 251,100 units of qualified capacity are available. The 18,900-unit shortfall is 7% of target volume, three plants are over plan, and fragmented operational context slows a defensible supplier decision.

In this exercise, you implement the architected solution in Microsoft Fabric. You create the Fabric foundation, curate the minimum data needed for the launch decision, stream simulated operational events, build an ontology and data agent, and review the resulting estate in OneLake catalog.

The core implementation has five timed phases:

| Phase | Time |
|---|---:|
| Understand the Caldova launch problem | 5 minutes |
| Build and populate the Fabric foundation | 30 minutes |
| Detect an operational exception | 20 minutes |
| Create business context and decision intelligence | 25 minutes |
| Review governance and security in OneLake catalog | 10 minutes |
| **Core total** | **90 minutes** |

This exercise should take approximately **90 minutes** to complete. The optional Foundry IQ bonus is not included in the 90-minute duration.

> **Note**: Ontology, Fabric data agent, and parts of Foundry IQ are in preview or active development. You may experience changed labels, temporary service limitations, or delayed initialization.

## Learning objectives

By the end of this exercise, you'll be able to:

1. Create and populate a Fabric Lakehouse and Eventhouse for a launch-readiness workload.
1. Route simulated operational events through an eventstream and detect threshold exceptions with KQL.
1. Add business meaning with an ontology and compare baseline data-agent answers with business-context-enhanced answers.
1. Inspect ownership, discovery, permissions, endorsement, and lineage in OneLake catalog.

## Prerequisites

To complete this exercise, you need:

- A Skillable lab environment with the exercise package staged at `C:\Labfiles\caldova-unified-data-ai-lab`.
- A Microsoft Fabric learner identity with permission to create a workspace on the assigned paid Fabric capacity.
- Fabric **Contributor** or higher permissions in the workspace you create.
- Microsoft Edge or Google Chrome with access to `https://app.fabric.microsoft.com`.
- Python 3.11 or later and the `azure-eventhub` package installed in the hosted environment.
- PowerShell access in the hosted environment.

> **Important**: Use only the paid Fabric capacity assigned to your lab. Do not create trial capacity or use **My workspace**.

## Understand the Caldova launch problem

Caldova needs a timely recommendation, not another disconnected analysis. Establish the decision criteria before you build so that each Fabric item has a clear purpose.

1. Review the confirmed `LP001` launch facts:

    - Target volume: **270,000 units**
    - Qualified capacity: **251,100 units**
    - Capacity shortfall: **18,900 units**, or **7%**
    - Plant utilization: `PL001` **101%**, `PL002` **105%**, and `PL003` **118%**
    - Binding plant: `PL003`
    - Delayed batches: **8**
    - Leading supplier option: Meridian Biologics, with 28,500 qualified available units, a six-week lead time, valid GMP certification, no critical findings, a quality score of 96, and a weighted score of 95

1. Identify the three questions that the implementation must answer:

    - Can internal qualified capacity meet the `LP001` target?
    - Which qualified supplier can cover the shortfall with acceptable timing and quality?
    - Does a current operational exception reduce launch confidence?

1. Record an initial hypothesis that internal capacity alone is insufficient and that Meridian Biologics is the supplier to evaluate first. Treat this as a hypothesis to validate from curated and traceable evidence, not as a procurement approval.

You now have a decision frame that connects the fragmented-data problem from Lesson 1 to an implementable outcome.

## Build and populate the Fabric foundation

Create the reusable OneLake foundation from Lesson 2. The first 15 minutes are reserved for workspace, Lakehouse, Eventhouse, and ingestion setup; the remaining time applies explicit curation and validates the decision data.

### Create the Fabric items

1. Open the [Fabric portal](https://app.fabric.microsoft.com), and sign in with the learner identity supplied for the lab.
1. Select **Workspaces** > **+ New workspace**.
1. Enter `caldova-launch-` followed by your initials as the **Name**.
1. Expand **Advanced**, select **Fabric capacity** as the license mode, select the capacity assigned by the hoster, and then select **Apply**.
1. Open the workspace, select **+ New item**, search for **Lakehouse**, and select it.
1. Enter `caldova_lakehouse`, clear **Lakehouse schemas** to keep the exercise's flat table names, and select **Create**.
1. Return to the workspace, select **+ New item**, search for **Eventhouse**, and select it.
1. Enter `caldova_events`, and select **Create**.
1. Verify that Fabric created both an Eventhouse and its default child KQL database named `caldova_events`.

> **Note**: An Eventhouse manages one or more KQL databases. Creating the Eventhouse also creates its default KQL database. For product details, see [Create an eventhouse](https://learn.microsoft.com/fabric/real-time-intelligence/create-eventhouse).

### Upload and curate the launch data

The trimmed package contains only six source files needed by the implementation. It intentionally excludes the duplicate real-time dispense data, sentiment data that doesn't exist, Azure SQL mirrored data that doesn't exist, and unrelated demo assets.

1. Open `caldova_lakehouse`, select **Files**, and create a folder named `caldova-data`.
1. Open the new folder, select **Get data** > **Upload files**, and upload all six files from `C:\Labfiles\caldova-unified-data-ai-lab\Labfiles\data\core`.
1. Return to the workspace, select **Import** > **Notebook** > **From this computer**, and import `C:\Labfiles\caldova-unified-data-ai-lab\Labfiles\notebooks\curate_caldova_tables.ipynb`.
1. Open the imported notebook, select **Add lakehouse** in the **Explorer** pane, select **Existing lakehouse**, and attach `caldova_lakehouse` as the default lakehouse.
1. Select **Run all**.
1. Wait for the final cells to report:

    ```output
    Validation passed: 318 rows across six tables; all tested relationships are valid.
    ```

    The notebook applies explicit numeric and date types, normalizes supplier audit dates, writes stable Delta table names, and verifies the business keys that the ontology will use.

1. Review the first result grid and verify these `LP001` values:

    | Field | Expected value |
    |---|---:|
    | Target launch volume | 270,000 |
    | Qualified capacity | 251,100 |
    | Capacity gap | 18,900 |
    | Capacity gap percent | 7 |
    | Binding plant | Plant 3 |
    | Delayed batch count | 8 |

1. Review the second result grid and verify that Meridian Biologics is ranked first among suppliers that satisfy the exercise's capacity, GMP, critical-finding, and fast-track filters.
1. Return to the Lakehouse and verify these six tables:

    - `launch_program`
    - `product`
    - `plant`
    - `capacity_plan`
    - `batch`
    - `supplier`

> **Important**: The notebook doesn't create an inventory measure. The package has no authoritative inventory snapshot, so released-minus-dispensed values would only be a derived estimate.

The curated Delta tables provide the stable names, types, and valid keys needed by Real-Time Intelligence, Fabric IQ, and the data agent. For the underlying portal behavior, see [Load data into Delta Lake tables](https://learn.microsoft.com/fabric/data-engineering/load-to-tables) and [Create a lakehouse](https://learn.microsoft.com/fabric/data-engineering/create-lakehouse).

## Detect an operational exception

Use Real-Time Intelligence to reduce the time between an event and an actionable exception, as introduced in Lesson 3. A supplied Python publisher sends a deterministic, clearly labeled simulation to a Fabric eventstream custom endpoint.

### Prepare the real-time destinations

1. Open the `caldova_events` KQL database.
1. Select **New** > **KQL Queryset**, and name the item `caldova_exception_queries`.
1. Open `C:\Labfiles\caldova-unified-data-ai-lab\Labfiles\event-simulator\detect_operational_exceptions.kql`.
1. Copy and run only the `.create table` command in the KQL queryset.
1. Copy and run only the `.create-or-alter table` ingestion mapping command.
1. Verify that the `operational_events` table appears with typed columns in the database.
1. Return to the workspace, select **+ New item**, search for **Eventstream**, and create `caldova_operational_stream`.
1. Select **Add source** > **Custom endpoint** in **Edit** mode, and name the source `caldova-simulator`.
1. Select **Add destination** > **Eventhouse** and configure:

    | Setting | Value |
    |---|---|
    | **Ingestion mode** | **Direct ingestion** |
    | **Destination name** | `eventhouse-operational-events` |
    | **Workspace** | Your Caldova workspace |
    | **Eventhouse** | `caldova_events` |

1. Connect the default stream to the Eventhouse destination.
1. Select **Add destination** > **Lakehouse**, and configure:

    | Setting | Value |
    |---|---|
    | **Destination name** | `lakehouse-operational-history` |
    | **Workspace** | Your Caldova workspace |
    | **Lakehouse** | `caldova_lakehouse` |
    | **Delta table** | Create `operational_event_history` |
    | **Input data format** | `JSON` |
    | **Minimum rows** | `1` |
    | **Maximum duration** | `1 minute` |

1. Connect the default stream to the Lakehouse destination.
1. Select **Publish**, and wait until the custom source and Lakehouse destination report that they're running. You configure the Eventhouse destination after one nonexception event makes the schema available for inspection.

> **Tip**: Publishing can start ingestion before routing is fully ready. Wait for both destinations to show a running state before you send the replay. Microsoft documents this behavior in [Add a lakehouse destination to an eventstream](https://learn.microsoft.com/fabric/real-time-intelligence/event-streams/add-destination-lakehouse).

### Replay and investigate the events

1. Select the `caldova-simulator` source, open its **Details**, and copy the **Connection string–primary key** and **Entity name** values for the Event Hub protocol.
1. Open PowerShell in the hosted environment.
1. Change to the simulator folder:

    ```powershell
    Set-Location 'C:\Labfiles\caldova-unified-data-ai-lab\Labfiles\event-simulator'
    ```

    This command makes the simulator files the current working context.

1. Set temporary process-level environment variables, replacing the placeholders with the values you copied:

    ```powershell
    $env:EVENTSTREAM_CONNECTION_STRING='<connection-string-primary-key>'
    $env:EVENTSTREAM_ENTITY_NAME='<entity-name>'
    ```

    The publisher reads the credentials from memory and doesn't write them to a file.

1. Send one nonexception priming event:

    ```powershell
    python .\replay_events.py --prime --delay-seconds 0
    ```

    This event gives the direct-ingestion wizard a representative JSON schema. It uses `PL001` at 101% against a 110% threshold, so it doesn't change the exception result.

1. Verify that PowerShell reports `Replay complete: 1 event sent.`
1. Return to the eventstream **Live view**, and select **Configure** on the Eventhouse destination.
1. Select the existing `operational_events` table in the `caldova_events` KQL database, retain the generated **Data connection name**, and select **Next**.
1. Select **JSON** as the format, open **Advanced**, select the existing `operational_events_json` mapping, and finish the **Get data** flow.
1. Verify that the Eventhouse destination reports a successful connection to `operational_events`.
1. Run the replay:

    ```powershell
    python .\replay_events.py
    ```

    The script sends 10 simulated events with current UTC timestamps and preserves the Caldova keys used by the curated tables.

1. Verify that PowerShell reports `Replay complete: 10 events sent.`
1. Remove the temporary credentials from the PowerShell process:

    ```powershell
    Remove-Item Env:\EVENTSTREAM_CONNECTION_STRING
    Remove-Item Env:\EVENTSTREAM_ENTITY_NAME
    ```

    This command clears the custom-endpoint credentials from the current shell.

1. Return to the eventstream **Live view**, and verify that the source and both destinations show received events.
1. Open `caldova_exception_queries`, copy the final query from `detect_operational_exceptions.kql`, and run it.
1. Verify that the query returns four threshold breaches:

    - Two `PL003` utilization observations above 110%, including 118% for batch `B1206`
    - One `PL003` quality-deviation count above its threshold
    - One `CMO006` projected supplier lead time above its threshold

1. Open `caldova_lakehouse`, refresh **Tables**, and verify that `operational_event_history` contains the replayed events after the one-minute destination interval.
1. Conclude that the `PL003` critical utilization and quality exceptions reinforce the existing internal-capacity risk. Treat the `CMO006` lead-time exception as additional evidence against prioritizing that supplier; don't interpret the simulation as a historical observation.

The same event now supports low-latency KQL investigation and durable Delta retention without double counting the historical dispense dataset. For details, see [Add a custom endpoint source](https://learn.microsoft.com/fabric/real-time-intelligence/event-streams/add-source-custom-app), [add an Eventhouse destination](https://learn.microsoft.com/fabric/real-time-intelligence/event-streams/add-destination-kql-database), and [add a Lakehouse destination](https://learn.microsoft.com/fabric/real-time-intelligence/event-streams/add-destination-lakehouse).

## Create business context and decision intelligence

Lesson 4 distinguishes raw data access from reusable business context. First establish a **baseline** with a data-grounded agent that has minimal instructions, and then ask the identical questions after adding ontology-driven context, authoritative definitions, source guidance, and examples.

### Capture the baseline answers

1. Return to the workspace, select **+ New item**, search for **Data agent**, and create `caldova_launch_agent`.
1. Select **Add a data source**, select `caldova_lakehouse`, and add the six curated tables.
1. Leave **Agent instructions** and data-source instructions empty for the baseline.
1. Ask this first baseline question:

    ```input
    For LP001, what is the capacity shortfall and which plant is the binding constraint?
    ```

1. Record the answer's numeric result, source references, and any ambiguity.
1. Ask this second baseline question:

    ```input
    Which supplier should Caldova prioritize to close the LP001 gap, and why?
    ```

1. Record which eligibility conditions and ranking fields the answer used.

> **Important**: Call this the **baseline** condition, not an ungrounded condition. The agent is data-grounded as soon as the Lakehouse source is attached; it simply has minimal business instructions and context.

### Build the Caldova launch ontology

1. Return to the workspace, select **+ New item**, search for **Ontology (preview)**, and create `caldova_launch_ontology`.
1. Select **+ Add entity type**, and create the following six entity types:

    - `LaunchProgram`
    - `Product`
    - `Plant`
    - `CapacityPlan`
    - `Batch`
    - `Supplier`

1. Open each entity type, select **Bind data**, choose `caldova_lakehouse` from the OneLake catalog, and bind the table shown:

    | Entity type | Table | Key property |
    |---|---|---|
    | `LaunchProgram` | `launch_program` | `LaunchProgramID` |
    | `Product` | `product` | `ProductID` |
    | `Plant` | `plant` | `PlantID` |
    | `CapacityPlan` | `capacity_plan` | `CapacityPlanID` |
    | `Batch` | `batch` | `BatchID` |
    | `Supplier` | `supplier` | `CMOID` |

1. Select **+ Add relationship type**, and create these relationships:

    | Relationship | Origin property | Target property |
    |---|---|---|
    | `launches` | `LaunchProgram.ProductID` | `Product.ProductID` |
    | `hasCapacityPlan` | `LaunchProgram.LaunchProgramID` | `CapacityPlan.LaunchProgramID` |
    | `plannedAt` | `CapacityPlan.PlantID` | `Plant.PlantID` |
    | `hasBatch` | `LaunchProgram.LaunchProgramID` | `Batch.LaunchProgramID` |
    | `runsAt` | `Batch.PlantID` | `Plant.PlantID` |
    | `evaluatesSupplier` | `LaunchProgram.LaunchProgramID` | `Supplier.LaunchProgramID` |

1. Save the ontology, and verify that the canvas shows six bound entities and six relationships.

The ontology represents the launch program, product, plant, capacity plan, batch, and supplier as business concepts rather than isolated tables. For the current UI and binding model, see [Create an ontology](https://learn.microsoft.com/fabric/iq/ontology/tutorial-1-create-ontology).

### Enhance and compare the agent

1. Return to `caldova_launch_agent`, select **Add a data source**, and add `caldova_launch_ontology`.
1. Open **Agent instructions**, and paste the complete contents of `C:\Labfiles\caldova-unified-data-ai-lab\Labfiles\agent\business-context-instructions.txt`.
1. Open the Lakehouse source's **Data source instructions**, and add this source description:

    ```prompt
    Caldova curated launch-readiness source. launch_program is authoritative for target, qualified capacity, gap, binding plant, and launch status. product and plant provide descriptive context. capacity_plan provides monthly plant utilization. batch provides production status. supplier provides CMO qualification, capacity, timing, quality, and ranking evidence.
    ```

    This description tells the agent when and how to use the Lakehouse rather than changing the underlying evidence.

1. Add this example question and SQL query to the Lakehouse source:

    ```input
    For LP001, what is the capacity shortfall and which plant is the binding constraint?
    ```

    ```sql
    SELECT lp.LaunchProgramID, lp.CapacityGapUnits, lp.CapacityGapPercent,
           p.PlantName AS BindingPlant
    FROM launch_program lp
    LEFT JOIN plant p
      ON lp.BindingConstraintPlantID = p.PlantID
    WHERE lp.LaunchProgramID = 'LP001';
    ```

    The example teaches the agent to treat `launch_program` as authoritative and to resolve the plant through the validated key.

1. Add this second example question and SQL query:

    ```input
    Which suppliers can cover the LP001 gap under the approved eligibility rules?
    ```

    ```sql
    SELECT s.CMOName, s.QualifiedAvailableCapacityUnits, s.LeadTimeWeeks,
           s.GMPQualityScore, s.WeightedScore
    FROM supplier s
    JOIN launch_program lp
      ON s.LaunchProgramID = lp.LaunchProgramID
    WHERE s.LaunchProgramID = 'LP001'
      AND s.QualifiedAvailableCapacityUnits >= lp.CapacityGapUnits
      AND s.GMPCertStatus = 'Currently valid'
      AND s.OpenCriticalFindings = 0
      AND s.FastTrackEligible = 'Yes'
    ORDER BY s.WeightedScore DESC, s.LeadTimeWeeks ASC;
    ```

    This example makes the eligibility and ranking logic explicit without making a procurement decision for the learner.

1. Ask the identical first question again:

    ```input
    For LP001, what is the capacity shortfall and which plant is the binding constraint?
    ```

1. Ask the identical second question again:

    ```input
    Which supplier should Caldova prioritize to close the LP001 gap, and why?
    ```

1. Compare the baseline and business-context-enhanced answers:

    | Criterion | Baseline | Business-context-enhanced |
    |---|---|---|
    | Uses 18,900 units and 7% without recalculating a different gap | Record | Record |
    | Resolves `PL003` to Plant 3 through a relationship | Record | Record |
    | Applies all four supplier eligibility conditions | Record | Record |
    | Ranks Meridian first and explains quality, capacity, and six-week lead time | Record | Record |
    | Names the source entities or tables used | Record | Record |
    | Separates facts from recommendation | Record | Record |

1. Record whether the enhanced answer is more consistent and traceable. Don't claim that the baseline must be wrong; the learning outcome is the explicit, reusable business context and reasoning policy.

> **Tip**: If the ontology source reports that it has no data, wait a few minutes for initialization and ask again. If the current ontology-to-data-agent service issue prevents adding the source, retain the ontology, apply the supplied agent and source instructions to the Lakehouse source, and document the environment limitation for the hoster.

This exercise uses the data agent as the focused decision interface instead of adding a Power BI report. That choice preserves enough time to implement and compare the ontology-driven context within the 25-minute phase. For details, see [Create a Fabric data agent](https://learn.microsoft.com/fabric/data-science/how-to-create-data-agent) and [use an ontology as data-agent context](https://learn.microsoft.com/fabric/data-science/data-agent-ontology-sources).

## Review governance and security in OneLake catalog

Use the OneLake catalog capabilities from Lesson 5 to inspect the estate you created. This review stays within Fabric governance; it doesn't add a Microsoft Purview exercise.

1. Select the **OneLake** icon in the Fabric navigation pane to open **OneLake catalog**.
1. Select **Explore**, filter **Workspace** to your Caldova workspace, and verify that the Lakehouse, Eventhouse/KQL database, eventstream, ontology, and data agent are discoverable.
1. Select `caldova_lakehouse`, and review its item details, owner, workspace, description, endorsement, and available actions.
1. Open the item settings, add a concise description such as `Authoritative curated source for Caldova launch-readiness analysis`, and save it.
1. Open **Endorsement**, and select **Promoted** if endorsement is enabled in the tenant. If it isn't available, record that certification and master-data designation require administrator enablement and authorized reviewers.
1. Select **Secure**, filter to your workspace, and review the learner's workspace role and item access. Don't grant access to another identity in the shared lab.
1. Return to the workspace, select **Lineage**, and locate the Lakehouse, notebook, Eventhouse, eventstream, ontology, and data agent.
1. Highlight the lineage for `caldova_operational_stream`, and inspect the visible connections to the Eventhouse and Lakehouse.
1. Record any expected relationship that isn't automatically represented. Treat lineage as observed metadata, not as proof that every business-key relationship is enforced.
1. Confirm that the implementation has:

    - A named owner through workspace membership
    - Discoverable and described data items
    - Reviewed workspace and OneLake access
    - Promotion applied when available
    - Visible technical lineage from ingestion and transformation items

For the current catalog model, see [OneLake catalog overview](https://learn.microsoft.com/fabric/governance/onelake-catalog-overview), [endorsement overview](https://learn.microsoft.com/fabric/governance/endorsement-overview), [OneLake security roles and scopes](https://learn.microsoft.com/fabric/onelake/security/data-access-control-model), and [lineage in Fabric](https://learn.microsoft.com/fabric/governance/lineage).

## Optional bonus: Compare a basic Foundry agent with Foundry IQ

This **20–25 minute optional task is outside the core 90 minutes**. Complete it only when the hoster confirms that the non-hub Foundry project, model deployment, Azure AI Search service, managed identities, roles, regional support, quota, networking, and preview settings listed in `TechnicalRequirements.md` are ready.

This comparison uses a basic Foundry agent before and after you attach a **Foundry IQ knowledge base** whose structured source is the Fabric ontology in OneLake catalog. A Fabric data agent attached as an agent tool is a different integration pattern and is **not** a Foundry IQ knowledge base.

1. Open the Foundry portal at `https://ai.azure.com`, and open the non-hub project assigned by the hoster.
1. Select **Agents** > **+ New agent**, select the prevalidated model deployment, and name the agent `caldova-decision-agent`.
1. Enter this minimal system prompt:

    ```prompt
    You are an operations decision assistant. Answer the user's question and clearly state when you lack supporting evidence.
    ```

1. Ask this question before adding any knowledge source:

    ```input
    For LP001, what evidence shows launch risk, and which internal plant and external supplier need attention?
    ```

1. Record whether the answer is generic, unsupported, or correctly refuses to invent Caldova facts. This is the **ungrounded basic-agent** condition.
1. Select **Knowledge** > **Knowledge bases** > **+ New knowledge base**.
1. Select **Fabric IQ** as the knowledge type to open the embedded OneLake catalog picker.
1. Select `caldova_launch_ontology` from your Fabric workspace, name the knowledge source `caldova-launch-ontology-source`, and create it.
1. Name the knowledge base `caldova-launch-kb`, describe it as the structured source for Caldova launch, capacity, batch, plant, product, and supplier decisions, and save it.
1. Return to `caldova-decision-agent`, select **Knowledge** > **+ Add knowledge**, select `caldova-launch-kb`, and save the agent.
1. Ask the identical question again:

    ```input
    For LP001, what evidence shows launch risk, and which internal plant and external supplier need attention?
    ```

1. Compare generic or unsupported behavior before the connection with evidence-backed, cited behavior after the connection. Verify that the latter identifies the 18,900-unit gap, `PL003`, and the evidence supporting Meridian Biologics.
1. Add the three supplied unprotected documents from `Labfiles\optional\knowledge` only if the hoster has preconfigured a supported document knowledge source:

    - `GMP Scheduling Guidance.docx`
    - `Supplier Evaluation Guidance.docx`
    - `Change Control Procedure.docx`

1. Ask an identical before-and-after policy question if you add the document source:

    ```input
    Which scheduling, supplier-evaluation, and change-control evidence should accompany the LP001 recommendation?
    ```

1. Record the document citations returned after the source is connected, and don't represent absent or uncited content as policy.

The public ontology-based integration is documented in [Build a Foundry IQ agent grounded in an ontology](https://learn.microsoft.com/fabric/iq/ontology/how-to-create-agent-foundry-iq), [Create a Fabric Ontology knowledge source](https://learn.microsoft.com/azure/search/agentic-knowledge-source-how-to-fabric-ontology), and [What is Foundry IQ?](https://learn.microsoft.com/azure/foundry/agents/concepts/what-is-foundry-iq).

## Summary

In this exercise, you implemented Caldova's unified data and AI solution rather than designing an architecture. You created and populated a Fabric foundation, detected simulated launch-related exceptions through Eventstream and KQL, modeled reusable business context in an ontology, compared baseline and business-context-enhanced data-agent behavior, and reviewed the implementation in OneLake catalog. Your evidence supports further evaluation of Meridian Biologics while keeping procurement approval and simulated observations clearly separated.

You have successfully completed this exercise.

## Clean up

Delete the learner-created workspace so the assigned capacity no longer retains exercise items. Don't delete hoster-provisioned Foundry, Search, model, or capacity resources unless the hoster explicitly instructs you to do so.

1. Close the PowerShell window to discard any remaining process state.
1. Open the Fabric workspace you created.
1. Select **Workspace settings** > **General** > **Remove this workspace**.
1. Enter the workspace name, and confirm deletion.
1. Verify that the workspace no longer appears under **Workspaces**.
1. Delete `caldova-decision-agent` and learner-created knowledge-base objects from the assigned Foundry project if you completed the optional bonus and the hoster permits learner cleanup.
