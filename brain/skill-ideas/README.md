# Skill Ideas

这里保存从材料中提炼出来的 Agent Skill 建议。

一条 skill 建议不等于立刻实现 skill。它先回答：

- 这个 skill 解决什么痛点？
- 为什么它值得变成 skill？
- 触发场景是什么？
- 输入和输出是什么？
- 需要哪些知识包、案例库或脚本？
- 如果目标是 OpenClaw，应该创建什么类型的 skill、目录结构和 frontmatter？
- 风险和边界是什么？

当某条建议被确认要实现时，再创建 `skills/{skill-name}/SKILL.md`。

## OpenClaw 建议必须额外说明

- 类型：Workflow / Role / Data-driven / Hybrid。
- 结构：是否需要 `SKILL.md`、`references/`、`data/`、`scripts/`。
- 触发：触发词必须写在 frontmatter `description`。
- 数据：长期数据放在 `data/`，不要放进 `memory/`。
- 审批：先展示草案，等用户确认后再创建文件。
