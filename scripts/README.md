# Scripts

这里未来放确定性自动化脚本。

适合写成 script 的任务：

- 校验 `atoms/atoms.jsonl` 是否符合 schema。
- 从 `brain/sources/` 生成索引。
- 批量检查失效链接。
- 把会议记录拆成结构化段落。
- 批量生成候选 tags。

判断原则：如果任务输入输出稳定、步骤固定、不需要 Agent 主观判断，就优先写成 script，而不是 skill。

