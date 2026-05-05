---
id: source_20260506_wechat_article_to_markdown
title: wechat-article-to-markdown
source_type: repo
source_url: https://github.com/jackwener/wechat-article-to-markdown
author: jackwener
published_at:
captured_at: 2026-05-06
privacy: public
status: accepted
tags: ["wechat", "mp.weixin.qq.com", "markdown", "raw", "article-ingestion"]
raw_source_path:
---

# wechat-article-to-markdown

## 一句话摘要

`wechat-article-to-markdown` 是一个把微信公众号文章抓取并转换成 Markdown 的开源工具，支持提取标题、公众号、发布时间、原文链接，下载图片到本地，并处理微信文章里的代码块。

## Raw 原文

- 开源项目资料，不对应用户材料 raw 原文。

## 为什么值得记录

Dumbledore 的知识材料入口需要处理微信公众号文章。普通 Agent 往往无法直接读取 `mp.weixin.qq.com` 内容，因此需要通过专门工具先转换为 Markdown，再进入 `raw/`、提案和知识沉淀流程。

## 关键知识

- 推荐安装命令：`uv tool install wechat-article-to-markdown` 或 `pipx install wechat-article-to-markdown`。
- 也可作为 Agent Skill 安装：`npx skills add jackwener/wechat-article-to-markdown`。
- CLI 用法：`wechat-article-to-markdown "https://mp.weixin.qq.com/s/..."`。
- 默认输出结构是 `output/<article-title>/<article-title>.md` 和 `output/<article-title>/images/`。
- 工具依赖 Camoufox 做反检测抓取，适合处理普通浏览器或 Agent 难以读取的微信公众号文章。

## 提到的痛点

- Agent 无法稳定读取微信公众号文章正文。
- 微信文章图片和代码块如果不本地化，后续知识库引用容易断裂。
- Dumbledore 的 `raw/` 需要 Markdown 原文，而微信文章原始形态是动态网页。

## 方法论和 SOP

见 `brain/methods/wechat-article-ingestion.md`。

## Agent Skill 建议

可以把“微信公众号文章转 Markdown 并进入 Dumbledore raw”的流程沉淀为 Dumbledore 内置能力，不必每次让用户手动安装或手动转换。

## 关联页面

- `brain/methods/wechat-article-ingestion.md`
- `scripts/fetch-wechat-article.sh`
