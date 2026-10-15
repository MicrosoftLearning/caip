---
lab:
  title: 'Analyze Caldova feedback with Fabric data agents'
  module: 'Unify your data and AI platform'
  description: 'Score launch-readiness feedback with a Fabric-native or Azure OpenAI path, and compare direct data-source grounding with ontology-enhanced grounding.'
  duration: 90 minutes
  level: 300
  islab: true
  primarytopics:
    - Microsoft Fabric
    - Fabric data agent
    - Fabric IQ
    - Fabric AI Functions
    - SQL database in Microsoft Fabric
  categories:
    - Data engineering
    - Artificial intelligence
  courses:
---

# Analyze Caldova feedback with Fabric data agents

Caldova collects synthetic customer and partner feedback during launch-readiness activities. The feedback provides useful evidence, but reviewers can't consistently identify sentiment or connect comments to the affected product. In this exercise, you score the feedback and create a Fabric data agent that answers questions from the enriched data.

You select one sentiment implementation and one agent-grounding implementation. The options let you compare a Fabric-native design with an Azure OpenAI fallback, and direct data-source grounding with ontology-enhanced grounding. The exercise doesn't create or use a Power BI semantic model.

This lab takes approximately **90** minutes to complete, including a 10-minute buffer for preview-feature initialization.

> **Note**: Fabric AI Functions, Fabric data agent, and ontology include preview or actively developed capabilities. Labels and initialization times can change.

## Learning objectives

By the end of this exercise, you can:

1. Apply sentiment analysis to customer feedback with Fabric AI Functions or Azure OpenAI.
1. Store scored feedback in a Fabric Lakehouse or SQL database in Microsoft Fabric.
1. Create a Fabric data agent grounded directly in curated tables.
1. Create an alternative agent that adds ontology-based business context.
1. Evaluate the evidence, limitations, and service boundaries of each design.

## Before you start

> **Note**: You need a Microsoft Fabric account with access to a workspace assigned to a paid F2 or higher Fabric capacity. A Fabric trial doesn't support the Fabric data agent capabilities used in this exercise.

You also need permission to create workspaces and Fabric items. If you complete the Azure OpenAI fallback, you need an Azure subscription with permission to create an Azure OpenAI resource and deploy a supported model. If the workshop provides shared Fabric or Azure resources, use those resources instead of creating your own.

> **Important**: Use only the Fabric capacity and Azure subscription assigned to the lab. Don't use **My workspace**.

## Select an implementation route

Complete one sentiment option and one agent option. The alternatives remain independent, so stakeholders can retain or remove a route without rewriting the other routes.

| Route | Sentiment implementation | Agent implementation | Estimated active time |
|---|---|---|---:|
| A1 | Fabric AI Functions | Direct Lakehouse grounding | 60 minutes |
| A2 | Fabric AI Functions | Lakehouse plus ontology | 70 minutes |
| B1 | Azure OpenAI and Fabric SQL | Direct Fabric SQL grounding | 70 minutes |
| B2 | Azure OpenAI and Fabric SQL | Fabric SQL plus ontology | 80 minutes |

The route estimates include common setup, evaluation, and cleanup. Complete both agent options only when you want to compare them in the same session. Completing every section can take up to **110 minutes**.

### Compare the service boundaries

Review the boundary for each sentiment option before you select it:

| Option | Data and processing in Fabric | Service outside Fabric |
|---|---|---|
| Fabric-native | Lakehouse, notebook, Spark, AI Functions, scored Delta tables | Built-in Fabric-hosted model endpoint managed by Fabric |
| Azure OpenAI fallback | SQL database in Microsoft Fabric, tables, stored procedure, and scored rows | Azure OpenAI resource, model deployment, role assignment, and REST inference |

Fabric AI Functions use a built-in Fabric endpoint and don't require separate endpoint setup. The fallback follows the sentiment-scoring pattern from the FabCon exercise through its scoring phase. It stops before User Data Functions and report writeback because neither feature is required to calculate sentiment.

For product details, see [AI Functions overview](/fabric/data-science/ai-functions/overview), [use `ai.analyze_sentiment` with PySpark](/fabric/data-science/ai-functions/pyspark/analyze-sentiment), and [use SQL database in AI applications](/fabric/database/sql/use-case-ai-application).

