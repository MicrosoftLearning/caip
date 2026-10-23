# Agent instructions: Generate workshop labs

Use these instructions when an agent creates or restructures a workshop lab to follow **03_Lab Style Guide.docx**. Produce learner-facing Markdown files, not a description of how to create them. The required page hierarchy is workshop introduction, exercise overview, and major-task pages with expandable key-task solutions.

This is an explicitly referenced authoring specification. An invoking agent must read this file before generating the lab. It isn't an automatically loaded VS Code instruction file and doesn't define a standalone agent.

## Required inputs

Resolve these inputs from the user request and supplied source material before writing:

| Input | Required information |
| --- | --- |
| Scope and destination | Create a workshop, add an exercise, or convert existing content; target repository and output directory. |
| Workshop context | Title, business problem, case-study organization, learner role, and intended final deliverable. |
| Technical scope | Products, supported environment, required access, tested versions where relevant, and supporting documentation or assets. |
| Exercise plan | Exercise sequence, measurable objectives, estimated durations, major tasks, and required starting states. |
| Verification | Observable success criteria, expected results, and evidence learners must retain. |
| Existing content | Files to preserve or convert, applicable repository instructions, and publishing requirements. |

- Infer inputs only when the source material supports them. Use meaningful scenario-specific content, not generic filler.
- Ask for missing information that changes scope, technical correctness, required access, or expected results before generating affected content.
- If only part of a lab is requested, require inputs for that part and its parent context. Don't generate unrelated pages.
- If an estimate is needed, identify it as an estimate. Don't claim that a duration, command, UI path, or environment is tested without evidence.
- Omit optional content when it adds no value or lacks supporting assets. If a required input remains unresolved, report the blocker instead of presenting a placeholder-filled lab as complete.

## Output contract

Use the following structure for a new workshop unless the user specifies another destination. Preserve an existing repository's naming conventions when adding to it.

```text
index.md
media/
  ARCHITECTURE-IMAGE.png
Instructions/
  Exercises/
    01-EXERCISE-SLUG/
      index.md
      01-TASK-SLUG.md
      02-TASK-SLUG.md
      media/
        SCREENSHOT-NAME.png
```

| Page type | Required output |
| --- | --- |
| Workshop introduction | One root `index.md` with workshop context, architecture, linked exercises, and prerequisites. |
| Exercise overview | One page per exercise with scenario, objectives, duration, and `has_children: true`. |
| Major task | One page per major task with introduction, description, success criteria, and key tasks with expandable solutions. |

- Generate only files authorized by the requested scope. Never overwrite the repository's existing root index, move an existing lab, or change site configuration merely to match the example hierarchy.
- Treat the three template blocks below as output schemas. Instantiate them into separate files without their enclosing `~~~markdown` fences or authoring comments.
- Replace all uppercase placeholders in prose, YAML, links, and image paths. Placeholder values are scoped to their page or item: repeated `EXERCISE_TITLE`, `TASK_TITLE`, and `SUBTASK_TITLE` tokens aren't global replacements.
- Replace instructional scaffold text such as "Explain how" and "Describe the evidence" with actual learner-facing content.
- Use two-digit display numbers for exercises, tasks, and key tasks. The sample `01` and `02` values illustrate structure, not fixed values.
- Use numeric `nav_order` values. Keep the workshop introduction first, order exercise pages among top-level siblings, and order major tasks within their exercise. Match each task's `parent` exactly to its exercise page's `title`.
- Link every generated exercise from the workshop page and every generated major task from its exercise overview. Resolve links relative to the file that contains them.
- Use existing, verified image assets only. Don't leave broken image references or fabricate screenshots. If a screenshot is essential but unavailable, report it as a delivery blocker.

## Generation procedure

