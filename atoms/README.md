# Knowledge Atoms

`atoms.jsonl` 是结构化知识原子库。

每行是一条独立 JSON，方便未来导入向量数据库、搜索引擎或 Agent 记忆系统。

## 写入要求

- 一条 atom 只表达一个知识点。
- `knowledge` 必须离开原文也能被理解。
- 必须有 `source_id`。
- 必须有 `type`、`topics`、`confidence` 和 `privacy`。
- 如果 atom 支撑某个 skill 建议，把 skill 名写入 `skills`。

