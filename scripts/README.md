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

它还会检查 `.dumbledore/state.json`，只有在 `publish_mode=github_bound` 时才允许自动发布。
