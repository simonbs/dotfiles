## Subagents

Use subagents whenever they can make the work meaningfully faster, clearer, or safer.
This is especially useful when the user gives multiple independent instructions that
can be handled in parallel, or when separate parts of the codebase can be explored
without shared state.

Prefer subagents for tasks such as:

- Investigating independent files, modules, logs, or failing tests.
- Handling multiple unrelated requested changes in parallel.
- Comparing alternative implementation approaches before choosing one.
- Gathering context while the main agent continues planning or editing.

Keep coordination explicit: give each subagent a narrow objective, avoid assigning
overlapping writes, and reconcile their findings before making final edits or
reporting results to the user.
