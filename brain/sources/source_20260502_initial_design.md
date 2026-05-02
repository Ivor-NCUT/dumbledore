---
id: source_20260502_initial_design
title: Dumbledore 邓布利多初始设想
source_type: doc
source_url:
author: user
published_at:
captured_at: 2026-05-02
privacy: internal
status: accepted
tags: ["dumbledore", "agent-native", "knowledge-management", "github", "skills"]
---

# Dumbledore 邓布利多初始设想

## 一句话摘要

用户希望建立一套名为 Dumbledore 邓布利多的 Agent Native 知识管理开源框架，让 Agent 能从文章、文档、推特、会议记录、录音和视频中提炼知识，并判断哪些内容应该沉淀为知识库、scripts 或 Agent Skills。

## 为什么值得记录

这是本仓库的起点材料，定义了 Dumbledore 的核心工作流、协作边界和开源传播定位。

## 关键知识

- GitHub 应作为知识管理真源，方便本地同步和其他 Agent 产品读取。
- Agent 处理材料时，不应只摘要，而要判断知识、痛点、方法论、SOP、script 和 skill 的沉淀方式。
- 仓库更新前必须先让用户确认。
- 痛点和问题可以转化为 Agent Skill 候选。
- 方法论和解决方案可以抽象为 SOP，并进一步拆成一个或多个 skill。
- Dumbledore 的开源传播钩子是：把每份知识材料分配到它该去的位置，并让知识长出 Agent 能力。

## 提到的痛点

- 知识材料只被总结，不能转化为长期可复用能力。
- 不同 Agent 产品之间难以共享同一套知识和方法论。
- 手动整理知识库容易遗漏痛点、方法论和可自动化流程。

## 方法论和 SOP

见 `brain/concepts/agent-native-knowledge-management.md`。

## Agent Skill 建议

首个需要实现的 skill 是 `dumbledore`，负责作为知识库管理主入口。

## 关联页面

- `brain/concepts/agent-native-knowledge-management.md`
- `skills/dumbledore/SKILL.md`