1. Read the supplied source material, applicable repository instructions, destination files, and site configuration. Identify the authorized scope and preserve unrelated content.
1. Resolve the required inputs. Map each objective to a major task, observable success criteria, and a verification action.
1. Generate the requested workshop and exercise overview pages from templates 1 and 2. Keep workshop-wide prerequisites on the introduction page and exercise-specific preparation on its overview.
1. Generate each major-task page from template 3. Give every key task a meaningful goal outside its solution, then provide discrete executable steps inside its own expandable solution.
1. Add expected results, relevant notes, warnings before risky actions, and verified screenshots under the steps they support. Add cleanup only when applicable and safe.
1. Validate the generated files against every applicable requirement below. Fix authoring defects before delivery, and report any validation that cannot be performed.
1. Return a concise delivery report with links to created or changed files, checks performed and their results, estimates or assumptions, and remaining blockers. Distinguish authored content from technically tested content.

## Authoring constraints

- Preserve the guide's required section order. Include optional tips and learning resources only when useful. Cleanup is an extension, not a requirement from the Word guide.
- Write in second person, active voice, concise US English, and sentence-style capitalization. Use imperative, input-neutral verbs in procedures.
- Use H1 titles because these are standalone lab pages, not Microsoft Learn unit includes.
- Use H3 headings in the form `### Key task 01: Descriptive subtask title`. Reset key-task numbering within each major task.
- Use `1.` for every numbered list marker and four spaces per nested level. Keep procedures to no more than seven steps by splitting long procedures into meaningful key tasks.
- Indent notes, warnings, screenshots, code blocks, and expected results under their associated step. Keep opening text and the completion statement outside numbered lists.
- Use the exact expandable-solution markup shown in template 3, with blank lines around the Markdown body. Close each solution before the next key-task heading.
- Use bold UI labels, inline code for literal values and commands, and language-tagged fenced blocks for multiline code. Explain code purpose and how to verify its result.
- End the final key-task solution with a completion statement connecting the technical accomplishment to the case study.
- Preserve relevant content, prerequisites, cautions, and resource boundaries when converting an existing lab. Don't silently drop activities or label walkthrough-only work as implemented.
- Never invent product capabilities, permissions, URLs, commands, UI labels, evidence, or successful test results. Verify technical details against supplied tested assets or current authoritative documentation.
- Writing a procedure doesn't authorize executing its cloud deployments, purchases, permission changes, or cleanup. Perform environment-changing validation only when separately authorized.

## Publishing compatibility

The front matter below mirrors the Word guide. Fields such as `nav_order`, `has_children`, and `parent` require a compatible theme. This repository currently uses `MicrosoftLearning/Jekyll-Theme` with `markdown: GFM`. Inspect the target repository rather than assuming that configuration applies elsewhere.

- Verify hierarchical navigation, callout styling, and Markdown inside `<details>` on the target site. Don't claim rendering passed when no preview or build was available.
- Preserve existing `lab:` metadata when converting an exercise. If the target catalog requires it, add supported `lab:` fields to exercise overviews, not child task pages. Don't invent a level or product taxonomy.
- Don't change the site's theme or configuration without explicit authorization. Report incompatibilities and request a decision when a different output structure is needed.

## Template 1: Workshop introduction

Instantiate this schema in the authorized workshop introduction file.

~~~markdown
---
title: Introduction
layout: home
nav_order: 1
---

# TechWorkshop: WORKSHOP_TITLE

This lab teaches you to WORKSHOP_OUTCOME by using HERO_PRODUCTS. You act as LEARNER_ROLE to help CASE_STUDY_ORGANIZATION address BUSINESS_PROBLEM.

During the lab, you MAIN_ACTIVITIES and produce FINAL_DELIVERABLE.

## Architecture

The solution uses PRODUCT_OR_COMPONENT to PURPOSE. Describe how the main components connect, how data moves between them, and which boundaries matter to the scenario.

<!-- Optional: Add an architecture diagram when it clarifies the solution. Replace the path and alt text, or remove the image. -->
![Architecture diagram showing COMPONENTS and DATA_FLOW.](media/ARCHITECTURE-IMAGE.png)

## Exercises

This lab has the following exercises:

- [Exercise 01: EXERCISE_TITLE](Instructions/Exercises/01-EXERCISE-SLUG/index.md): EXERCISE_OUTCOME.
- [Exercise 02: EXERCISE_TITLE](Instructions/Exercises/02-EXERCISE-SLUG/index.md): EXERCISE_OUTCOME.

## Prerequisites

To complete this lab, you need:

