---
runs: 3
max_turns: 8
timeout_seconds: 180
allowed_tools: [Read, Grep, Glob, Skill]
tags: [sources-refresh, no-fire, maintenance]
---
package.json の依存パッケージを最新に更新して、破壊的変更がないか確認したい
