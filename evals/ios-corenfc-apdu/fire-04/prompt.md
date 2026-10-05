---
runs: 3
max_turns: 8
timeout_seconds: 180
allowed_tools: [Read, Grep, Glob, Skill]
tags: [ios-corenfc-apdu, fire, ios]
---
NFCISO7816APDU で SELECT FILE を投げて、256バイト超のEFを READ BINARY で読む方法
