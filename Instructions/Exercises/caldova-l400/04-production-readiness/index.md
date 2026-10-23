---
title: 'Exercise 04: Troubleshoot, optimize, and validate'
layout: default
nav_order: 5
has_children: true
lab:
    title: 'Troubleshoot and validate the Caldova agent solution'
    description: 'Repair implementation faults, measure an optimization, and assess production-readiness evidence.'
    level: 400
    duration: 120
    islab: true
---

# Exercise 04: Troubleshoot, optimize, and validate

## Scenario

The first deployment is not the finish line. Jordan must diagnose a deliberately faulty qualification filter, prove that the deployed repair ran, isolate a cross-service incident, and show that an optimization doesn't weaken correctness or governance.

## Objectives

After you complete this exercise, you'll be able to:

- Reproduce a code defect, apply a reviewed correction, and validate a remote redeployment.
- Use traces and source-access evidence to distinguish implementation faults from permission or protocol issues.
- Compare a controlled optimization against measurable accuracy, safety, and latency gates.
- Produce a release-readiness decision with explicit blockers and clean up assigned resources.

## Duration

**Estimated time:** 120 minutes

## Before you begin

Use the runtime from Exercise 03 or the provider's D3 checkpoint. The provider must keep the repair fixture isolated from core and supply the seeded incident and reset controls. Do not change a shared tenant policy to simulate a failure.

## Tasks

| Task | Minutes |
| --- | ---: |
| [01: Repair and redeploy the qualification filter](01-repair-filter.md) | 40 |
| [02: Diagnose integration and governance failures](02-diagnose-governance.md) | 30 |
| [03: Optimize and evaluate without regression](03-optimize-evaluate.md) | 30 |
| [04: Record readiness and clean up](04-release-cleanup.md) | 20 |
