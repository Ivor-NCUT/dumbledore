# Knowledge Schema

## Source Page

每份材料应该在 `brain/sources/` 下保存一页来源记录。

```yaml
---
id: source_YYYYMMDD_slug
title: 标题
source_type: article | tweet | doc | meeting | transcript | audio | video | other
source_url:
author:
published_at:
captured_at: YYYY-MM-DD
privacy: public | internal | private | restricted
status: proposed | accepted | archived
tags: []
raw_source_path:
---
```

## Raw Material

每份用户发送给 Agent 的知识性材料，在用户确认写入后，都应该优先在 `raw/` 下保留一份 Markdown 原文。

推荐命名：

```text
raw/YYYYMMDD_slug.md
```

要求：

- 尽量保留原始结构和段落顺序。
- 可以补充来源链接、抓取时间和必要说明。
- 如果原始内容不是 Markdown，先转换为 Markdown 再保存。
- 如果材料含高敏信息，先按 `ACCESS_POLICY.md` 做脱敏，再决定是否保留全文。
- `brain/sources/` 页面应该回链到对应的 `raw/` 文件。

正文结构：

```markdown
# 标题

## 一句话摘要

## 为什么值得记录

## 关键知识

## 提到的痛点

## 方法论和 SOP

## Agent Skill 建议

如果目标运行时包含 OpenClaw，skill 建议页还应该包含：

- OpenClaw 类型：Workflow / Role / Data-driven / Hybrid。
- 目录结构：`SKILL.md`、`references/`、`data/`、`scripts/`。
- Frontmatter：`name`、`description` 和触发词。
- 数据边界：长期数据放在 `data/`，不要放在 `memory/`。
- 验证方式：触发测试、边界测试、公开版安全审计。

## 关联页面
```

## Knowledge Atom

知识原子写入 `atoms/atoms.jsonl`，一行一个 JSON。

```json
{
  "id": "YYYYMMDD_001",
  "knowledge": "一条可独立理解的知识点。",
  "source_id": "source_YYYYMMDD_slug",
  "type": "principle",
  "topics": ["dumbledore", "agent-native", "knowledge-management"],
  "skills": ["dumbledore"],
  "confidence": "high",
  "privacy": "internal",
  "linked_pages": ["brain/methods/example.md"]
}
```

## Atom Type

| type | 含义 |
|---|---|
| principle | 原则、公理、判断标准 |
| method | 方法、步骤、SOP |
| case | 案例 |
| anti-pattern | 反例、误区、失败模式 |
| insight | 洞察 |
| tool | 工具、脚本、操作方式 |
| question | 有长期价值的问题 |
| skill-idea | 可构建 Agent Skill 的建议 |

## Confidence

| confidence | 含义 |
|---|---|
| high | 材料明确支持，可信度高 |
| medium | 有材料支持，但需要更多上下文 |
| low | 只是初步判断，后续需要验证 |
