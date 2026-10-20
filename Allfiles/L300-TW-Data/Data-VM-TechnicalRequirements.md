# Technical requirements

This document is for the Skillable hoster. It separates hoster-provisioned dependencies from resources that learners must create. Validate the image and cloud environment before publishing the exercise.

## Package staging

Stage the complete package at:

`C:\Labfiles\caldova-unified-data-ai-lab`

Grant the learner identity read access to the package. Preserve this structure:

- `Instructions\Exercises\01-build-caldova-unified-data-ai-solution.md`
- `Labfiles\data\core\` with six CSV files
- `Labfiles\notebooks\curate_caldova_tables.ipynb`
- `Labfiles\event-simulator\` with the Python publisher, templates, KQL, and requirements
- `Labfiles\agent\business-context-instructions.txt`
- `Labfiles\optional\knowledge\` with three unprotected DOCX files

Don't stage the original `DPoC.zip`, the protected case study, unrelated demo materials, Azure SQL assets, or duplicate dispense data.

## Core exercise requirements

### Hoster-provisioned cloud environment

Provide:

- A paid Microsoft Fabric capacity of **F2 or higher** in a supported region. Fabric data agent requires paid F2 or higher capacity.
- A capacity that learners can select when they create a workspace.
- A Fabric tenant in which learners can create workspaces and Fabric items.
- A learner Microsoft Entra identity licensed and authorized to use Fabric.
- Capacity headroom for one Lakehouse notebook session, Eventstream, Eventhouse/KQL ingestion, ontology, and Fabric data agent per concurrent learner.
- An Edge or Chrome browser with pop-ups and third-party sign-in flows permitted for Microsoft portals.

Don't precreate the learner workspace, Lakehouse, Eventhouse/KQL database, or data ingestion. Creating and populating those items is part of the assessed implementation.

### Fabric tenant and capacity settings

Enable and validate:

- **Users can create Fabric items** for the learner security group.
- **Users can use Copilot and other features powered by Azure OpenAI**.
- **Capacities can be designated as Fabric Copilot capacities**, and designate the assigned capacity when the tenant requires it.
- Data-processing and data-storage settings for Azure OpenAI outside the capacity's geographic region or compliance boundary when required for a capacity outside the US or EU.
- Ontology/Fabric IQ preview availability for the learner group.
- Fabric data agent availability for the learner group.
- Eventstream custom endpoint sources and Lakehouse/Eventhouse destinations.
- OneLake catalog **Explore**, **Secure**, and lineage access. Learners need only inspect their access; don't grant tenant administration.
- Item promotion if the tenant permits it. Certification and master-data endorsement are optional and should remain admin-controlled.

Tenant-setting changes can take up to one hour to apply. Configure them before the class image is validated. See [Configure Fabric data agent tenant settings](https://learn.microsoft.com/fabric/data-science/data-agent-tenant-settings) and [Ontology tutorial prerequisites](https://learn.microsoft.com/fabric/iq/ontology/tutorial-0-introduction).

### Core permissions

Assign the learner:

- Permission to create a workspace on the assigned capacity.
- **Contributor** or higher in the workspace the learner creates.
- Permission to run Spark notebooks and create Lakehouse, Eventhouse, KQL database, Eventstream, Ontology, Data agent, and KQL Queryset items.
- Read and build access to items created under the same identity.

Use the same learner identity throughout Fabric so that OneLake catalog, ontology binding, data-agent source selection, and lineage can resolve the items.

### Hosted image and runtime

Install and validate:

- Python 3.11 or later on `PATH`.
- `pip`.
- `azure-eventhub==5.15.1` from `Labfiles\event-simulator\requirements.txt`.
- PowerShell 7 or Windows PowerShell 5.1.
- UTF-8 support for the CSV and JSON assets.

Preinstall the Python dependency in the base image. The learner shouldn't need outbound package installation during the timed exercise.

### Core network access

Allow HTTPS and required service traffic to:

- `login.microsoftonline.com`
- `app.fabric.microsoft.com`
- Microsoft Fabric and OneLake regional endpoints
- Fabric Eventstream's Event Hubs-compatible custom endpoint
- Microsoft documentation at `learn.microsoft.com`

If the image uses a proxy, verify that Python can establish AMQP-over-WebSockets or the endpoint transport selected by the Fabric custom endpoint. Don't expose the Eventstream connection string in logs, environment snapshots, or reusable images.

### Core preflight validation

Use a test identity with the same group memberships as a learner and verify:

1. The assigned paid capacity appears during workspace creation.
1. A Lakehouse and Eventhouse can be created, and the Eventhouse creates its default KQL database.
1. The notebook imports, attaches to the Lakehouse, and runs without modification.
1. The notebook reports 318 curated rows and no orphaned tested keys.
1. A custom endpoint source can accept events from `replay_events.py`.
1. The eventstream can write the same event schema to an Eventhouse table and a new Lakehouse Delta table.
1. The KQL query returns four threshold breaches from the supplied replay.
1. Ontology (preview) can bind the six curated tables.
1. A Fabric data agent can use the Lakehouse and ontology sources.
1. OneLake catalog shows the learner-created items and workspace lineage.
1. Workspace deletion removes all learner-created Fabric items.

Microsoft currently publishes known issues for Fabric data agent and ontology integration. Check the [Fabric known issues site](https://support.fabric.microsoft.com/known-issues/) immediately before image sign-off. If adding the ontology source is affected, document the outage and use the exercise's Lakehouse-plus-instructions fallback; don't silently remove the ontology build.

## Optional Foundry IQ bonus requirements

The optional bonus is outside the core 90 minutes. Enable it only after every dependency below passes preflight validation.

### Hoster-provisioned Azure resources

Provide:

- A current **non-hub Microsoft Foundry resource and project**. Don't use a legacy hub-based project for this path.
- A supported chat model deployment selected for the agent and knowledge base.
- Prevalidated regional model availability, tokens-per-minute quota, deployment quota, and concurrent learner capacity.
- An Azure AI Search service in a region that supports the required agentic-retrieval and Foundry IQ capabilities.
- Azure AI Search **Basic or higher** when managed identity is used. Don't use the Free tier for this configuration.
- A system-assigned managed identity on Azure AI Search.
- The managed identity associated with the Foundry project/resource.
- The same learner identity in Foundry and Fabric. The identity must be able to read the learner's Fabric ontology through the embedded OneLake catalog picker.
- Public network access or validated private endpoints, DNS, and routing among the hosted VM, Microsoft Foundry, Azure AI Search, the model resource, Microsoft Entra ID, and Microsoft Fabric.

Check current regional availability in [Azure AI Search regions](https://learn.microsoft.com/azure/search/search-region-support) and follow the public ontology path in [Build a Foundry IQ agent grounded in an ontology](https://learn.microsoft.com/fabric/iq/ontology/how-to-create-agent-foundry-iq).

### Optional identities and role assignments

Assign:

- **Foundry User** to each learner at the project scope.
- **Foundry Project Manager** only when learners must manage project-level configuration or membership. It isn't required merely to create and test an agent when **Foundry User** is sufficient.
- **Search Service Contributor** on the Search service to identities that create or manage knowledge bases and knowledge sources.
- **Search Index Data Reader** to the Foundry project managed identity for runtime retrieval.
- **Search Index Data Contributor** to the Foundry project managed identity when the ontology knowledge-source flow must create or update Search data objects. The current ontology integration documentation explicitly calls out this assignment.
- **Search Index Data Contributor** or the least-privileged equivalent to the knowledge-base creator when the portal operation requires data-plane writes.
- **Cognitive Services User** on the model/Foundry resource for the Azure AI Search managed identity when the knowledge base invokes an LLM.
- Permission for the learner identity and relevant managed identity to read the selected Fabric ontology and its bound data.

Use Microsoft Entra authentication rather than API keys. Validate effective role assignments before the lab; Azure role propagation can delay readiness. See [Microsoft Foundry RBAC](https://learn.microsoft.com/azure/foundry/concepts/rbac-foundry), [Azure AI Search RBAC](https://learn.microsoft.com/azure/search/search-security-rbac), and [Create a Fabric Ontology knowledge source](https://learn.microsoft.com/azure/search/agentic-knowledge-source-how-to-fabric-ontology).

### Optional preview and tenant settings

Validate:

- The Foundry portal exposes **Knowledge** > **Knowledge bases** in the assigned non-hub project.
- **Fabric IQ** appears as a knowledge type and launches the embedded OneLake catalog picker.
- The Fabric ontology preview is enabled for the learner.
- Foundry IQ and agentic retrieval API versions used by the portal are supported in the Search region.
- Cross-service data handling complies with organizational geographic, privacy, and preview policies.
- The browser can complete cross-service authentication without blocked third-party cookies or conditional-access interruptions.

The optional comparison uses the ontology-backed Foundry IQ knowledge base. It must not be replaced with a Fabric data agent attached as a tool; those are different integration patterns.

### Optional document extension

The ontology is the required structured source. The three supplied DOCX files are optional:

- `GMP Scheduling Guidance.docx`
- `Supplier Evaluation Guidance.docx`
- `Change Control Procedure.docx`

They are unprotected Open XML documents extracted from the provided DPoC. If the hoster enables the document extension, stage the files in a supported Foundry IQ knowledge source and grant the learner and managed identities the required read access. Don't add other DPoC documents, MIP-protected content, sentiment material, or demo code.

### Optional preflight validation

Verify:

1. The learner can open the non-hub Foundry project and select the deployed model.
1. A basic agent can be created with **Foundry User**.
1. The embedded OneLake catalog picker displays the learner's ontology.
1. The knowledge source and knowledge base can be created without a 403 response.
1. The Foundry agent can attach the knowledge base and return ontology-backed evidence with source attribution.
1. The same prompt produces generic or unsupported behavior before knowledge is attached and evidence-backed behavior afterward.
1. Optional document citations resolve only to the three approved files.

## Cleanup and reset

Configure each lab instance so that:

- Learners delete their Fabric workspace at the end of the exercise.
- Eventstream custom-endpoint credentials expire with workspace deletion and aren't persisted in the image.
- Learner-created Foundry agents and knowledge-base objects can be deleted without deleting shared hoster resources.
- Shared model deployments, Search services, Foundry resources/projects, and Fabric capacity remain hoster-managed.
- Automated teardown removes per-learner optional objects, temporary role assignments, indexes, knowledge sources, and knowledge bases.
- Capacity and Search diagnostics can identify orphaned items after a cancelled session.

Don't direct learners to delete shared capacity, Search, model, or Foundry resources.
