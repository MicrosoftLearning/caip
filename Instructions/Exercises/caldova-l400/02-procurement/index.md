---
title: 'Exercise 02: Build the procurement entry point'
layout: default
nav_order: 3
has_children: true
lab:
    title: 'Build the Caldova procurement entry point'
    description: 'Implement procurement knowledge, safe follow-up actions, and scoped Teams access.'
    level: 400
    duration: 60
    islab: true
---

# Exercise 02: Build the procurement entry point

## Scenario

Alex needs a business-owned agent for supplier contacts and RFP follow-up. It must not read unrestricted manufacturing data or imply that a procurement directory proves supplier qualification. You build this interaction separately from the technical decision runtime.

## Objectives

After you complete this exercise, you'll be able to:

- Configure a Copilot Studio agent with approved procurement sources and explicit delegation boundaries.
- Add an append-only follow-up action and verify confirmation and idempotency.
- Publish to the assigned Teams audience and test permitted and denied access.

## Duration

**Estimated time:** 60 minutes

## Before you begin

Use your completed Exercise 01 environment or the provider's D1 checkpoint. Keep the synthetic procurement RFP identifiers separate from core supplier identifiers unless the provider supplies a reviewed crosswalk. The decision service is connected in Exercise 03, not during this exercise.

## Tasks

| Task | Minutes |
| --- | ---: |
| [01: Configure procurement knowledge and boundaries](01-procurement-knowledge.md) | 25 |
| [02: Implement and test follow-up actions](02-follow-up.md) | 20 |
| [03: Publish and verify audience access](03-publish-teams.md) | 15 |
