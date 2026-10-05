---
runs: 3
max_turns: 8
timeout_seconds: 180
allowed_tools: [Read, Grep, Glob, Skill]
tags: [ios-security, no-fire, ios]
---
サーバー側のセッションでnonceを発行してリプレイ攻撃を防ぎたい。ステートマシンの設計は