- REQUIRED_ACCOUNT_OR_LICENSE with REQUIRED_PERMISSIONS.
- REQUIRED_SUBSCRIPTION_OR_ENVIRONMENT.
- REQUIRED_TOOLS_AND_TESTED_VERSIONS.
- REQUIRED_PRIOR_KNOWLEDGE.
- REQUIRED_STARTER_ASSETS_OR_SETUP.

<!-- Optional: Add workshop-wide sections for environment access, costs, data handling, or provider setup. Keep exercise-specific details on the exercise pages. -->
~~~

## Template 2: Exercise overview

Instantiate this schema once per requested exercise. Use this page to set expectations, not to repeat the task solutions.

~~~markdown
---
title: 'Exercise 01: EXERCISE_TITLE'
layout: default
nav_order: 2
has_children: true
---

# Exercise 01: EXERCISE_TITLE

## Scenario

CASE_STUDY_ORGANIZATION needs BUSINESS_OUTCOME because BUSINESS_PROBLEM. As LEARNER_ROLE, you address this need by EXERCISE_APPROACH.

In this exercise, you MAIN_ACTIVITIES to produce EXERCISE_DELIVERABLE.

## Objectives

At the end of this lab exercise, you'll be able to:

- ACTION_VERB MEASURABLE_OUTCOME.
- ACTION_VERB MEASURABLE_OUTCOME.
- ACTION_VERB MEASURABLE_OUTCOME.

## Duration

**Estimated time:** DURATION_MINUTES minutes

<!-- Optional: Retain this section when the exercise needs preparation beyond the workshop prerequisites. -->
## Before you begin

Confirm that REQUIRED_STARTING_STATE is available. Complete REQUIRED_SETUP before you start the first task.

<!-- Optional: Use explicit task links when they help learners navigate independently of the site theme. -->
## Tasks

- [Task 01: TASK_TITLE](01-TASK-SLUG.md)
- [Task 02: TASK_TITLE](02-TASK-SLUG.md)
~~~

## Template 3: Exercise major task

Instantiate this schema once per requested major task. Repeat the key-task pattern as needed. Each solution must contain enough detail for a learner to complete and verify the subtask.

~~~markdown
---
title: '01: TASK_TITLE'
layout: default
nav_order: 1
parent: 'Exercise 01: EXERCISE_TITLE'
---

# Task 01: TASK_TITLE

## Introduction

CASE_STUDY_ORGANIZATION needs TASK_BUSINESS_OUTCOME. Explain how this task addresses that need and connects to the exercise scenario.

## Description

In this task, you'll TASK_ACTIVITIES to create or configure TASK_DELIVERABLE.

## Success criteria

You complete this task when:

- OBSERVABLE_RESULT is present in VERIFICATION_LOCATION.
- VALIDATION_ACTION returns EXPECTED_RESULT.
- REQUIRED_EVIDENCE demonstrates SCENARIO_OUTCOME.

<!-- Optional: Remove this section if no task-specific tips are needed. -->
## Tips

- TASK_SPECIFIC_HINT.
- COMMON_PITFALL_AND_HOW_TO_AVOID_IT.

<!-- Optional: Remove this section if no supporting resources are needed. -->
## Learning resource

- [RESOURCE_TITLE](RESOURCE_URL)

## Key tasks

### Key task 01: SUBTASK_TITLE

Explain what you need to accomplish and why it matters to the scenario. State the goal without requiring learners to open the solution.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open TOOL_OR_PORTAL and navigate to **UI_LOCATION**.
1. Select **UI_ELEMENT** and configure the following settings:

    1. Enter `REQUIRED_VALUE` in **FIELD_NAME**.
    1. Select **OPTION_NAME**, and then select **SAVE_ACTION**.

        ![Screenshot showing CONFIGURED_STATE in UI_LOCATION.](media/SCREENSHOT-NAME.png)

    {: .note }
    > **Note:** Explain context that helps you complete this step.

1. Perform NEXT_ACTION.

    {: .warning }
    > **Warning:** Explain the specific risk and how to avoid it before you perform the action.

