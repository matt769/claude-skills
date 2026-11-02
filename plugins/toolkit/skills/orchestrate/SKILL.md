---
name: orchestrate
description: Orchestrate the implementation of a plan or task sequence using subagents
---

You have been given a plan either in the conversation or from a file,
or sequence of tasks in some form, and your job is to dispatch agents
to execute/implement each step.

Make sure there is a directory where any logs or documents can be temporarily kept
and passed between agents if necessary. Use somewhere in the workspace if it exists
and will not be picked up by git, else use a standard temp directory.

## Question at beginning and make assumptions during

Ask any questions up front. Later if any questions arise which are low impact
e.g. can be changed with low effort, you or the subagent should make the decision
and record it for presentation to the user at the end.


## Implementer

Each implementing agent should return a clear indication of success or failure,
any surprises or decisions/assumptions made, and the location of any log files
or other artefacts that may need to be passed to later agents.

These agents may themselves dispatch subagents e.g. for building/testing steps.

For code change steps, it should include (where relevant)
 - the changes themselves
 - building the code
 - running targeted tests
 - update documentation
 - committing

Example response:
```json
{
  "status": "complete",
  "assumptions": ["file xyz available at runtime"],
  "blockers": "none",
  "log_files": ["abc.txt"],
  "artefacts": [{"description": "location"}],
  "notes": "…"
}
```

## Parallelism

Some steps may be able to be dispatched in parallel e.g. read-only steps. Avoid
dispatching steps in parallel that both need to build code in order to avoid
saturating resources. Unless very clear that parallel is ok, dispatch sequentially.

## At the end

If not specified in the plan
 - run a final build and test (if relevant)
 - run a sweep to check for outdated documentation

Confirm if the full plan has been implemented. If not state which steps have and
have not, and explain the reason for stopping.
