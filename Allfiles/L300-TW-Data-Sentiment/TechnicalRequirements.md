# Technical requirements

This document is for the Skillable hoster. It identifies the Fabric-native dependencies, optional Azure OpenAI fallback resources, service boundaries, and checks required before the exercise is published.

## Package staging

Stage the package at:

`C:\Labfiles\caldova-sentiment-data-agent-lab`

Preserve this structure:

- `Instructions\Labs\02-analyze-caldova-feedback-with-fabric-data-agents.md`
- `Labfiles\data\products.csv`
- `Labfiles\data\customer_feedback.csv`
- `Labfiles\notebooks\score_caldova_sentiment_fabric.ipynb`
- `Labfiles\sql\01-create-feedback-schema.sql`
- `Labfiles\sql\02-create-azure-openai-credential.sql`
- `Labfiles\sql\03-create-sentiment-procedure.sql`
- `Labfiles\sql\04-score-feedback.sql`
- `Labfiles\deployment\deploy-azure-openai.ps1`
- `Labfiles\agent\data-agent-instructions.txt`

Grant the learner read access to the package. Don't store Azure credentials, model keys, Eventstream credentials, or Fabric tokens in the staged image.

## Common Fabric requirements

### Capacity and tenant settings

Provide and validate:

- A paid Microsoft Fabric capacity of F2 or higher in a supported region.
- Capacity headroom for a Spark notebook, Lakehouse or Fabric SQL database, ontology, and data agent per concurrent learner.
- **Users can create Fabric items** for the learner group.
- **Users can use Copilot and other features powered by Azure OpenAI** for the learner group.
- Cross-geo processing and storage settings when required by the capacity region and organizational policy.
- Fabric data agent availability.
- Ontology preview availability for the ontology routes.
- Permission to create Lakehouse, Notebook, SQL database, Ontology, and Data agent items.

Tenant-setting changes can take time to apply. Configure them before image validation. See [Fabric data agent prerequisites](/fabric/data-science/concept-data-agent#prerequisites), [AI Functions prerequisites](/fabric/data-science/ai-functions/overview#prerequisites), and [ontology data-binding prerequisites](/fabric/iq/ontology/how-to-bind-data#prerequisites).

### Learner permissions

Assign the learner:

- Permission to create a workspace on the assigned capacity.
- **Contributor** or higher in the learner workspace.
- Permission to run Fabric notebooks.
- Read and build access to learner-created items.
- Permission to add Lakehouse or Fabric SQL data sources to a data agent.

Use the same learner identity throughout Fabric so that the OneLake catalog, ontology picker, and data-agent source picker resolve the learner-created items.

### Network access

Allow required HTTPS traffic to:

- `login.microsoftonline.com`
- `app.fabric.microsoft.com`
- Microsoft Fabric and OneLake regional endpoints
- Fabric-hosted model endpoints used by AI Functions
- `learn.microsoft.com`

## Fabric-native sentiment requirements

The Fabric-native routes require:

- Fabric Runtime 1.3 or later.
- The PySpark AI Functions library available in the selected runtime.
- The built-in Fabric model endpoint available in the capacity region.
- The Fabric tenant setting for Azure OpenAI-powered features.

PySpark AI Functions require no additional package installation in a supported Fabric Spark runtime. The default model and endpoint are managed by Fabric. Consumption uses Fabric capacity. See [AI Functions overview](/fabric/data-science/ai-functions/overview) and [AI Functions billing](/fabric/data-science/ai-functions/billing).

### Fabric-native preflight

With a test identity that matches the learner group, verify:

1. The learner can create and attach `caldova_sentiment_lakehouse` to a notebook.
1. The two CSV files upload to `Files/caldova-sentiment`.
1. The notebook imports and runs without package installation.
1. `df.ai.analyze_sentiment()` returns supported labels for all 16 rows.
1. The notebook writes the managed `product` and `customer_feedback_sentiment` tables.
1. A data agent can query both tables.
1. An ontology can bind both managed tables and resolve the `ProductID` relationship.

## Azure OpenAI fallback requirements

Enable the fallback only when every dependency passes preflight. The fallback adds services outside Fabric and isn't the default route.

### Azure resources and quota

Provide either a hoster-managed deployment or permission to run the supplied script. The fallback requires:

- An Azure subscription and resource group.
- An Azure OpenAI resource in a supported region.
- A compatible chat model deployment. The supplied script defaults to `gpt-5-mini`, model version `2025-08-07`, and `GlobalStandard` capacity.
- Sufficient deployment and tokens-per-minute quota for all concurrent learners.
- Azure CLI in the hosted VM.
- Network access from Fabric SQL to the Azure OpenAI endpoint.

Model versions and regional availability change. Validate the script defaults against the current model catalog before each delivery. Update the script parameters rather than silently selecting a different model during the learner session. See [deploy a model with Azure CLI](/azure/foundry/tutorials/quickstart-create-foundry-resources#deploy-a-model).

### Managed identity and role assignment

The SQL scripts use a database-scoped credential with `IDENTITY = 'Managed Identity'`. Configure the identity used by the Fabric SQL database for outbound REST calls, and grant it **Cognitive Services OpenAI User** at the Azure OpenAI resource scope.

The deployment script accepts `-FabricSqlPrincipalId` and creates this role assignment. If the hoster provisions the resource separately, create the equivalent assignment before the exercise. Don't replace managed identity with a shared API key in the staged image.

Validate the complete token flow. A successful role assignment alone doesn't prove that Fabric SQL uses the expected principal. See [use SQL database in AI applications](/fabric/database/sql/use-case-ai-application#enrichment-with-azure-openai) and [`sp_invoke_external_rest_endpoint`](/sql/relational-databases/system-stored-procedures/sp-invoke-external-rest-endpoint-transact-sql?view=fabric-sqldb).

### Azure fallback preflight

With a test identity and database matching the learner topology, verify:

1. The Fabric SQL database creates the `product` and `customer_feedback` tables.
1. The managed identity credential is created without an API key.
1. The Azure OpenAI deployment reports `Succeeded`.
1. Fabric SQL reaches the endpoint over HTTPS.
1. The managed identity receives an Azure OpenAI access token.
1. `dbo.score_feedback_sentiment` parses the current REST response shape.
1. The batch script scores all 16 rows without an `AIError` value.
1. A data agent can query the Fabric SQL database directly.
1. An ontology can bind the `product` and `customer_feedback` tables.

If any identity, endpoint, quota, model, or response-shape check fails, disable the Azure fallback route for that delivery. Keep the Fabric-native path available.

## Hosted image requirements

Install and validate:

- Microsoft Edge or Google Chrome.
- PowerShell 7 or Windows PowerShell 5.1.
- Azure CLI for the fallback route.
- UTF-8 support for CSV, SQL, JSON, and PowerShell assets.

Local Python isn't required. The Fabric-native notebook uses the managed Fabric Spark runtime.

## Cleanup and reset

Configure each lab instance so that:

- Learners can delete their Fabric workspace.
- Learner-created Azure fallback resource groups can be deleted.
- Shared Fabric capacity and hoster-managed Azure OpenAI deployments remain protected.
- Automated teardown identifies orphaned workspaces, SQL databases, role assignments, and Azure resource groups.

Don't direct learners to delete shared capacity or shared Azure OpenAI resources.
