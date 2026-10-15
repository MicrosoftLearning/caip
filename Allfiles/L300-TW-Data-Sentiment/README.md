# Caldova sentiment and data-agent lab

This package supports a separate level-300 exercise for CAIP Solution Engineers, Cloud Solution Architects, and Global Black Belts. Learners score synthetic Caldova launch-readiness feedback and create a Fabric data agent by choosing one sentiment implementation and one grounding implementation.

## Route timing

| Route | Sentiment implementation | Agent implementation | Estimated active time |
|---|---|---|---:|
| A1 | Fabric AI Functions | Direct Lakehouse grounding | 60 minutes |
| A2 | Fabric AI Functions | Lakehouse plus ontology | 70 minutes |
| B1 | Azure OpenAI and Fabric SQL | Direct Fabric SQL grounding | 70 minutes |
| B2 | Azure OpenAI and Fabric SQL | Fabric SQL plus ontology | 80 minutes |
| All sections | Both sentiment and both agent options | Comparison | Up to 110 minutes |

The published duration is 90 minutes to include preview-feature initialization and troubleshooting. Every supported route remains below 120 minutes.

## Package contents

- `Instructions\Labs\02-analyze-caldova-feedback-with-fabric-data-agents.md` - Learner exercise.
- `TechnicalRequirements.md` - Hoster provisioning, tenant settings, identity, networking, and preflight requirements.
- `Labfiles\data\` - Synthetic product and customer-feedback CSV files.
- `Labfiles\notebooks\score_caldova_sentiment_fabric.ipynb` - Fabric AI Functions scoring path.
- `Labfiles\sql\` - Fabric SQL schema, managed identity credential, scoring procedure, and batch runner.
- `Labfiles\deployment\deploy-azure-openai.ps1` - Optional Azure OpenAI fallback deployment.
- `Labfiles\agent\data-agent-instructions.txt` - Shared evidence and safety instructions for both agents.

## Design decisions

- The exercise is separate from the existing Caldova unified data and AI exercise.
- No Power BI semantic model is introduced as a grounding option.
- The Fabric-native path uses `df.ai.analyze_sentiment()` and a built-in Fabric-hosted model endpoint.
- The fallback follows the FabCon sentiment pattern through scoring and stops before User Data Functions and writeback.
- The direct agent uses curated tables, source instructions, and example queries without an ontology.
- The ontology agent uses the same evidence with explicit `Product` and `CustomerFeedback` entities and an `aboutProduct` relationship.
- The data is synthetic and contains no patient identity, protected health information, or clinical outcome claims.

## Validation scope

Local validation covers CSV structure, notebook JSON and Python syntax, PowerShell parsing, SQL structure, file references, timing arithmetic, and style checks. Fabric UI, model inference, tenant settings, regional quota, managed identity token acquisition, and preview behavior require hoster preflight.
