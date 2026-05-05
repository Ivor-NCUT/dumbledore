---
title: 微信公众号文章进入 Dumbledore 的处理流程
type: method
created_at: 2026-05-06
updated_at: 2026-05-06
source_ids: ["source_20260506_wechat_article_to_markdown"]
tags: ["wechat", "raw", "markdown", "article-ingestion"]
---

# 微信公众号文章进入 Dumbledore 的处理流程

## 核心结论

当用户发送 `mp.weixin.qq.com` 文章链接时，Dumbledore 不应假装自己能直接读取公众号正文。它应该先调用 `wechat-article-to-markdown` 把文章转换为 Markdown，再把 Markdown 原文纳入 `raw/`，之后才进入知识分析、SOP 抽取、script 建议和 skill 建议。

## 依赖

优先使用以下任一安装方式：

```bash
uv tool install wechat-article-to-markdown
pipx install wechat-article-to-markdown
npx skills add jackwener/wechat-article-to-markdown
```

Dumbledore 仓库提供 wrapper：

```bash
scripts/fetch-wechat-article.sh "<mp.weixin.qq.com URL>"
```

## 工作流程

1. 识别用户材料是否包含 `mp.weixin.qq.com` 链接。
2. 先确认 onboarding 已完成。
3. 在更新提案里列出预期 raw 文件路径。
4. 用户确认写入后，运行 `scripts/fetch-wechat-article.sh "<url>"`。
5. wrapper 调用 `wechat-article-to-markdown`，生成 Markdown 和图片。
6. wrapper 将 Markdown 复制到 `raw/YYYYMMDD_slug.md`。
7. 若存在图片，复制到 `raw/YYYYMMDD_slug_images/` 并重写 Markdown 图片链接。
8. Dumbledore 读取 `raw/` Markdown，再继续生成 `brain/sources/`、`atoms/`、`brain/methods/`、`brain/problems/` 和 `brain/skill-ideas/`。

## 失败处理

- 如果缺少转换器，提示用户安装 `uv tool install wechat-article-to-markdown` 或 `pipx install wechat-article-to-markdown`。
- 如果抓取触发验证码或未生成 Markdown，保存错误信息，不要编造文章内容。
- 如果微信链接失效，要求用户提供可访问链接、复制出的全文，或转写后的 Markdown。
- 如果用户只想测试链接，不进入知识库，仍可只运行 wrapper，不写结构化知识页。

## 隐私和版权

- 公开公众号文章可保存 Markdown 原文用于个人知识库，但不要把用户私人知识库推送到上游模板仓库。
- 如果文章来自付费、私密或受限渠道，只保存用户有权保存的内容，必要时改为摘要和知识原子。
