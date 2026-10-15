# Caldova unified data and AI lab

This package contains one original level-300 Microsoft Learn-style exercise for CAIP Solution Engineers, Cloud Solution Architects, and Global Black Belts. Learners implement a Caldova launch-readiness solution in Microsoft Fabric; they don't design an architecture.

## Timing

The core exercise is exactly 90 minutes:

- Launch problem: 5 minutes
- Fabric foundation and data curation: 30 minutes
- Real-time exception detection: 20 minutes
- Ontology and decision intelligence: 25 minutes
- OneLake catalog governance and security review: 10 minutes

The Foundry IQ comparison is an optional 20–25 minute bonus and isn't included in the core duration.

## Package contents

- `Instructions\Exercises\01-build-caldova-unified-data-ai-solution.md` — learner exercise.
- `TechnicalRequirements.md` — hoster provisioning, permissions, tenant settings, networking, validation, and cleanup.
- `Labfiles\data\core\` — six trimmed Caldova CSV files required by the exercise.
- `Labfiles\notebooks\curate_caldova_tables.ipynb` — explicit typing, Delta curation, relationship checks, and decision queries.
- `Labfiles\event-simulator\` — deterministic JSON templates, Event Hubs-compatible publisher, pinned dependency, and KQL setup/query file.
- `Labfiles\agent\business-context-instructions.txt` — authoritative definitions, source guidance, and response policy.
- `Labfiles\optional\knowledge\` — three relevant unprotected documents for a hoster-enabled optional knowledge source.

## Design decisions

- The core package uses only launch program, product, plant, capacity plan, batch, and supplier data: 318 rows across six tables.
- The event publisher produces 10 clearly labeled simulated events and preserves shared Caldova keys.
- `realtime_dispense.csv` isn't included because it duplicates historical dispense records after date normalization.
- No inventory snapshot, Litware data, sentiment text, Azure SQL mirrored source, or sentiment-generation flow is fabricated.
- The data agent comparison is labeled **baseline** versus **business-context-enhanced** because the baseline is data-grounded after a Lakehouse is attached.
- Power BI is omitted from the core so the 25-minute phase can credibly implement and compare ontology-driven context.
- The optional task uses the current ontology-based Foundry IQ knowledge-base path. It doesn't substitute a Fabric data agent tool for a knowledge base.

## Validation

The package is designed for hoster preflight in a paid Fabric and optional Foundry environment. Local validation covers:

- CSV counts, headers, primary keys, and tested foreign-key relationships.
- Notebook JSON structure and Python syntax.
- Event-template schema and deterministic exception counts.
- Event publisher dry-run output.
- Relative file references and required package paths.
- Core timing arithmetic.
- Exercise structure and the applicable all-exercises and code/CLI checklist items.

Cloud UI, tenant settings, regional quota, service availability, and cross-service identity flows require hoster validation as described in `TechnicalRequirements.md`.
