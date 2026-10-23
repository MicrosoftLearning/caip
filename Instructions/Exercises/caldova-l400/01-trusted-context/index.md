---
title: 'Exercise 01: Establish trusted operational context'
layout: default
nav_order: 2
has_children: true
lab:
    title: 'Establish trusted Caldova operational context'
    description: 'Curate source data, replay operational signals, and establish authoritative agent context.'
    level: 400
    duration: 75
    islab: true
---

# Exercise 01: Establish trusted operational context

## Scenario

Caldova's earlier agents used conflicting definitions of available capacity. You establish a reproducible operational baseline before connecting any agent to the data. You use the supplied core data as the main decision source and retain the smaller qualification fixture only for later fault isolation.

## Objectives

After you complete this exercise, you'll be able to:

- Curate six source tables and verify their typed keys and LP001 decision evidence.
- Replay and diagnose synthetic operational events without changing the authoritative gap.
- Bind a governed business vocabulary and verify the runtime's permitted source access.

## Duration

**Estimated time:** 75 minutes

## Before you begin

Complete the [workshop prerequisites](../index.md). Use a new learner-owned workspace or an assigned isolated workspace. Start with the provider's D0 checkpoint only if recovery is necessary, and record restored work as restored rather than implemented.

## Tasks

| Task | Minutes |
| --- | ---: |
| [01: Curate and verify the core data](01-curate-data.md) | 25 |
| [02: Replay and investigate operational signals](02-stream-events.md) | 25 |
| [03: Bind and verify business context](03-bind-context.md) | 25 |
