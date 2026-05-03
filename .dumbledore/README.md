# Dumbledore State

这个目录保存 Dumbledore 对当前仓库的状态判断，不属于知识内容本身。

关键文件：

- `state.json`：由 onboarding 写入的状态文件
- `state.example.json`：状态文件示例

Agent 判断“是否首次使用”时，不应猜测，而应检查 `state.json` 是否存在且有效。

推荐字段：

- `version`
- `onboarding_completed`
- `completed_at`
- `publish_mode`
- `origin_url`
- `raw_enabled`

`publish_mode` 取值：

- `local_only`：本地初始化已完成，可处理材料，但不能自动推送
- `github_bound`：已绑定用户自己的 GitHub 仓库，可自动发布
