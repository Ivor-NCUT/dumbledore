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
---
```

正文结构：

```markdown
# 标题

## 一句话摘要

## 为什么值得记录

## 关键知识

## 提到的痛点

## 方法论和 SOP

## Agent Skill 建议

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
