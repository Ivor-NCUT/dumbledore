---
title: Dumbledore 邓布利多
type: concept
created_at: 2026-05-02
updated_at: 2026-05-02
source_ids: ["source_20260502_initial_design"]
tags: ["dumbledore", "agent-native", "knowledge-management", "github", "skills"]
---

# Dumbledore 邓布利多

## 核心结论

Dumbledore 邓布利多是一套 Agent Native 知识管理开源框架。它不是把材料保存成笔记，而是把材料转化为三类长期资产：

- 可检索的知识。
- 可执行的流程。
- 可复用的 Agent Skill。

## 背景

传统知识库偏向“存储”和“检索”。Dumbledore 进一步支持 Agent 判断、更新、路由、执行和生成新能力。

## 详细说明

当用户发送知识性材料时，Agent 应该完成以下判断：

1. 哪些信息需要进入知识库。
2. 哪些任务可以写成 scripts。
3. 哪些痛点和方法论值得构建为 Agent Skills。
4. 哪些知识只适合短期参考，不值得长期保存。

这个过程应该以 GitHub 为中枢，因为 GitHub 同时适合人类审查、版本管理、Agent 读取和跨产品同步。

Dumbledore 的命名来自“知识库校长”这个隐喻：它不替知识做笔记，而是决定每份材料应该进入哪个位置、接受什么训练、未来是否能成为一项 Agent 能力。

## 适用场景

- 文章、推特、文档、会议记录、录音转写、视频转写的长期沉淀。
- 个人方法论库、数字分身、项目知识库。
- 从材料中生成 Agent Skill 建议。
- 多个 Agent 产品共享同一套知识真源。
- 需要把个人阅读、研究和项目复盘变成可传播开源框架的场景。

## 不适用场景

- 一次性闲聊。
- 没有长期价值的临时信息。
- 不能公开或不能安全抽象的敏感材料。

## 相关知识原子

- `20260502_001`

## 相关来源

- `source_20260502_initial_design`
