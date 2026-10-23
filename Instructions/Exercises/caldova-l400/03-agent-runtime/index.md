---
title: 'Exercise 03: Implement and deploy the decision team'
layout: default
nav_order: 4
has_children: true
lab:
    title: 'Implement and deploy the Caldova decision team'
    description: 'Wire specialist tools, enforce a deterministic gate, deploy the runtime, and connect Teams.'
    level: 400
    duration: 105
    islab: true
---

# Exercise 03: Implement and deploy the decision team

## Scenario

Peter needs the same capacity answer regardless of which interface starts the request. You configure the five-agent Foundry team against the core profile, implement its release gate in the prepared codebase, deploy an isolated revision, and connect Procurement Desk to that executable runtime.

## Objectives

After you complete this exercise, you'll be able to:

- Configure specialist agents with scoped operational and policy tools.
- Implement conditional orchestration and a fail-closed deterministic release gate.
- Deploy and invoke a versioned runtime from Teams with correlated evidence.

## Duration

**Estimated time:** 105 minutes

## Before you begin

Use your completed environment or the provider's D2 checkpoint. Confirm that the provider-supplied runtime source, tool adapters, hosted SDK harness, exact deployment commands, and rollback procedure satisfy the [L400 readiness contract](../../../../Labfiles/04-caldova-agents/l400-provider-readiness.md). Missing code is a blocker, not an invitation to invent a deployment command.

## Tasks

| Task | Minutes |
| --- | ---: |
| [01: Configure scoped specialist tools](01-specialists.md) | 35 |
| [02: Implement and deploy gated orchestration](02-deploy-runtime.md) | 40 |
| [03: Connect Teams and trace decisions](03-connect-and-trace.md) | 30 |
