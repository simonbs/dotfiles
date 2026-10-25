# Shared coding instructions

These preferences apply to both Codex and Claude Code. Use the tools and capabilities
available in the current session, and follow the repository's setup and test commands.

## Delegation

Use subagents or agent teammates, when available, whenever they can make the work
meaningfully faster, clearer, or safer. If delegation is unavailable, do the work directly.
This is especially useful when the user gives multiple independent instructions that
can be handled in parallel, or when separate parts of the codebase can be explored
without shared state.

Prefer subagents for tasks such as:

- Investigating independent files, modules, logs, or failing tests.
- Handling multiple unrelated requested changes in parallel.
- Comparing alternative implementation approaches before choosing one.
- Gathering context while the main agent continues planning or editing.

Keep coordination explicit: give each delegated task a narrow objective, avoid assigning
overlapping writes, and reconcile findings before making final edits or reporting results
to the user. State which files and working directory each agent should use; do not assume
that agents share a checkout or conversation context.

## Focused verification

- Match verification to the change and its risk. Prefer fast unit, contract, or state tests for logic;
  use UI tests appropriate to the platform for behavior that needs real interaction, and
  captures for visual checks.
- Batch related edits before running expensive tests. Select the smallest relevant set and run related
  test cases together so they share build and runner setup. Do not default to a broad UI suite.
- Reuse passing results while the relevant inputs remain unchanged. Rerun only after an affecting edit,
  a related failure, or an explicit request. After a failed group, diagnose the result and rerun the
  failed or affected cases rather than unrelated passing cases.
- Run broad regression checks when shared infrastructure or several behaviors change, when repository
  or CI requirements call for them, or when the user requests them. Keep slow system integration and
  stress tests available without making them part of every local edit cycle.
- Inspect test timings before optimizing. Distinguish build/setup, test-runner idle waits, and actual
  app work. Remove redundant checks only when unique coverage remains; do not hide failures, bypass
  interaction fidelity, or weaken readiness timeouts to obtain a faster pass.
- Report the checks actually run and any important unverified behavior. Do not repeat verification
  solely to generate more evidence after the relevant checks have passed.

## Meaningful tests

- Before adding a test, name the plausible regression or important user/API contract it catches and
  check existing coverage. Extend an existing case when practical. New code does not automatically
  need a new test; do not chase 100% coverage, test counts, or a test for every method or change.
- Prefer observable outcomes through production code. Protect data integrity, persistence, permissions,
  isolation, cancellation, rollback, resource bounds and critical user workflows. Keep distinct boundary
  and failure cases when they can fail independently, even if their setup is similar.
- Avoid tests of framework behavior, trivial getters, private file/helper organization, exact prompt
  prose, arbitrary fixture counts/colors, or assertions that restate the implementation. Exact generated
  output is appropriate when that output is the product contract, not an incidental representation.
- Use UI tests only for meaningful interaction or integration coverage that cheaper tests cannot provide.
  Screenshots without a visual oracle are captures, not appearance regression tests. Avoid overlapping
  startup tours, assertion-free launches and repeated identical cycles without a specific stress risk.
- Consolidate duplicates while retaining unique useful assertions. Do not add tests merely to replace
  removed tests or verify a low-risk cleanup. A bug fix merits a regression test when it detects the
  actual failure, has distinct value, and can run reliably at a reasonable cost.
- Keep important support/security obligations and report meaningful gaps. Never hide failures or weaken
  checks to make a suite faster; passing tests are evidence, not a guarantee that the product has no bugs.
