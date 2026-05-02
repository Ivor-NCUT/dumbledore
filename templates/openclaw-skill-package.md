# OpenClaw Skill Package Proposal

## Basic

- Skill name:
- Runtime target: OpenClaw
- OpenClaw type: Workflow | Role | Data-driven | Hybrid
- Priority: P0 | P1 | P2 | P3

## Pain

What recurring pain does this skill solve?

## Trigger

Write trigger phrases in the `description` frontmatter because OpenClaw loads the body after activation.

```yaml
---
name:
description: "What it does and when to use it. Triggers: '', ''."
---
```

## Structure

```text
skills/<skill-name>/
├── SKILL.md
├── references/
└── data/
```

Remove unused folders before creating the final skill.

## SKILL.md Draft

### Role or Goal

### Algorithm

### Input

### Output

### Examples

### Limits

## References

- `references/...`

## Data

- `data/...`

Data belongs in `data/`, not `memory/`.

## Scripts

- `scripts/...`

## Validation

- Trigger test:
- Edge case:
- Data/reference read test:
- Public audit:

## Approval

Do not create files until the user confirms this package.
