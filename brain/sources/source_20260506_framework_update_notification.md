---
source_id: source_20260506_framework_update_notification
title: "Dumbledore upstream framework update notification"
type: user_request
date: 2026-05-06
privacy: public
tags: ["dumbledore", "framework-update", "github", "skill-update"]
raw_path:
external_url:
---

# Dumbledore upstream framework update notification

## Summary

用户希望当 Dumbledore skill 的上游开源仓库，也就是母仓库 `Ivor-NCUT/dumbledore` 更新时，用户在使用过程中能收到更新通知，并在确认后顺滑完成更新。

## Key Requirements

- 使用过程中自动检查上游是否更新。
- 有更新时先提醒用户，不要静默更新。
- 用户确认后自动完成框架更新。
- 更新应推送到用户自己绑定的 GitHub 仓库。
- 更新不能覆盖用户的知识材料。

## Resulting Assets

- `scripts/check-updates.sh`
- `scripts/update-framework.sh`
- `brain/methods/framework-update-notification.md`
- `skills/dumbledore/SKILL.md` update-check workflow
- `skills/dumbledore-onboarding/SKILL.md` state recording workflow
