---
name: handoff
description: Summarise relevant parts of the current conversation into a file for another agent to work on.
disable-model-invocation: true
---

Write a handover document summarising relevant parts of the current conversation so a fresh agent can continue the work. Save to the workspace (if there's a temporary folder of suitable .gitignored location, save it here).

Relevant means focus on the latest current state unless a specific area of the conversation is specified, in which case focus on that. Exclude un-chosen options or digressions from the focus.

Return a single sentence summary, plus the location of the written file.
