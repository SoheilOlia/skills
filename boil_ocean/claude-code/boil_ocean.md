---
name: boil-ocean
description: Use when implementing, fixing, refactoring, building, wiring, documenting, or shipping code or workflow changes where the user expects a finished result with tests, docs, receipts, and no avoidable loose ends. Also use when the user says "do the whole thing", "ship complete", "no workaround", "show receipts", "boil the ocean", or similar.
---

# Boil Ocean

## Purpose

Use this skill to turn an implementation request into a finished, verified deliverable. The standard is not "make progress"; it is "deliver the real thing that can be trusted."

Completeness does not mean uncontrolled scope expansion. It means closing the user's requested value chain wherever the real fix is reachable.

## Operating Contract

Before claiming done, the work must satisfy these conditions:

- The relevant existing code, docs, workflow, and tickets were searched before building.
- The intended done state is explicit enough to verify.
- The implementation follows local patterns instead of inventing a parallel system.
- The permanent fix was chosen when it is reachable inside the requested scope.
- Tests cover the changed behavior and the realistic risk surface.
- Documentation, receipts, or handoff notes exist when future agents or humans will need proof.
- External blockers are narrowed to exact owner and action, with all local work completed around them.
- Final claims separate committed truth, working-tree truth, generated-artifact truth, receipt truth, and external-system truth.

## Workflow

### 1. Orient

- Read project instructions first.
- Check current git state before editing.
- Search with `rg` or `rg --files` for existing patterns, call sites, tests, docs, and receipts.
- Identify whether named examples are fixtures, golden tests, or the whole system.
- Protect unrelated dirty changes.

### 2. Define Done

Lock a short completion contract before editing:

- user-visible outcome
- code or artifact surfaces changed
- tests or commands that will prove it
- docs, receipts, or ticket updates needed
- explicit non-goals

If the request is broad, choose the highest-impact slice that produces durable proof, not just a demo.

### 3. Build The Real Fix

- Prefer the source of truth over patching generated output.
- Do not leave a workaround when the real fix is local and reachable.
- Do not defer a small necessary follow-through item.
- Use deterministic contracts, schemas, and parsers over ad hoc string handling.
- Keep changes scoped to the user's value chain and the repo's existing ownership boundaries.
- When a blocker is external, finish all local scaffolding, tests, docs, prompts, and receipts so the blocker is the only remaining action.

### 4. Prove It

- Add or update tests before or alongside implementation.
- Run targeted tests first, then the broadest practical suite.
- Run format, lint, type, or smoke checks when available or relevant.
- Inspect generated artifacts that the user will rely on.
- If a full suite cannot run, say exactly why and what did run.

### 5. Document The Receipt

Create durable proof when the work affects a workflow, agent handoff, Linear ticket, external integration, or project status.

A good receipt includes:

- status and truth layer: HEAD, branch, working tree, generated artifact, receipt, or external system
- files changed
- exact commands run and results
- artifacts generated
- blockers and risks
- what is explicitly not claimed
- next recommended action

### 6. Finish Cleanly

- Re-check git status.
- Verify no needed process is still running.
- Make sure the final answer answers the newest user request.
- Lead with what changed and what is now true.
- Mention tests, docs, receipts, branches, commits, and PRs.
- Surface blockers directly.
- Keep follow-ups concrete and ranked.

## Quality Bars

- Correctness: behavior is exercised by tests or explicit commands.
- Integration: the real call path is wired, not merely a helper file existing.
- Evidence: every major claim has a file, command, receipt, ticket, or external source behind it.
- Maintainability: local patterns are preserved and future owners can understand the change.
- Honesty: fixture-level proof is labeled as fixture-level proof; broad readiness is claimed only after broad verification.

## Anti-Patterns

Do not:

- ship only the happy path when adversarial or edge cases are obvious
- present a plan when the user asked for the finished product
- call generated fixture output platform completion
- call a local artifact "wired" without a call site
- call something "tested" without a command or receipt
- hide to-dos in markdown without surfacing them in chat or tracking
- broaden into unrelated work just to look complete
- delete, overwrite, or revert dirty user changes to make the tree look clean

## Escalation Rule

Ask the user only when the next decision cannot be inferred, discovered, or safely scoped. Otherwise, make the conservative engineering call and continue.
