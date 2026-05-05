---
title: Dumbledore Framework Update Notification
type: method
privacy: public
created_at: 2026-05-06
updated_at: 2026-05-06
tags: ["dumbledore", "framework-update", "github", "skill-update"]
source: "User request: notify users when the upstream Dumbledore repository updates"
---

# Dumbledore Framework Update Notification

## Problem

用户的知识库仓库是从 `Ivor-NCUT/dumbledore` 复制出来的私人仓库。母仓库继续升级后，用户不应该被迫手动关注 release，也不应该因为升级框架而覆盖自己的知识材料。

## Principle

框架更新和用户知识更新必须分开：

- 用户知识保存在 `raw/`、`atoms/` 和用户创建的 `brain/` 页面里。
- 框架能力保存在 `skills/`、`scripts/`、`templates/`、schema、resolver 和说明文档里。
- 使用 Dumbledore 时先检查上游版本，只提醒，不自动改。
- 用户确认后再执行框架更新。

## SOP

1. onboarding 时在 `.dumbledore/state.json` 记录：
   - `framework_upstream_repo`
   - `framework_upstream_branch`
   - `framework_upstream_commit`
   - `framework_last_update_check_at`
2. 每次处理材料前运行：
   ```bash
   scripts/check-updates.sh
   ```
3. 如果没有更新，继续处理材料。
4. 如果有更新，告诉用户母仓库有新版本，并等待确认。
5. 用户确认后运行：
   ```bash
   scripts/update-framework.sh --yes
   ```
6. 更新脚本先备份，再同步框架拥有的文件。
7. 确认 `raw/`、`atoms/` 和用户知识材料没有被覆盖。
8. 如果仓库已绑定用户自己的 GitHub，运行：
   ```bash
   scripts/publish.sh "chore: update Dumbledore framework"
   ```

## Failure Handling

- GitHub 不可达：提示暂时无法检查更新，不阻塞材料处理。
- 本地状态缺少上游 commit：提示本地版本未知，建议运行更新脚本补齐。
- 非交互环境：只有在用户已经确认后，才允许使用 `--yes`。
- 当前仓库指向上游：停止发布，避免把用户知识或状态推到母仓库。
