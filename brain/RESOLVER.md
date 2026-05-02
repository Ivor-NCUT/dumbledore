# Knowledge Resolver

当 Agent 读完一份材料后，用这个决策树判断应该如何沉淀。

## 第一步：判断是否入库

材料满足任一条件，就应该进入知识库：

- 未来可能被检索、引用或复用。
- 包含可迁移的方法论、判断标准、框架或 SOP。
- 反复出现的痛点、问题、误区或反模式。
- 对用户的项目、身份、偏好或长期判断有影响。
- 可以变成 Agent Skill、script 或流程模板。

如果材料只是临时信息、低价值闲聊、重复内容或无法确认来源，可以不入库，只在回复中说明原因。

## 第二步：选择写入位置

| 材料内容 | 写入位置 |
|---|---|
| 原始材料来源、标题、链接、日期、摘要 | `brain/sources/` |
| 单条可独立检索的知识点 | `atoms/atoms.jsonl` |
| 概念、原则、判断标准 | `brain/concepts/` |
| 方法论、流程、SOP | `brain/methods/` |
| 痛点、问题、失败模式、反模式 | `brain/problems/` |
| 项目背景、项目决策、项目上下文 | `brain/projects/` |
| 可构建 Agent Skill 的想法 | `brain/skill-ideas/` |
| 重复、确定性、输入输出明确的任务 | `scripts/` |

## 第三步：判断是否建议 skill

满足下面条件时，应该生成 skill 建议：

- 这个问题未来会反复出现。
- 需要 Agent 分阶段判断、追问、诊断或生成方案。
- 材料中有明确方法论、流程、框架或案例库。
- 这个能力可以被其他材料或项目复用。

如果用户提到 OpenClaw，或 skill 可能给 OpenClaw 使用，必须同时生成 OpenClaw 适配建议：Workflow / Role / Data-driven / Hybrid、目录结构、frontmatter、触发词、`references/`、`data/`、测试和公开版审计。

不建议做成 skill 的情况：

- 只是一次性观点。
- 没有稳定输入输出。
- 主要是确定性文件处理，写 script 更合适。
- 只是知识查询，放进知识库即可。

## 第四步：判断是否建议 script

满足下面条件时，应该生成 script 建议：

- 输入输出明确。
- 步骤稳定。
- 不需要 Agent 主观判断。
- 未来会批量或重复执行。

例子：

- 批量提取文章 frontmatter。
- 把会议记录拆成发言人段落。
- 校验 `atoms.jsonl` 格式。
- 生成知识库索引。
