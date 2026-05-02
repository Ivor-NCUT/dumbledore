---
id: source_20260502_agentforge_openclaw
title: AgentForge for OpenClaw
source_type: repo
source_url: https://github.com/AlekseiUL/agentforge-openclaw
author: AlekseiUL
published_at:
captured_at: 2026-05-02
privacy: public
status: accepted
tags: ["openclaw", "agentforge", "skill-creation", "agent-native"]
---

# AgentForge for OpenClaw

## 一句话摘要

AgentForge for OpenClaw 是一个面向 OpenClaw 的 skill 与 agent 创建流程项目，核心价值在于把 skill 类型、目录结构、frontmatter、测试、公开版审计、agent 记忆系统和自我改进流程整理成可执行 pipeline。

## 为什么值得记录

Dumbledore 需要在“从材料生成 skill 建议”时适配不同 Agent 运行时。OpenClaw 的 skill 形态和 Codex/Claude Code 类似，但它对 `data/`、`references/`、触发词、公开版审计、agent workspace 和记忆文件有更明确的约束，因此值得单独沉淀。

## 关键知识

- OpenClaw skill 的最小结构是 `skills/<name>/SKILL.md`。
- 复杂 skill 可追加 `references/`、`data/`、`scripts/`、`assets/`。
- `SKILL.md` frontmatter 必须包含 `name` 和 `description`；触发词应写在 `description`，因为正文通常在触发后才加载。
- OpenClaw skill 可分为 Workflow、Role、Data-driven、Hybrid 四类。
- 数据应放在 `skills/<name>/data/`，不要放在 `memory/`。
- 详细背景、风格词典、案例库应放在 `references/`，避免 `SKILL.md` 过长。
- 创建 skill 前应先展示草案并等待 owner 确认。
- 公开发布前要移除个人信息、内部路径、token、密钥和本地路径。
- 完整 OpenClaw agent 不只是 `AGENTS.md`，还包括 `SOUL.md`、`USER.md`、`IDENTITY.md`、`MEMORY.md`、`TOOLS.md` 和 `memory/` 文件。

## 提到的痛点

- 只写一个 `AGENTS.md` 容易让 agent 缺少身份、记忆、工具和团队协作上下文。
- skill 触发词不写在 frontmatter `description` 会导致 agent 不知道何时加载。
- 把数据放进 `memory/` 会和清理、会话记忆、长期资料边界混淆。
- 没有 examples 的 skill 在上下文压缩后容易失效。

## 方法论和 SOP

见 `brain/methods/openclaw-skill-creation.md`。

## Agent Skill 建议

Dumbledore 在生成 skill 建议时，应新增 `OpenClaw 适配` 区块，明确 skill 类型、目录结构、frontmatter、数据/引用放置、测试方式和公开版审计。

## 关联页面

- `brain/methods/openclaw-skill-creation.md`
- `templates/openclaw-skill-package.md`
- `skills/dumbledore/SKILL.md`
