---
runs: 3
max_turns: 8
timeout_seconds: 180
allowed_tools: [Read, Grep, Glob, Skill]
tags: [signature-verification, no-fire, server]
---
サーバー側で eKYC セッションの nonce をどこで払い出して、どの状態まで有効にするか、状態遷移（created→nonce_issued→…）の設計方針を教えて
