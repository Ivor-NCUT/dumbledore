# Dumbledore 邓布利多 - Agent Native 知识管理方案

> Give every piece of knowledge a place to live, a reason to stay, and a skill it may become.

**Dumbledore** 是一套 Agent Native 知识管理开源框架。它让你的 Agent 不再只是“总结文章”，而是像一位知识库校长一样，把每份材料分配到正确的位置：

- 值得长期保存的，进入知识库。
- 可以拆成判断标准的，变成知识原子。
- 能指导项目的，沉淀为 SOP。
- 反复出现的痛点，变成 Agent Skill 建议。
- 确定性、可重复的动作，变成 scripts。

一句话：**Dumbledore 把你的阅读输入，炼成 Agent 可以继承的知识、流程和能力。让你的 Agent 替你学习所有你不想学习的知识。**

> 名字灵感来自《哈利波特》里的邓布利多。本项目是非官方、非关联的开源框架，不隶属于 J.K. Rowling、Warner Bros. Discovery 或 Wizarding World 相关权利方。

## 为什么需要 Dumbledore

大多数知识库死在三个地方：

1. 只存内容，不存判断。
2. 只做摘要，不形成行动流程。
3. 只服务当前对话，换个 Agent 就失忆。

Dumbledore 的设计目标是反过来：

- **GitHub 是真源**：所有长期知识、方法论、skill 建议和变更记录都进入仓库。
- **原文先落 raw**：每份发送给 Agent 的知识性材料，都先保留一份 Markdown 原文。
- **首次使用看状态文件**：是否完成 onboarding，由 `.dumbledore/state.json` 判断，而不是靠猜。
- **Agent 先提案再发布**：任何材料录入前，Agent 必须先给你一份更新提案，等你确认后再写入文件、提交并推送到你自己的 GitHub 仓库。
- **母仓库更新会提醒**：如果 `Ivor-NCUT/dumbledore` 发布了新版本，Agent 会在使用时提醒你，并在你确认后丝滑更新到你的私有知识库。
- **知识会长出能力**：材料里的痛点、方法论和 SOP 会被识别出来，成为未来 Agent Skill 的候选。
- **人类可读，Agent 可执行**：Markdown 给人读，JSONL 给机器检索，Skill 给 Agent 执行。

## 它能做什么

当你发来一篇文章、一段会议记录、一条推文串、一个录音转写或一份项目文档时，Dumbledore 会先回答：

- 这份材料值不值得进知识库？
- 哪些关键知识应该拆成知识原子？
- 它暴露了什么痛点、问题或反模式？
- 它包含什么方法论、SOP 或项目流程？
- 它建议我们未来构建什么 Agent Skill？
- 有没有确定性任务更适合写成 script？
- 如果要更新仓库，会改哪些文件？
- 如果是微信公众号文章，是否需要先转换成 Markdown？

然后它会停下来，等你确认。确认后，它会把最终产物更新到你自己绑定的 GitHub 仓库。

## 快速开始

### 一行命令安装 Skill

如果你只是想把 Dumbledore 安装到当前 Agent 环境中：

```bash
npx skills add https://github.com/Ivor-NCUT/dumbledore --skill dumbledore
```

这条命令会安装主入口 skill：

- `dumbledore`：处理知识材料、判断首次 onboarding、引导私人知识库初始化

安装 skill 之后，第一次使用 Dumbledore 时，它应该先引导你完成 onboarding，创建你自己的知识库仓库。

### 一行命令初始化知识库

```bash
curl -fsSL https://raw.githubusercontent.com/Ivor-NCUT/dumbledore/main/install.sh | bash
```

这条命令会把 Dumbledore 复制成你自己的本地知识库。如果你已经安装并登录 GitHub CLI，它还会引导你创建自己的 GitHub 仓库。

### 一句话给 Agent

在 Codex、Claude Code、OpenClaw、Manus 或其他 Agent 中说：

```text
帮我安装 Dumbledore，并创建我自己的 GitHub 知识库仓库：https://github.com/Ivor-NCUT/dumbledore
```

Agent 应该使用 `skills/dumbledore-onboarding/SKILL.md` 的流程引导你完成安装。

### 开始处理材料

把你自己的 Dumbledore 仓库推到 GitHub 后，在 Codex、Claude Code 或其他支持本地仓库的 Agent 工具中打开它。

当你要处理材料时，对 Agent 说：

```text
用 dumbledore 处理这份材料。
```

Agent 应该先读取：

1. `AGENTS.md`
2. `ACCESS_POLICY.md`
3. `USER.md`
4. `brain/RESOLVER.md`
5. `brain/schema.md`
6. `skills/dumbledore/SKILL.md`

如果这是第一次使用 Dumbledore，或当前仓库还没有完成 onboarding，Agent 不应直接处理材料，而应先切换到 `skills/dumbledore-onboarding/SKILL.md`，帮助你完成私人仓库初始化和绑定。

这里的“第一次使用”以 `.dumbledore/state.json` 是否存在且有效为准，而不是看仓库是不是空的。

然后输出“更新提案”。只有当你明确说：

```text
确认写入
```

或：

```text
可以更新仓库
```

它才会真正修改知识库。

确认写入后，Dumbledore 会自动运行发布流程，把智能分析出的知识、SOP、脚本建议、skill 建议等最终产物提交并推送到当前绑定的 `origin` 仓库。

### 更新 Dumbledore 框架

你的私人知识库不会自动被母仓库强行覆盖。Dumbledore 使用时会检查上游版本，如果有更新，会先提醒你。

你也可以手动检查：

```bash
scripts/check-updates.sh --force
```

确认要更新后运行：

```bash
scripts/update-framework.sh --yes
```

