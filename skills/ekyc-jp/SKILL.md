---
name: ekyc-jp
description: 日本のeKYC（マイナンバーカード・公的個人認証JPKI）対応のiOSアプリを設計・実装する際に最初に使用。My Number Card の CoreNFC 読み取り、署名検証サーバー、犯収法の本人確認方法選定など、適切な個別スキルへ誘導する。
---

# ekyc-jp（ルーター）

`ekyc-jp` プラグインの入口。ここには詳細知識を置かない。目的に対応する個別スキルへ誘導する表と、5つの不変のルールだけを示す。JPKI・方式名・APDU 等の説明は各スキルと `references/` にある。

## このスキル群について

3階層＋保守で全19スキル（本ルーターを含む）。まず該当する階層を特定し、業務・法務（Tier 1）を確認してから実装スキル（Tier 2／3）を開く。

### Tier 1 — 業務／法務（リファレンス）

| スキル | 扱う範囲 |
|---|---|
| `jpki-overview` | JPKI全体像・登場人物・信頼モデル・手数料 |
| `honnin-kakunin-houhou` | 犯収法／携帯法／古物営業法の方法選定、法改正（方法名の唯一の定義元） |
| `mynumber-card-ic` | ICチップ構造とAP一覧 |
| `kihon-4-jouhou-doui` | 基本4情報、最新4情報提供サービス、同意画面の要件 |
| `platform-jigyousha` | PF／SP事業者、CRL/OCSP、事業者選定、導入手続き |

### Tier 2 — iOS実装（手順＋チェックリスト）

| スキル | 扱う範囲 |
|---|---|
| `ios-corenfc-apdu` | CoreNFC/APDUの土台、プロジェクト設定 |
| `jpki-ap-shomei` | 署名用電子証明書の読み取りと電子署名生成 |
| `jpki-ap-riyousha` | 利用者証明用電子証明書、チャレンジレスポンス |
| `kenmen-nyuryoku-hojo-ap` | 券面入力補助APで基本4情報取得 |
| `kenmen-jikou-kakunin-ap` | 券面画像・顔写真・個人番号の取得 |
| `pin-lock-handling` | 暗証番号のロック回数、SW1SW2、ロック解除案内 |
| `ios-nfc-ux-errors` | 読み取りUX、エラー文言、アンテナ位置、App Clip |
| `ios-security` | カードデータの取り扱い、証明書ピンニング、ログ禁止項目 |

### Tier 3 — サーバー／連携（手順＋チェックリスト）

| スキル | 扱う範囲 |
|---|---|
| `signature-verification` | 署名検証、証明書チェーン、基本4情報突合、表記揺れ |
| `jlis-yukousei-kakunin` | 有効性確認（必ずPF事業者経由）、CRL/OCSP、失効時の分岐 |
| `ekyc-session-orchestration` | nonce／チャレンジ、状態遷移、リプレイ・中継対策 |
| `doui-jouhou-kanri` | 同意情報の保存・管理、同意の有効期間、開示請求 |

### 保守

| スキル | 扱う範囲 |
|---|---|
| `sources-refresh` | 一次資料の再取得・差分チェック（資料更新） |
| `ekyc-jp`（本スキル） | 入口・定型ルート・不変のルール |

## やりたいこと → 開くスキル

| 状況 / やりたいこと | 開くスキル（順序） |
|---|---|
| JPKI・eKYC の全体像、登場人物、信頼モデル、手数料を把握したい | `jpki-overview` |
| 本人確認の方法（犯収法／携帯法／古物営業法）を選定したい、法改正の影響を知りたい | `honnin-kakunin-houhou`（→ `references/method-map.md`） |
| マイナンバーカードのICチップ構造・AP一覧を把握したい | `mynumber-card-ic` |
| 基本4情報・最新4情報提供サービス・同意画面の要件を確認したい | `kihon-4-jouhou-doui` → `doui-jouhou-kanri` |
| PF／SP事業者の選定、CRL/OCSP、導入手続きを検討したい | `platform-jigyousha` |
| iOSでICチップ読み取りを始めたい（プロジェクト設定・CoreNFC/APDU） | `ios-corenfc-apdu` |
| 署名用電子証明書で電子署名を生成し、サーバーで検証したい | `ekyc-session-orchestration` → `ios-corenfc-apdu` → `jpki-ap-shomei` → `signature-verification` → `jlis-yukousei-kakunin` |
| 利用者証明用電子証明書でチャレンジレスポンス認証をしたい | `ios-corenfc-apdu` → `jpki-ap-riyousha` → `ekyc-session-orchestration` |
| 券面入力補助APで基本4情報を取得したい | `ios-corenfc-apdu` → `kenmen-nyuryoku-hojo-ap` |
| 券面画像・顔写真・個人番号を取得したい | `ios-corenfc-apdu` → `kenmen-jikou-kakunin-ap` |
| 暗証番号のロック・SW1SW2・ロック解除案内を扱いたい | `pin-lock-handling` |
| 読み取りUX、エラー文言、アンテナ位置、App Clip を設計したい | `ios-nfc-ux-errors` |
| カードデータの取り扱い、証明書ピンニング、ログ禁止項目を確認したい | `ios-security` |
| サーバーで署名検証・証明書チェーン・基本4情報突合をしたい | `signature-verification` |
| 電子証明書の有効性を確認したい | `jlis-yukousei-kakunin`（必ず `platform-jigyousha` のPF事業者経由） |
| eKYCセッションの状態遷移・nonce・リプレイ／中継対策を設計したい | `ekyc-session-orchestration` |
| 同意情報の保存・管理、同意の有効期間、開示請求に対応したい | `doui-jouhou-kanri` |
| 一次資料を再取得し差分を確認したい（資料が古い、年号の区切りに関わる質問） | `sources-refresh` |

## 不変のルール

1. J-LIS へ直接照会しない。電子証明書の有効性確認は必ずプラットフォーム事業者（PF事業者）経由で行う。アプリや未認定の自社サーバーから J-LIS へ直接アクセスしない。
2. 法令の時期・方法名（犯収法の方式名など）は `honnin-kakunin-houhou` と `references/method-map.md` のみが定義元。本スキル群の他の場所で断定しない。日付のある出典なしに法令の時期を書かない。
3. `references/sources.md` の最終更新が約3ヶ月以上前、または 2026／2027 年の時期に関わる質問のときは、先に `sources-refresh` を実行してから回答する。
4. 暗証番号はカードへの VERIFY にだけ渡す。サーバー・ログ・分析 SDK へ送らず、端末にも保存しない（生体認証付きの「記憶」も不可）。詳細は `ios-security`。
5. 電子証明書は、それを発行した JPKI の認証局（署名用 / 利用者証明用）までチェーン検証してから信用する。証明書に入っている公開鍵で署名が通るだけでは何も証明しない（`signature-verification`）。

## 出典

本スキルは詳細知識を持たない。事実・数値・手順は各スキルと `references/` を参照する。

- `references/method-map.md` — 犯収法等の方法名・時期の定義元
- `references/yougoshuu.md` — 用語集
- `references/apdu-cheatsheet.md` — APDU早見表
- `references/sources.md` — 一次資料の一覧と取得日・ハッシュ
- `references/jpki-introduction.ja.md` — デジタル庁「公的個人認証サービス（JPKI）による本人確認」
- ライブ URL: <https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction>（取得日 2026-09-08）

## 最終確認日: 2026-09-08

## 未確認事項

なし
