---
title: OpenClaw Skill Forge
skill_name: openclaw-skill-forge
status: proposed
created_at: 2026-05-02
source_ids: ["source_20260502_agentforge_openclaw"]
tags: ["openclaw", "skill-creation", "agentforge", "dumbledore"]
---

# Skill 建议：OpenClaw Skill Forge

## 要解决的痛点

Dumbledore 当前能从材料中提出通用 Agent Skill 建议，但 OpenClaw 对 skill 类型、目录结构、frontmatter、`data/`、`references/`、公开版审计和 agent 边界有特定要求。如果只输出通用建议，用户还需要手动转换成 OpenClaw 可落地的结构。

## 为什么适合做成 Agent Skill

OpenClaw skill 创建是一个高频、可流程化、需要判断的问题：先判断是否值得做 skill，再判断类型，再设计结构，再输出草案，再等用户确认，再创建文件并验证。

## 触发场景

- 用户说“把这个做成 OpenClaw skill”。
- 用户发送一篇方法论材料，并要求给 OpenClaw 使用。
- 用户想把 Dumbledore 生成的 skill 建议落成 OpenClaw 文件。
- 用户问 OpenClaw 里应该做 skill 还是 agent。

## 输入

- 原始材料或 Dumbledore 的 skill 建议。
- 用户的目标运行时：OpenClaw。
- 是否公开发布。
- 是否需要数据、引用资料、脚本或外部 API。

## 输出

- OpenClaw skill 类型。
- 目录结构。
- `SKILL.md` frontmatter 草案。
- `SKILL.md` body 大纲。
- `references/`、`data/`、`scripts/` 规划。
- 2 个以上示例调用。
- 验证清单。
- 公开版审计清单。

## 工作流程

1. 判断该需求是否应该做成 skill；如果需要长期身份、记忆、工具权限或团队协作，建议做 OpenClaw agent。
2. 判断类型：Workflow / Role / Data-driven / Hybrid。
3. 规划结构：`SKILL.md`、`references/`、`data/`、`scripts/`。
4. 草拟 frontmatter，把触发词写入 `description`。
5. 草拟 `SKILL.md` 核心流程。
6. 展示草案并等待用户确认。
7. 用户确认后再创建文件。
8. 运行手动验证和公开版审计。

## 目标运行时

- Codex: 可输出通用 skill 建议。
- Claude Code: 可输出 `SKILL.md` 包结构。
- OpenClaw: 重点适配，按 OpenClaw 类型和目录结构生成。
- Manus: 先输出通用建议，等待后续适配。

## OpenClaw 适配

- OpenClaw 类型：Workflow | Role | Data-driven | Hybrid。
- 建议目录结构：`skills/<skill-name>/SKILL.md`，按需增加 `references/`、`data/`、`scripts/`。
- Frontmatter 草案：只使用已确认支持字段，必须包含 `name` 和 `description`。
- `references/` 需求：风格、案例、规则、深度说明。
- `data/` 需求：长期资料、档案、案例库、用户可更新数据。
- `scripts/` 需求：确定性批处理或外部 API 调用。
- 示例调用：至少 2 个。
- 验证方式：触发测试、边界测试、资料读取测试、公开版审计。
- 公开版审计：移除个人信息、本地路径、内部项目名、token、密钥。

## 需要读取的知识包

- `brain/methods/openclaw-skill-creation.md`
- `templates/openclaw-skill-package.md`

## 可能需要的 scripts

- OpenClaw skill 结构校验脚本。
- Frontmatter 字段校验脚本。
- 公开版敏感信息扫描脚本。

## 风险和边界

- 不复制 AgentForge 的模板原文，只吸收结构和判断原则。
- 不把 OpenClaw agent 需求误判成单个 skill。
- 不在用户确认前创建文件。
- 不在公开版中保留私人信息。

## 验收标准

- 给定一份方法论材料，能输出 OpenClaw 类型、目录结构和 frontmatter 草案。
- 能解释为什么选择 Workflow / Role / Data-driven / Hybrid。
- 能判断该做 skill 还是完整 OpenClaw agent。
- 能列出验证和公开版审计清单。