1. Verify that OBSERVED_RESULT matches EXPECTED_RESULT in VERIFICATION_LOCATION.

    **Expected result:** Describe the visible state, output, or artifact that confirms success.

</details>

### Key task 02: SUBTASK_TITLE

Explain how this subtask builds on the previous result and advances the case study.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open PREVIOUSLY_CREATED_RESOURCE in **UI_LOCATION**.
1. Perform REQUIRED_ACTION.
1. Check VERIFICATION_LOCATION for EXPECTED_RESULT.

    **Expected result:** Describe the evidence that confirms this subtask is complete.

</details>

Congratulations! You've TASK_ACCOMPLISHMENT. CASE_STUDY_ORGANIZATION now has BUSINESS_RELEVANT_RESULT, which supports EXERCISE_OUTCOME.

<!-- Optional extension: Add task-specific cleanup when this task creates resources that aren't needed later. Otherwise, put cleanup after the final task of the exercise. -->
## Clean up

1. Preserve REQUIRED_EVIDENCE in APPROVED_LOCATION.
1. Remove or restore only YOUR_ASSIGNED_RESOURCES by using TESTED_CLEANUP_PROCEDURE. Don't change shared resources or resources that belong to another learner.
1. Verify that EXPECTED_CLEAN_STATE is restored and that no task-specific paid resources remain running.
~~~

## Validation gates

Apply these gates to generated lab files, not to the placeholder schemas in this specification. Use repository-standard checks when available. A checked item requires evidence, not an assumption. Report each applicable gate as **Passed**, **Failed**, or **Not run**, and explain failures or unavailable checks.

- **Structural gate:** Check front matter, section order, page hierarchy, task numbering, balanced expandable sections, and relative links.
- **Content gate:** Check objective coverage, executable instructions, expected results, safety boundaries, and removal of placeholders and scaffold prose.
- **Technical gate:** Test the procedures in the intended environment only when authorized and available. Otherwise, report **Not run** and identify what still needs testing.
- **Rendering gate:** Check the target site's navigation, callouts, nested numbering, images, and collapsed and expanded solutions. Otherwise, report **Not run**.

Use the following checklist as acceptance criteria. Don't copy it into learner-facing pages.

### Structure and scenario

- [ ] The workshop introduction covers the hero products, architecture, exercise list, and prerequisites.
- [ ] Each exercise overview contains a scenario, measurable objectives, and estimated duration.
- [ ] Each major task contains an introduction, description, success criteria, and key tasks.
- [ ] Each key task uses an H3 heading with a two-digit number and has its own expandable solution.
- [ ] The completion statement follows the final key-task solution and explains the case-study outcome.
- [ ] Optional sections add useful information or are removed. Cleanup is an extension to the guide, not a required section from it.

### Steps and formatting

- [ ] Steps use imperative, input-neutral verbs such as **Open**, **Select**, and **Enter**. UI labels are bold, and literal values and commands use inline code.
- [ ] Each numbered step describes a discrete action. Long procedures are split into meaningful subtasks, with no more than seven steps per procedure.
- [ ] Nested steps use `1.` markers and four spaces of indentation per list level.
- [ ] Notes, warnings, images, code blocks, and expected results are indented under their associated step. Introductory and closing text remains outside the numbered list.
- [ ] Each `<details markdown="block">` has a matching `</details>`, with blank lines separating the summary and the Markdown content.
- [ ] Screenshot alt text describes the relevant state, is unique, and ends with a period. Image paths and links resolve relative to the destination page.
- [ ] Every placeholder is replaced, unused examples are removed, and navigation titles match exactly.
- [ ] Scaffold prose and authoring comments are removed. Exercise and task links resolve, and every referenced image exists.

### Validation and delivery

- [ ] Instructions use second person, active voice, sentence-style headings, and concise US English.
- [ ] Success criteria describe observable results, and the solution verifies those exact results.
- [ ] Prerequisites identify required access, permissions, tools, and starting resources. Any prepared checkpoints or walkthrough-only activities are labeled.
- [ ] The complete exercise is tested in the intended environment, including screenshots, warnings, and cleanup.
- [ ] The target site renders navigation, nested numbering, callouts, and expanded solutions correctly. Check both collapsed and expanded views.
