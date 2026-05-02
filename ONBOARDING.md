# Dumbledore Onboarding

Dumbledore 的 onboarding 目标很简单：让每个用户拥有自己的知识库仓库。

上游仓库 `Ivor-NCUT/dumbledore` 是框架模板，不应该用来保存用户的私人知识材料。

## 一行命令

```bash
curl -fsSL https://raw.githubusercontent.com/Ivor-NCUT/dumbledore/main/install.sh | bash
```

这条命令会创建一个本地 Dumbledore 知识库，并在检测到 GitHub CLI 已登录时，引导用户创建自己的 GitHub 仓库。

安装完成后，用户自己的 GitHub 仓库会绑定为当前本地仓库的 `origin`。Dumbledore 后续在用户确认写入后，会自动把知识、SOP、脚本建议和 skill 建议提交并推送到这个仓库。

## 一句话给 Agent

在 Codex、Claude Code、OpenClaw、Manus 或其他 Agent 中说：

```text
帮我安装 Dumbledore，并创建我自己的 GitHub 知识库仓库。
```

Agent 应该使用 `skills/dumbledore-onboarding/SKILL.md` 的流程来引导安装。

## 推荐仓库策略

- 私人知识库：创建新的 private repo。
- 框架贡献：fork `Ivor-NCUT/dumbledore`。
- 团队知识库：创建组织下的 private repo。

不推荐把私人知识直接写入 fork 的公开仓库。

## 安装后怎么用

进入用户自己的仓库后，对 Agent 说：

```text
用 dumbledore 处理这份材料。
```

Agent 会先生成更新提案，等用户确认后才写入知识库。

确认写入后，Agent 应运行 `scripts/publish.sh`，把最终产物发布到用户自己的 GitHub 仓库。若 `origin` 指向上游 `Ivor-NCUT/dumbledore`，必须停止，不能推送。
