---
title: OpenClaw Skill 创建适配
type: method
created_at: 2026-05-02
updated_at: 2026-05-02
source_ids: ["source_20260502_agentforge_openclaw"]
tags: ["openclaw", "skill-creation", "agentforge", "dumbledore"]
---

# OpenClaw Skill 创建适配

## 核心结论

当 Dumbledore 从材料中提出 Agent Skill 建议时，如果目标运行时包含 OpenClaw，就不应只输出“建议做一个 skill”。它还要输出这个 skill 在 OpenClaw 中的类型、目录结构、frontmatter、引用资料、数据文件、测试方式和安全审计要求。

## Skill 类型

### Workflow

用于有稳定步骤的任务，例如研究、诊断、整理、生成报告。

推荐结构：

```text
skills/<skill-name>/
└── SKILL.md
```

### Role

用于专家身份、写作风格、评审角色、咨询角色。

推荐结构：

```text
skills/<skill-name>/
├── SKILL.md
└── references/
    └── style-or-rules.md
```

### Data-driven

用于需要读取稳定资料、档案、表格、案例库的 skill。

推荐结构：

```text
skills/<skill-name>/
├── SKILL.md
└── data/
    └── source-of-truth.md
```

### Hybrid

用于同时包含角色、流程和资料的复杂 skill。

推荐结构：

```text
skills/<skill-name>/
├── SKILL.md
├── references/
└── data/
```

## OpenClaw Frontmatter

最小 frontmatter：

```yaml
---
name: skill-name
description: "What it does and when to use it. Triggers: 'trigger one', 'trigger two'."
---
```

注意：

- `name` 和 `description` 必须存在。
- 触发词必须写进 `description`。
- 可选字段只使用 OpenClaw 支持的字段，例如 `allowed-tools`、`license`、`metadata`。
- 不要添加未确认支持的字段，例如 `version`。

## SKILL.md 内容结构

按类型选择：

- Workflow：标题、算法步骤、输入输出、示例、限制。
- Role：角色、风格规则、评判标准、示例、不要做什么。
- Data-driven：数据位置、读取顺序、更新规则、示例、数据边界。
- Hybrid：角色、流程、引用资料、数据文件、示例、边界。

## Dumbledore 生成 OpenClaw Skill 建议时必须包含

- `openclaw_type`：Workflow / Role / Data-driven / Hybrid。
- `openclaw_structure`：建议创建的目录和文件。
- `frontmatter_draft`：`name`、`description` 和触发词。
- `core_algorithm`：`SKILL.md` 中应包含的核心步骤。
- `references_needed`：是否需要 `references/`。
- `data_needed`：是否需要 `data/`，以及为什么不能放入 `memory/`。
- `scripts_needed`：是否需要 `scripts/`。
- `examples`：至少 2 个真实调用例子。
- `validation`：如何手动测试和检查触发。
- `public_audit`：公开发布前要移除哪些私人信息。

## 创建前审批

OpenClaw skill 生成前应先展示草案：

```text
Skill 草案：<name>
OpenClaw 类型：Workflow / Role / Data-driven / Hybrid
解决痛点：...
触发方式：...
目录结构：...
示例调用：...
```

用户确认后再创建文件。

## 常见风险

- `description` 没有触发词，导致 skill 不被调用。
- `SKILL.md` 太长，应该把细节拆到 `references/`。
- 把长期数据放到 `memory/`，导致数据边界混乱。
- 没有 examples，导致上下文压缩后行为漂移。
- 公开版含有本地路径、账号、内部项目名或密钥。

## 完整 Agent 的边界

如果材料中的需求不是单个可复用流程，而是一个长期工作角色，Dumbledore 应建议创建 OpenClaw agent，而不是只创建 skill。

完整 agent 通常需要：

- `AGENTS.md`
- `SOUL.md`
- `USER.md`
- `IDENTITY.md`
- `MEMORY.md`
- `TOOLS.md`
- `BOOTSTRAP.md`
- `memory/lessons.md`
- `memory/patterns.md`
- `memory/projects-log.md`
- `memory/architecture.md`
- `memory/handoff.md`

判断标准：如果它需要独立身份、长期记忆、工具权限、团队协作或持续改进，就更像 agent；如果它只是可复用任务能力，就更像 skill。