更新脚本会保留你的 `raw/`、`atoms/` 和个人知识材料，只同步框架拥有的 skill、script、template 和 schema。更新后，Agent 会把这次框架升级提交并推送到你自己的 GitHub 仓库。

## 重要边界

`Ivor-NCUT/dumbledore` 是框架上游仓库，不是用户的私人知识库。

推荐方式：

- 个人知识管理：用 onboarding 创建一个新的 private repo。
- 团队知识管理：在团队 GitHub 组织下创建 private repo。
- 贡献框架本身：fork `Ivor-NCUT/dumbledore` 后提交 PR。

不要把私人文章、会议记录、客户材料直接写入上游仓库或公开 fork。

如果 `origin` 指向上游 `Ivor-NCUT/dumbledore`，Dumbledore 必须停止发布。用户知识只能推送到用户自己的 GitHub 仓库。

## 标准工作流

```text
你发送材料
    ↓
Dumbledore 阅读并理解
    ↓
检查母仓库是否有框架更新
    ↓
规划 raw/ 原文路径
    ↓
判断：知识库 / SOP / 痛点 / skill 建议 / script 建议 / 不入库
    ↓
输出更新提案
    ↓
你确认
    ↓
保存 Markdown 原文到 raw/
    ↓
写入 GitHub 仓库
    ↓
自动 commit + push 到用户自己的 origin
    ↓
未来 Agent 可读取、检索、复用、继续演化
```

## 目录结构

```text
.
├── AGENTS.md                    # 所有 Agent 的仓库操作协议
├── ACCESS_POLICY.md             # 隐私、版权、写入与发布边界
├── USER.md                      # 用户长期偏好、判断标准和项目背景
├── .dumbledore/                 # onboarding 状态与本仓库元信息
├── raw/                         # 用户发送材料的 Markdown 原文
├── brain/
│   ├── RESOLVER.md              # 新材料应该放在哪里的决策树
│   ├── schema.md                # 知识页面和知识原子的格式规范
│   ├── inbox/                   # 待处理材料
│   ├── sources/                 # 原始材料索引与来源记录
│   ├── concepts/                # 概念、原则、判断标准
│   ├── methods/                 # 方法论、SOP、项目流程
│   ├── problems/                # 痛点、问题、反复出现的阻塞
│   ├── projects/                # 项目上下文
│   ├── skill-ideas/             # 待构建 Agent Skill 建议
│   └── reports/                 # 阶段性知识整理报告
├── atoms/
│   ├── atoms.jsonl              # 知识原子库
│   └── README.md
├── skills/
│   ├── dumbledore/              # 管理本仓库的主入口 Agent Skill
│   └── dumbledore-onboarding/   # 安装和私有仓库初始化流程
├── scripts/
│   └── README.md                # 自动化脚本说明
├── install.sh                   # 一行命令安装入口
├── ONBOARDING.md                # 安装和私有仓库策略
└── templates/
    ├── intake-proposal.md       # 写入前提案模板
    ├── source.md                # 原始材料记录模板
    ├── knowledge-page.md        # 知识页模板
    └── skill-idea.md            # Agent Skill 建议模板
```

## 核心理念

### 1. 知识不是笔记，是可继承资产

一篇文章真正有价值的部分，不是“这篇文章讲了什么”，而是它能不能在未来帮 Agent 做判断、给建议、搭流程、建 skill。

### 2. 入库前必须先提案

Dumbledore 默认不直接改仓库。它会先告诉你：

- 为什么值得记录。
- 准备写到哪里。
- 会生成哪些知识原子。
- 会提出哪些 skill 建议。
- 如果目标是 OpenClaw，会补充 OpenClaw 类型、目录结构、frontmatter、`references/`、`data/`、测试和公开版审计。
- 会提交并推送到哪个用户绑定仓库。
- 如果材料来自微信公众号，会调用 `scripts/fetch-wechat-article.sh` 先生成 `raw/` Markdown。
- 有什么隐私或版权风险。

### 3. Skill 是方法论的软件化

如果一篇材料里有稳定流程，Dumbledore 不会只把它写成摘要。它会判断这套流程是否值得变成 Agent Skill。

### 4. GitHub 是 Agent 的公共书架

用 GitHub 管知识，不只是为了版本管理。更重要的是：任何新的 Agent 产品、本地工具、自动化脚本，都可以读取同一套真源。

## 当前状态

这是 Dumbledore 的第一版仓库骨架，已经包含：

- 主入口 Agent Skill：`skills/dumbledore/SKILL.md`
- Onboarding Agent Skill：`skills/dumbledore-onboarding/SKILL.md`
- 一行命令安装脚本：`install.sh`
- 自动发布脚本：`scripts/publish.sh`
- 微信文章转 Markdown 脚本：`scripts/fetch-wechat-article.sh`
- OpenClaw skill 创建适配：`brain/methods/openclaw-skill-creation.md`
- Agent 操作协议：`AGENTS.md`
- 隐私与版权边界：`ACCESS_POLICY.md`
- 知识分类决策树：`brain/RESOLVER.md`
- 知识原子 schema：`brain/schema.md`
- 知识原子库：`atoms/atoms.jsonl`
- 原始材料目录：`raw/`
- onboarding 状态目录：`.dumbledore/`
- 写入提案、来源页、知识页、skill 建议模板

## 适合谁

- 想把阅读材料沉淀成个人知识系统的人。
- 想让 Agent 长期记住自己方法论的人。
- 想把文章、会议、课程、播客变成 SOP 和 Agent Skill 的人。
- 想用 GitHub 作为个人数字分身知识中枢的人。
- 想构建“会进化的第二大脑”，但不想再手动整理一堆笔记的人。

## License

待定。建议开源发布前补充明确许可证，例如 MIT、Apache-2.0 或 CC BY-NC 4.0。