## Create a workspace

Create an isolated workspace so that both sentiment and agent items share the same access boundary.

**Estimated time:** 5 minutes.

1. In a browser inside the hosted VM, open the [Microsoft Fabric home page](https://app.fabric.microsoft.com/home?experience=fabric), and sign in with the learner identity supplied for the lab. If the hyperlink opens outside the VM, type this URL in the VM browser:

    `https://app.fabric.microsoft.com/home?experience=fabric`
1. Select **Workspaces** > **+ New workspace**.
1. Enter `caldova-feedback-` followed by your initials as the **Name**.
1. Expand **Advanced**, select **Fabric capacity** as the license mode, and select the capacity assigned by the hoster.
1. Select **Apply**, and open the workspace.
1. Record the workspace name and the sentiment and agent options you selected.

You now have the workspace required by either implementation route.


## Score sentiment with Fabric AI Functions (option A)

Complete this section for route A1 or A2. A supplied notebook loads the synthetic feedback, adds product context, applies `ai.analyze_sentiment`, validates the labels, and writes two managed Delta tables.

> **Important**: If a file isn't staged in the hosted VM, open a browser inside the VM and type or paste the code-formatted raw URL shown with that file. Selecting the hyperlink in these instructions might open it on your personal computer instead.

**Estimated time:** 20 minutes.

### Create the Lakehouse and upload the data

Create the storage item before you import the scoring notebook.

1. In the workspace, select **+ New item**, search for **Lakehouse**, and create `caldova_sentiment_lakehouse`.
1. Clear **Lakehouse schemas** to keep the exercise's flat table names, and select **Create**.
1. In the Lakehouse, select **Files**, and create a folder named `caldova-sentiment`.
1. Open the folder, and select **Get data** > **Upload files**.
1. Upload `products.csv` and `customer_feedback.csv` from `Allfiles\L300-TW-Data-Sentiment\data`.

    If the files aren't staged in the VM, download them in the VM browser and save them in the VM's **Downloads** folder:

    - [Download products.csv](https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/data/products.csv)

      `https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/data/products.csv`

    - [Download customer_feedback.csv](https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/data/customer_feedback.csv)

      `https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/data/customer_feedback.csv`

1. Verify that both files appear in `Files/caldova-sentiment`.

The notebook reads these files with explicit schemas so that dates and identifiers have stable types.

### Run the sentiment notebook

Run the supplied notebook in Fabric rather than configuring a separate model endpoint.

1. Return to the workspace, and select **Import** > **Notebook** > **From this computer**.
1. Import `Allfiles\L300-TW-Data-Sentiment\notebooks\score_caldova_sentiment_fabric.ipynb`.

    If the notebook isn't staged in the VM, download it in the VM browser, save it in the VM's **Downloads** folder, and import that copy:

    [Download score_caldova_sentiment_fabric.ipynb](https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/notebooks/score_caldova_sentiment_fabric.ipynb)

    `https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/notebooks/score_caldova_sentiment_fabric.ipynb`
1. Open the notebook, select **Add lakehouse**, select **Existing lakehouse**, and attach `caldova_sentiment_lakehouse` as the default Lakehouse.
1. Confirm that the notebook uses Fabric Runtime 1.3 or later.
1. Select **Run all**.
1. Wait for the validation message:

    ```output
    Validation passed: 3 products and 16 feedback records; all records have supported sentiment labels.
    ```

1. Review the result grids, and confirm that every feedback row has one of these labels: `positive`, `negative`, `neutral`, or `mixed`.

> **Important**: AI-generated labels can contain mistakes. Treat the result as model-generated evidence that requires review, not as verified customer intent.

### Verify the managed tables

Confirm that the notebook persisted data for the agent route.

1. Return to `caldova_sentiment_lakehouse`, and refresh **Tables**.
1. Verify that these managed tables appear:

    - `product`
    - `customer_feedback_sentiment`

1. Open `customer_feedback_sentiment`, and verify that it contains 16 rows.
1. Confirm that `FeedbackID` is populated, `ProductID` relates each comment to a product, and `AIError` is empty.
1. Record the sentiment counts shown by the notebook. Don't expect an exact distribution because model output can vary.

Continue to either **Option 1: Ground the agent directly in Fabric data** or **Option 2: Add ontology-based business context**.


## Score sentiment with Azure OpenAI and Fabric SQL (option B)

Complete this section for route B1 or B2. This fallback uses a SQL database in Microsoft Fabric for data and stored procedures. It calls a separately deployed Azure OpenAI model for inference. It doesn't create a User Data Function or implement writeback.

> **Important**: If a file isn't staged in the hosted VM, open a browser inside the VM and type or paste the code-formatted raw URL shown with that file. Selecting the hyperlink in these instructions might open it on your personal computer instead.

**Estimated time:** 30 minutes.

### Create the Fabric SQL database

Create the database that stores products, feedback, and sentiment results.

1. In the Fabric workspace, select **+ New item**, and search for **SQL database**.
1. Create a database named `caldova_sentiment_sql`.
1. Open the database, and select **New query**.
1. Open `Allfiles\L300-TW-Data-Sentiment\sql\01-create-feedback-schema.sql` in the hosted VM.

    If the script isn't staged in the VM, open it from the VM browser:

    [Open 01-create-feedback-schema.sql](https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/sql/01-create-feedback-schema.sql)

    `https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/sql/01-create-feedback-schema.sql`
1. Copy the script into the Fabric query editor, and select **Run**.
1. Verify that the results report three product rows and 16 feedback rows.

The script creates relational keys before sentiment scoring, so the data agent and ontology can use `ProductID` consistently.

### Provision the Azure OpenAI fallback

Skip the deployment commands when the hoster provides an endpoint and deployment. Otherwise, deploy the fallback from the hosted VM. Before you begin, obtain the subscription ID, resource group name, supported Azure region, globally unique account name, and Fabric SQL managed-identity object ID from the lab hoster.

Use `Allfiles\L300-TW-Data-Sentiment\deployment\deploy-azure-openai.ps1`. If the script isn't staged in the VM, download it in the VM browser and save it in the VM's **Downloads** folder:

[Download deploy-azure-openai.ps1](https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/deployment/deploy-azure-openai.ps1)

`https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/deployment/deploy-azure-openai.ps1`

1. Open PowerShell, and sign in to Azure:

    ```powershell
    az login
    ```

    This command opens an interactive sign-in for the assigned Azure subscription.

1. Change to the deployment-script folder. If the repository is staged in the VM, run:

    ```powershell
    Set-Location '.\Allfiles\L300-TW-Data-Sentiment\deployment'
    ```

    If you downloaded `deploy-azure-openai.ps1`, run this command instead:

    ```powershell
    Set-Location "$HOME\Downloads"
    ```

1. Run the deployment script with values supplied by the hoster:

    ```powershell
    .\deploy-azure-openai.ps1 `
        -SubscriptionId '<subscription-id>' `
        -ResourceGroupName '<resource-group-name>' `
        -Location '<supported-region>' `
        -AccountName '<globally-unique-account-name>' `
        -FabricSqlPrincipalId '<fabric-sql-managed-identity-object-id>'
    ```

    The script creates an Azure OpenAI resource, deploys `gpt-5-mini`, and grants the Fabric SQL managed identity access when you supply its object ID.

1. Record the endpoint, deployment name, model name, and model version returned by the script.
1. Verify the deployment state:

    ```powershell
    az cognitiveservices account deployment show `
        --name '<globally-unique-account-name>' `
        --resource-group '<resource-group-name>' `
        --deployment-name 'gpt-5-mini' `
        --query properties.provisioningState `
        --output tsv
    ```

1. Confirm that the command returns `Succeeded`.

> **Note**: Model availability, version, and quota vary by region. If deployment fails, use the hoster-provisioned endpoint rather than selecting an unvalidated model during the timed exercise.

### Configure managed identity authentication

Create a database-scoped credential that requests a Microsoft Entra token for Azure AI services.

1. Return to `caldova_sentiment_sql`, and open a new query.
1. Open `Allfiles\L300-TW-Data-Sentiment\sql\02-create-azure-openai-credential.sql`.

    If the script isn't staged in the VM, open it from the VM browser:

    [Open 02-create-azure-openai-credential.sql](https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/sql/02-create-azure-openai-credential.sql)

    `https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/sql/02-create-azure-openai-credential.sql`
1. Replace every `<azure-openai-resource>` placeholder with the Azure OpenAI resource name.
1. Copy the updated script into the query editor, and select **Run**.
1. Expand **Security** > **Database scoped credentials**, and verify that the endpoint credential appears.
1. Confirm with the hoster that the credential's managed identity has the **Cognitive Services OpenAI User** role.

The credential stores no API key. Fabric SQL uses managed identity to request a token when the stored procedure calls the endpoint.

### Create and run the scoring procedure

Create the procedure that follows the FabCon sentiment pattern, and stop before its User Data Function phase.

1. Open `Allfiles\L300-TW-Data-Sentiment\sql\03-create-sentiment-procedure.sql`.

    If the script isn't staged in the VM, open it from the VM browser:

    [Open 03-create-sentiment-procedure.sql](https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/sql/03-create-sentiment-procedure.sql)

    `https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/sql/03-create-sentiment-procedure.sql`
1. Replace `<azure-openai-resource>` with the resource name and `<deployment-name>` with the deployed model name.
1. Copy the updated script into a new query, and select **Run**.
1. Verify that `dbo.score_feedback_sentiment` appears under **Programmability** > **Stored procedures**.
1. Open `Allfiles\L300-TW-Data-Sentiment\sql\04-score-feedback.sql`.

    If the script isn't staged in the VM, open it from the VM browser:

    [Open 04-score-feedback.sql](https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/sql/04-score-feedback.sql)

    `https://raw.githubusercontent.com/AngieRudduck/caip/main/Allfiles/L300-TW-Data-Sentiment/sql/04-score-feedback.sql`

    Copy the script into a new query, and select **Run**.
1. Confirm that all 16 rows have a supported sentiment label and no `AIError` value.
1. Review the sentiment count result. If Azure OpenAI reports a rate limit, wait a few seconds and run the scoring script again. The script processes only rows whose sentiment is null.

This is the end of the sentiment-scoring workflow. Don't create a User Data Function because report writeback is outside the exercise scope.

Continue to either agent option.


## Ground the agent directly in Fabric data (option 1)

Complete this option for route A1 or B1. The agent uses the selected Lakehouse or Fabric SQL database without an ontology. Source instructions and example queries provide the required business context.

**Estimated time:** 20 minutes.

### Create the direct-grounded agent

Create the agent and select the source produced by your sentiment route.

1. In the workspace, select **+ New item**, search for **Data agent**, and create `caldova_feedback_agent_direct`.
1. Select **Add a data source**, and add the source for your route:

    | Sentiment route | Data source | Select these tables |
    |---|---|---|
    | Fabric AI Functions | `caldova_sentiment_lakehouse` | `product`, `customer_feedback_sentiment` |
    | Azure OpenAI fallback | `caldova_sentiment_sql` | `product`, `customer_feedback` |

1. Open **Agent instructions**, and enter the following instructions:

    ```prompt
    You are Caldova's launch-feedback analysis assistant.

    Use only the selected Caldova product and customer-feedback sources. Treat the Sentiment field as model-generated analysis, not as verified customer intent. Report the number of records behind every comparison, and name the source table or ontology entity used.

    Apply these rules:
    - Use FeedbackID as the feedback record key and ProductID as the product relationship key.
    - Use only positive, negative, neutral, or mixed as sentiment labels.
    - Separate direct evidence from recommendations.
    - Quote feedback only when the text is present in the selected source.
    - Do not make medical, clinical, safety, or efficacy claims.
    - Do not infer patient identity or protected health information.
    - State when the available data does not support an answer.
    - When recommending follow-up, explain the counts and feedback text that support the priority.
    ```
1. Open the selected source's **Data source instructions**, and add this description:

    ```prompt
    Caldova launch-feedback source. product provides product names and launch-readiness context. The customer feedback table contains one row per feedback record. FeedbackID is the feedback key, ProductID relates feedback to a product, FeedbackText contains the submitted comment, and Sentiment contains model-generated analysis. Use AIError to detect failed scoring records. Treat the source as analytical evidence, not clinical evidence.
    ```

1. Save the agent configuration.

The direct option relies on curated keys, source instructions, and query examples instead of an ontology.

### Add example queries

Provide examples that teach the agent how to aggregate model-generated sentiment.

1. Add this example question to the selected data source:

    ```input
    How many feedback records have each sentiment label?
    ```

1. Add the matching SQL query. Use the table name for your route:

    ```sql
    SELECT Sentiment, COUNT(*) AS FeedbackCount
    FROM dbo.<customer-feedback-table>
    WHERE AIError IS NULL
    GROUP BY Sentiment
    ORDER BY Sentiment;
    ```

1. Replace `<customer-feedback-table>` with `customer_feedback_sentiment` for the Lakehouse or `customer_feedback` for Fabric SQL.
1. Add this second example question:

    ```input
    Which products have the most negative feedback records?
    ```

1. Add the matching SQL query with the same table replacement:

    ```sql
    SELECT p.ProductName, COUNT(*) AS NegativeFeedbackCount
    FROM dbo.<customer-feedback-table> AS f
    INNER JOIN dbo.product AS p
        ON p.ProductID = f.ProductID
    WHERE f.Sentiment = 'negative' AND f.AIError IS NULL
    GROUP BY p.ProductName
    ORDER BY NegativeFeedbackCount DESC, p.ProductName;
    ```

1. Save the examples.

For current source support and query behavior, see [SQL sources in Fabric data agent](/fabric/data-science/data-agent-sql-sources) and [create a Fabric data agent](/fabric/data-science/how-to-create-data-agent).


## Add ontology-based business context (option 2)

Complete this option for route A2 or B2. The ontology adds reusable definitions and an explicit product-to-feedback relationship while retaining the selected data source as the queryable evidence.

**Estimated time:** 30 minutes.

### Create the feedback ontology

Create two entity types and bind them to the tables produced by your sentiment route.

1. In the workspace, select **+ New item**, search for **Ontology**, and create `caldova_feedback_ontology`.
1. Create a `Product` entity type, and bind it to the `product` table in your selected Lakehouse or Fabric SQL database.
1. Set `ProductID` as the entity key, and retain `ProductName` and `ProductDescription` as properties.
1. Create a `CustomerFeedback` entity type, and bind it to the scored feedback table for your route.
1. Set `FeedbackID` as the entity key, and retain these properties:

    - `ProductID`
    - `FeedbackDate`
    - `Channel`
    - `Region`
    - `FeedbackText`
    - `Sentiment`
    - `AIError`

1. Add an `aboutProduct` relationship from `CustomerFeedback.ProductID` to `Product.ProductID`.
1. Save the ontology, and verify that it shows two bound entity types and one relationship.

Ontology supports Lakehouse and SQL database bindings. Managed Lakehouse tables and stable key types reduce binding failures. For details, see [data binding in ontology](/fabric/iq/ontology/how-to-bind-data).

### Add business definitions

Add definitions that distinguish submitted evidence from model-generated analysis.

1. Add this description to `Product`:

    ```prompt
    A Caldova product included in launch-readiness feedback analysis. ProductDescription provides operational context only and makes no clinical claim.
    ```

1. Add this description to `CustomerFeedback`:

    ```prompt
    A synthetic customer or partner comment collected during launch-readiness activities. FeedbackText is submitted evidence. Sentiment is model-generated analysis and can be wrong. AIError identifies records that weren't scored successfully.
    ```

1. Add `comment`, `review`, and `response` as synonyms for `CustomerFeedback` when the interface supports synonyms.
1. Add `positive`, `negative`, `neutral`, and `mixed` to the `Sentiment` property description.
1. Refresh the ontology graph so that it includes the latest scored rows.
1. Verify that a `CustomerFeedback` entity resolves to its related `Product` through `aboutProduct`.

These definitions make the meaning and limitations reusable rather than placing every rule in a single agent prompt.

### Create the ontology-enhanced agent

Create a separate agent so you can compare it with the direct-grounded option.

1. In the workspace, create a data agent named `caldova_feedback_agent_ontology`.
1. Add the same Lakehouse or Fabric SQL source and tables used in the direct option.
1. Add `caldova_feedback_ontology` as an additional data source.
1. Open **Agent instructions**, and enter the same Caldova launch-feedback instructions from option 1. If you skipped option 1, use the complete instructions in the following block:

    ```prompt
    You are Caldova's launch-feedback analysis assistant.

    Use only the selected Caldova product, customer-feedback, and ontology sources. Treat the Sentiment field as model-generated analysis, not as verified customer intent. Report the number of records behind every comparison, and name the source table or ontology entity used.

    Use FeedbackID as the feedback record key and ProductID as the product relationship key. Use only positive, negative, neutral, or mixed as sentiment labels. Separate direct evidence from recommendations. Quote feedback only when the text is present in the selected source. Do not make medical, clinical, safety, or efficacy claims. Do not infer patient identity or protected health information. State when the available data does not support an answer.
    ```

1. Don't add example query pairs to the ontology source. Ontology sources use agent instructions and ontology definitions for tuning.
1. Save the agent configuration.
1. Ask the ontology agent to identify the relationship between a feedback record and a product, and verify that it uses `aboutProduct`.

> **Tip**: If the ontology source doesn't show data immediately, refresh the ontology graph, wait a few minutes, and ask again. Record the service limitation if initialization remains incomplete.

---

## Evaluate the selected agent

Ask the same questions regardless of the sentiment and grounding routes. Compare answers against the source data rather than assuming that an AI-generated answer is correct.

**Estimated time:** 10 minutes.

1. Ask this aggregation question:

    ```input
    How many Caldova feedback records are positive, negative, neutral, or mixed? State the total number of records and name the source you used.
    ```

1. Compare the answer with the sentiment counts returned by the notebook or SQL scoring script.
1. Ask this product question:

    ```input
    Which product has the most negative feedback records? Include the count and summarize the concerns stated in those records.
    ```

1. Verify that the agent uses only records labeled `negative` and doesn't invent a concern that isn't present in `FeedbackText`.
1. Ask this decision question:

    ```input
    Which feedback should Caldova review first before the next launch-readiness checkpoint? Separate direct evidence from your recommendation, and don't make medical or clinical claims.
    ```

1. Record the results:

    | Criterion | Result |
    |---|---|
    | Sentiment counts match the source | Record |
    | Product relationship uses `ProductID` | Record |
    | Evidence is separated from recommendation | Record |
    | Model-generated sentiment is identified as a limitation | Record |
    | No medical or clinical claim appears | Record |
    | Source table or ontology entity is named | Record |

1. If you created both agents, ask all three questions in both agents and note whether ontology context improves relationship handling, terminology, or explanation consistency. Don't claim that the direct-grounded agent is ungrounded or necessarily wrong.

You now have evidence for a customer architecture discussion: the direct option uses less configuration, while the ontology option adds reusable business meaning and relationships.

## Clean up resources

Remove learner-created resources to stop capacity and Azure consumption. Don't delete shared hoster-managed resources.

**Estimated time:** 5 minutes.

1. Delete `caldova_feedback_agent_direct` or `caldova_feedback_agent_ontology` if the hoster asks you to retain the workspace for review.
1. Delete `caldova_feedback_ontology` if you created it and the hoster asks for item-level cleanup.
1. Open **Workspace settings** > **General** > **Remove this workspace**.
1. Enter the workspace name, confirm deletion, and verify that it no longer appears under **Workspaces**.
1. If you deployed a learner-specific Azure fallback resource group, delete it:

    ```powershell
    az group delete --name '<resource-group-name>' --yes --no-wait
    ```

    This command starts deletion without waiting for Azure to finish.

1. Don't delete a shared Azure OpenAI resource, model deployment, or Fabric capacity.

## Summary

In this exercise, you:

- Scored synthetic Caldova feedback through a Fabric-native or Azure OpenAI implementation.
- Stored the sentiment results in a Lakehouse or SQL database in Microsoft Fabric.
- Created a direct-grounded or ontology-enhanced Fabric data agent.
- Validated the agent's answers against the underlying evidence.
- Identified which parts of each design operate inside Fabric and which fallback dependencies require Azure resources.

You have successfully completed this exercise.

