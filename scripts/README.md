# Scripts

这里放确定性自动化脚本。

Dumbledore 的 Agent Skill 可以通过下面的一行命令安装：

```bash
npx skills add https://github.com/Ivor-NCUT/dumbledore --skill dumbledore dumbledore-onboarding
```

这条命令不运行本目录的脚本，只负责把 skill 安装到 Agent 环境。

适合写成 script 的任务：

- 校验 `atoms/atoms.jsonl` 是否符合 schema。
- 从 `brain/sources/` 生成索引。
- 批量检查失效链接。
- 把会议记录拆成结构化段落。
- 批量生成候选 tags。
- 检查 Dumbledore 母仓库是否有新版本，并在用户确认后更新框架文件。

判断原则：如果任务输入输出稳定、步骤固定、不需要 Agent 主观判断，就优先写成 script，而不是 skill。

## 当前脚本

### `install.sh`

仓库根目录的 `install.sh` 是 Dumbledore 的一行命令安装入口。

```bash
curl -fsSL https://raw.githubusercontent.com/Ivor-NCUT/dumbledore/main/install.sh | bash
```

它会创建用户自己的 Dumbledore 知识库仓库，并尽量引导用户推送到自己的 GitHub，而不是写入上游仓库。

安装时还会写入 `.dumbledore/state.json`：

- 未绑定 GitHub 时写成 `publish_mode=local_only`
- 绑定自己的 GitHub 后更新为 `publish_mode=github_bound`

### `publish.sh`

确认写入后，Agent 用它把最终产物发布到用户自己绑定的 GitHub 仓库。

```bash
scripts/publish.sh "chore: update knowledge from confirmed intake"
```

它会检查 `origin`，拒绝把用户知识推送到上游 `Ivor-NCUT/dumbledore`，然后执行 `git add`、`commit`、`pull --rebase` 和 `push`。

### `fetch-wechat-article.sh`

确认写入微信公众号文章后，Agent 用它把 `mp.weixin.qq.com` 链接转换为 `raw/` 下的 Markdown 原文。

```bash
scripts/fetch-wechat-article.sh "https://mp.weixin.qq.com/s/..."
```

它会调用 `wechat-article-to-markdown`。如果本机还没有安装转换器，先运行：

```bash
uv tool install wechat-article-to-markdown
```

或：

```bash
pipx install wechat-article-to-markdown
```

Dumbledore 的发布流程会检查 `.dumbledore/state.json`，只有在 `publish_mode=github_bound` 时才允许自动发布。

### `check-updates.sh`

使用 Dumbledore 时，Agent 可以先运行它来检查母仓库 `Ivor-NCUT/dumbledore` 是否有新版本。

```bash
scripts/check-updates.sh
scripts/check-updates.sh --force
```

它只负责提醒，不会修改知识库。检查结果会缓存到 `.dumbledore/update-check.json`，默认一天内不重复访问 GitHub。

### `update-framework.sh`

当用户确认更新后，Agent 用它把上游框架文件同步到用户自己的知识库仓库。

```bash
scripts/update-framework.sh --yes
```

它会先创建备份，再更新框架拥有的文件，例如 `skills/`、`scripts/`、`templates/`、`brain/schema.md` 和 `brain/RESOLVER.md`。它不会覆盖 `raw/`、`atoms/` 或用户自己的知识材料。

更新完成后，如果当前仓库已绑定用户自己的 GitHub，Agent 再运行：

```bash
scripts/publish.sh "chore: update Dumbledore framework"
```
