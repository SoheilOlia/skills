# Skills

A collection of installable agent skills for Amp, Claude Code, and Claude.

## Available Skills

| Skill | Description |
|-------|-------------|
| [boil_ocean](boil_ocean/) | Complete implementation standard: search, build the real fix, test, document receipts, and ship without hidden loose ends |
| [soho](soho/) | Soho execution skill pack: planning, swarm orchestration, TDD, debugging, synthesis, and verification |
| [jack-officehour](jack-officehour/) | Block 2.0 strategic review |
| [agent5](agent5/) | Cash App Trust & Safety copy generator — 48 guardrail rules, 37 template IDs |

## Install

Install any single skill:

```bash
curl -sL https://raw.githubusercontent.com/SoheilOlia/skills/main/install.sh | bash -s boil_ocean
```

Install the full Soho skill pack:

```bash
curl -sL https://raw.githubusercontent.com/SoheilOlia/skills/main/install.sh | bash -s soho
```

The installer writes to `~/.agents/skills` and links the same skill into
`~/.codex/skills` and `~/.claude/skills` when those directories exist or can be
created. If `sq agents skills` is available, the installer uses it.
