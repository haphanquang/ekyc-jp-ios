---
runs: 3
max_turns: 8
timeout_seconds: 180
allowed_tools: [Read, Grep, Glob, Skill]
tags: [signature-verification, fire, server]
---
アプリから {署名, 証明書DER} を受け取った。サーバーで何をチェックすればいい？nonce の突合も含めて
