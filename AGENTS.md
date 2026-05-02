# Dumbledore Agent Operating Protocol

本文件是所有 Agent 进入 Dumbledore 仓库后的第一入口。

## 必须遵守的流程

如果用户想安装、复制、fork、初始化自己的 Dumbledore 知识库，优先使用 `skills/dumbledore-onboarding/SKILL.md`。

当用户发送任何知识性材料时，Agent 必须按下面流程工作：

1. 读取并理解材料。
2. 判断材料属于哪些类型：
   - 长期知识
   - 案例或反例
   - 方法论或 SOP
   - 痛点或问题
   - 可自动化脚本
   - 可构建 Agent Skill
   - 只需短期参考、不应入库
3. 先生成一份更新提案，不写文件。
4. 等用户明确确认，例如“确认写入”“可以更新仓库”“按这个方案执行”。
5. 确认后再修改仓库文件。
6. 修改后自动提交并推送到用户自己绑定的 GitHub 仓库。
7. 完成后总结变更，并列出新增或更新的文件、提交和推送目标。

## 禁止行为

- 不得在用户确认前写入、删除、重命名仓库文件。
- 不得把明显私密、敏感或未获授权的原文全文直接提交到公开仓库。
- 不得把用户知识材料提交或推送到上游 `Ivor-NCUT/dumbledore`。
- 不得把一次性想法包装成 skill。skill 必须服务于可重复的 Agent 工作流。
- 不得只做摘要而不保留来源、证据和可追溯链接。

## 自动发布

确认写入后，优先运行：

```bash
scripts/publish.sh "chore: update knowledge from confirmed intake"
```

如果脚本发现 `origin` 指向上游模板仓库，它会拒绝推送。Agent 不得绕过这个保护，也不得强推。

## 写入优先级

优先写入这些内容：

1. `brain/sources/`：材料来源记录。
2. `atoms/atoms.jsonl`：结构化知识原子。
3. `brain/concepts/`：概念、原则、判断标准。
4. `brain/methods/`：方法论、SOP。
5. `brain/problems/`：痛点、问题、反模式。
6. `brain/skill-ideas/`：可以构建的 Agent Skill 建议。

只有当用户明确要求实现 skill 时，才把建议升级为 `skills/{skill-name}/SKILL.md`。

## 质量标准

每次入库都要尽量做到：

- 有来源。
- 有日期。
- 有材料类型。
- 有知识原子。
- 有可检索标签。
- 有“为什么值得记”的判断。
- 有“是否值得做成 skill”的判断。
