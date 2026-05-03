# Dumbledore Onboarding

Dumbledore 的 onboarding 目标很简单：让每个用户拥有自己的知识库仓库。

上游仓库 `Ivor-NCUT/dumbledore` 是框架模板，不应该用来保存用户的私人知识材料。

第一次使用 Dumbledore 时，Agent 应先判断当前仓库是否已经完成 onboarding。若没有完成 onboarding，就应该先引导安装和绑定私人仓库，而不是直接处理用户发来的知识材料。

这个判断不应靠猜，而应靠仓库中的 `.dumbledore/state.json`。

## 一行命令安装 Skill

如果用户还没有安装 Dumbledore skill，先让用户安装主入口 skill：

```bash
npx skills add https://github.com/Ivor-NCUT/dumbledore --skill dumbledore
```

这只负责把 Agent Skill 安装到当前环境，不会创建用户的私人知识库。第一次调用 `dumbledore` 时，它会先引导 onboarding。

## 一行命令初始化知识库

```bash
curl -fsSL https://raw.githubusercontent.com/Ivor-NCUT/dumbledore/main/install.sh | bash
```

这条命令会创建一个本地 Dumbledore 知识库，并在检测到 GitHub CLI 已登录时，引导用户创建自己的 GitHub 仓库。

安装完成后，用户自己的 GitHub 仓库会绑定为当前本地仓库的 `origin`。Dumbledore 后续在用户确认写入后，会自动把知识、SOP、脚本建议和 skill 建议提交并推送到这个仓库。

安装完成后的仓库根目录还应包含 `raw/`，用于保存用户发送给 Agent 的知识性材料 Markdown 原文。

`.dumbledore/state.json` 至少应记录：

- `onboarding_completed`
- `completed_at`
- `publish_mode`
- `origin_url`
- `raw_enabled`

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

在生成提案时，Agent 应列出材料将保存到 `raw/` 的路径；确认写入后，再真正保存 Markdown 原文。

确认写入后，Agent 应运行 `scripts/publish.sh`，把最终产物发布到用户自己的 GitHub 仓库。若 `origin` 指向上游 `Ivor-NCUT/dumbledore`，必须停止，不能推送。
