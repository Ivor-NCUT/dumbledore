# Dumbledore Agent Operating Protocol

本文件是所有 Agent 进入 Dumbledore 仓库后的第一入口。

## 必须遵守的流程

如果用户想安装、复制、fork、初始化自己的 Dumbledore 知识库，优先使用 `skills/dumbledore-onboarding/SKILL.md`。

当用户第一次使用 Dumbledore，或当前仓库还没有完成 onboarding 时，也必须先使用 `skills/dumbledore-onboarding/SKILL.md`，不能直接执行知识处理任务。

“还没有完成 onboarding” 至少包括这些情况：

1. 当前目录不是一个用户自己的 Dumbledore 知识库仓库。
2. 缺少 `.dumbledore/state.json`。
3. `.dumbledore/state.json` 不可解析，或其中 `onboarding_completed` 不为 `true`。
4. 根目录缺少 `raw/`，或状态文件中的 `raw_enabled` 不为 `true`。
5. `origin` 指向上游 `Ivor-NCUT/dumbledore`。
6. 状态文件声明 `publish_mode` 为 `github_bound`，但当前没有 `origin` remote。
7. 状态文件里的 `origin_url` 与当前 `origin` 不一致。

当用户发送任何知识性材料时，Agent 必须按下面流程工作：

1. 先检查是否已经完成 onboarding。若没有完成，停止当前知识处理任务，转入 onboarding。
2. 读取并理解材料，并为原文拟定 `raw/` 下的 Markdown 保存路径。
4. 判断材料属于哪些类型：
   - 长期知识
   - 案例或反例
   - 方法论或 SOP
   - 痛点或问题
   - 可自动化脚本
   - 可构建 Agent Skill
   - 只需短期参考、不应入库
5. 先生成一份更新提案，不写文件。
6. 等用户明确确认，例如“确认写入”“可以更新仓库”“按这个方案执行”。
7. 确认后先把用户发送的知识性材料保存为 `raw/` 下的 Markdown 原文，再修改其他仓库文件。
8. 修改后自动提交并推送到用户自己绑定的 GitHub 仓库。
9. 完成后总结变更，并列出新增或更新的文件、提交和推送目标。

## 禁止行为

- 不得在用户确认前写入、删除、重命名仓库文件。
- 不得把明显私密、敏感或未获授权的原文全文直接提交到公开仓库。
- 不得把用户知识材料提交或推送到上游 `Ivor-NCUT/dumbledore`。
- 不得把一次性想法包装成 skill。skill 必须服务于可重复的 Agent 工作流。
- 不得只做摘要而不保留来源、证据和可追溯链接。
- 不得在首次使用且未完成 onboarding 时直接执行知识处理任务。

## 自动发布

确认写入后，优先运行：

```bash
scripts/publish.sh "chore: update knowledge from confirmed intake"
```

如果脚本发现 `origin` 指向上游模板仓库，它会拒绝推送。Agent 不得绕过这个保护，也不得强推。

## 写入优先级

优先写入这些内容：

1. `brain/sources/`：材料来源记录。
2. `raw/`：用户发送材料的 Markdown 原文。
3. `atoms/atoms.jsonl`：结构化知识原子。
4. `brain/concepts/`：概念、原则、判断标准。
5. `brain/methods/`：方法论、SOP。
6. `brain/problems/`：痛点、问题、反模式。
7. `brain/skill-ideas/`：可以构建的 Agent Skill 建议。

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

## Onboarding 状态

`首次使用` 不依赖猜测，而依赖仓库状态。

完成 onboarding 的仓库应该包含 `.dumbledore/state.json`，推荐字段如下：

```json
{
  "version": 1,
  "onboarding_completed": true,
  "completed_at": "2026-05-02T15:04:05Z",
  "publish_mode": "local_only",
  "origin_url": null,
  "raw_enabled": true
}
```

说明：

- `publish_mode` 允许两种值：`local_only` 或 `github_bound`。
- `local_only` 表示用户已完成本地初始化，可以处理材料，但不能自动推送。
- `github_bound` 表示用户已绑定自己的 GitHub 仓库，可以进入自动发布流程。
