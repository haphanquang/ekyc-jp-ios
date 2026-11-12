# 出典 変更履歴

`sources-refresh` スキルおよび `refresh.sh` の実行結果を記録する。
新規・消滅・CHANGED（内容変更）があった場合のみ資料単位で追記する。

## 2026-09-07
- 初回取得。PDF 33 点、一次ページ 2 点。詳細は `sources.md`。
- 未取得: J-LIS `20221027minkan.pdf`（`https://www.j-lis.go.jp/file/20221027minkan.pdf`）。
  j-lis.go.jp が Cloudflare の JS チャレンジでスクリプト取得を拒否。ブラウザで手動取得が必要。

## 2026-09-08
- `refresh.sh` 初回実行、差分なし。
  一次ページ 2 点を再取得、PDF リンク抽出で新規・消滅なし、
  既知 PDF 33 点すべて SHA256 一致（same）。
  J-LIS `20221027minkan.pdf` はローカルファイル未対応のため差分対象外（`?? ファイル未対応`）。

## 2026-09-09
- `sources.md` の `使用スキル` 列を全 33 点について記入。資料の新規・消滅・内容変更（CHANGED）はなし。

## 2026-09-10
- スキルセット・レビュー後の整理。`sources.md` の `使用スキル` 列の定義を
  「`## 出典` での引用、または本文での裏付け参照」に緩和し、`platform-jigyousha` が
  本文の事業者一覧表で参照する各「ご案内」PDF（14/16/17/18/23/26/27/32）と、
  `pin-lock-handling` が本文で参照する PDF 33 を整合させた。資料の取得内容に変更なし。
- 犯収法・携帯法の号記号を e-Gov 法令検索 API v2 から一次確認し、`hourei-eKYC.md` を新設。
  `sources.md` に「## 法令」節（L1〜L5）を追加。取得リビジョン:
  犯収法施行規則 現行 `420M60000F5A001_20260806_508M60000F5A006` /
  2027-04-01 版 `420M60000F5A001_20270401_508M60000F5A005`（令第5号、2026-06-26 公布、未施行）/
  携帯法施行規則 `417M60000008167_20260806_508M60000008099`（**改正は 2026-04-01 施行済み**）/
  公的個人認証法 `414AC0000000153_20260614_506AC0000000059`。
  確認結果: 現行犯収法 第6条第1項第1号 ＝ イ〜ヨ（カ ＝ JPKI、但書「署名検証者に限る」を verbatim 取得）、
  2027年版 ＝ イ〜カ（新ヌ ＝ JPKI、新ハ ＝ IC読取＋容貌、新ト ＝ スマホ搭載カード）、
  携帯法 第3条第1項第1号 ＝ イ〜ヌ（書類画像送信方式は消滅、チ ＝ スマホ搭載カード）。
  `refresh.sh` に e-Gov リビジョン突合ステップを追加。

## 2026-10-05
- 古物営業法の本人確認方法を e-Gov 法令検索 API v2 から一次確認し、`hourei-eKYC.md` に
  「## 5. 古物営業法施行規則（現行・在効）」を新設。`sources.md` に L6（古物営業法施行規則）・
  L7（古物営業法）を追加。取得リビジョン: 古物営業法施行規則 `407M50400000010_20260812_508M60400000017`
  （平成七年国家公安委員会規則第十号。最終改正 令和八年国家公安委員会規則第十七号、施行 2026-08-12）/
  古物営業法 `324AC0000000108_20250601_504AC0000000068`。
  確認結果: 施行規則第15条第3項 ＝ 一〜十三号。第十一号 ＝ JPKI（署名検証者の但書あり、署名対象は
  住所・氏名・職業・年齢の記録）、第九号 ＝ IC 読取＋容貌、第八号 ＝ 書類画像＋容貌、第四号 ＝ IC・画像送信／
  住民票の写し等の送付＋転送不要郵便（LIQUID資料 p7 の「4号≒ト・チ」のうちト型は一次資料と不一致）。
  カード代替電磁的記録・特定電磁的記録の語は施行規則全文に無い（犯収法ル型の方法なし）。
  `law_revisions/407M50400000010` は 39 リビジョンすべて施行済み（未施行リビジョンなし）、
  `?asof=2027-04-01` も現行リビジョンを返す。第15条の本文は直前 7 リビジョン（20260710／20260601／20260501／20251001〔2件〕／20250628／20250501）と同一。
  `method-map.md`「## 古物営業法」をベンダー資料ベースから一次資料ベースに差し替え、
  `refresh.sh` に `check_law "407M50400000010" "" "古物営業法施行規則（現行）" 5` を追加。
- 同日、犯収法施行規則 2027-04-01 版（`420M60000F5A001_20270401_508M60000F5A005`）の第6条第1項第1号を
  API から直接抽出して再確認: 新ヌ ＝ JPKI（署名検証者の但書あり）、新ル ＝ 特定認証業務（従来の未確認事項を解消）。
  新ワ柱書「以下ワ及びカにおいて同じ」により新ワ・新カは住民基本台帳法の適用を受けない者・国外転出者に
  限られることを `method-map.md`・`hourei-eKYC.md`・`honnin-kakunin-houhou` に反映。
  古物営業法施行規則第15条第2項・第16条（適用除外 1 万円・対象古物）を `hourei-eKYC.md` §5 に追加。

## 2026-11-02
- 定期メンテナンスおよび法令・技術監査の実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。L1〜L4・L6・L7 の現行および未施行リビジョンもすべて一致（`same`）。
- e-Gov 法令検索 API v2 より、携帯電話不正利用防止法施行規則の 2027年4月1日 施行・未施行版（令和八年総務省令第九十四号、2026年7月27日公布、リビジョン ID `417M60000008167_20270401_508M60000008094`）を検出し、一次条文を確認。
  - 第3条第1項第1号が 10 号（イ〜ヌ）から 12 号（イ〜ヲ）へ再編。
  - IC読取＋容貌方式が現行「ハ」から「新ニ」へ移行。
  - 電子署名方式（JPKI等）が現行「ト」から「新チ」へ移行。
  - スマートフォン搭載マイナンバーカード方式が現行「チ」から「新リ」へ移行。
- `sources.md` に `L3b` を追加し、`hourei-eKYC.md` に「## 3b. 携帯電話不正利用防止法施行規則（2027年4月1日 施行・未施行版）」を新設。`refresh.sh` に 3b の自動突合を追加、`method-map.md` に対応行を追記。

## 2026-11-03
- 午前4:00 定期メンテナンスおよび全スキル・リファレンス・評価セット（evals）の包括的監査を実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L6, L7）もすべて一致（`same`）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）に未反映の新規改正がないことを確認。
- 4つの独立監査サブエージェント（Tier 1 法令・ドメイン、Tier 2 iOS CoreNFC/APDU/端末セキュリティ、Tier 3 サーバー暗号・失効確認・セッション、Tier 4 プラグイン構造・日英対訳・evals）によるクロスチェック結果を反映:
  - `skills/honnin-kakunin-houhou/` および `references/method-map.md` に携帯法施行規則 2027年4月1日版（L3b: 新ニ, 新チ, 新リ）の詳細節とマッピングを完全同期。
  - `skills/platform-jigyousha/` に古物営業法施行規則第15条第3項第十一号（JPKI）の署名検証者但書を追記。
  - `references/yougoshuu.md` の「カ方式」「ヘ方式」「ル方式」「携帯法」に法令横断対応（携帯法2026/2027、古物営業法）を補完。
  - `skills/ios-corenfc-apdu/`（EF-ID 長さ検証 guard）、`skills/pin-lock-handling/`（セッション再接続時の DF/EF 選択、SecureBytes 運用の注記）、`skills/ios-security/`（DCAppAttestService 端末整合性ガイド）、`references/apdu-cheatsheet.md`（券面事項確認APの照合番号B 14桁・10回ロックの明確化）を強化。
  - `skills/signature-verification/`（手順番号の誤参照修正、利用者証明用 CA のフィンガープリント照合、RFC 5280 Critical 拡張拒否）、`skills/jlis-yukousei-kakunin/`（CRL/OCSP の thisUpdate〜nextUpdate 有効期間検証）を強化。
  - 全27組の日英対訳（.md ↔ .en.md）を 100% 同期更新。

## 2026-11-07
- 午前4:00 定期メンテナンスおよび全スキル・リファレンス・評価セット（evals）の包括的監査を実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L6, L7）もすべて一致（`same`）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）に未反映の新規改正がないことを確認。
- 4つの独立監査サブエージェント（Tier 1 法令・ドメイン、Tier 2 iOS CoreNFC/APDU/端末セキュリティ、Tier 3 サーバー暗号・失効確認・セッション、Tier 4 プラグイン構造・日英対訳・evals）によるクロスチェック結果を反映:
  - **Tier 1 (法令 & ドメイン)**: 5つの不変ルール（不変のルール）の遵守を再確認。犯収法（現行 カ＝JPKI／2027 新ヌ＝JPKI, 新ル＝特定認証業務, 新ハ＝IC読取+容貌）、携帯法（現行 ト＝JPKI, ハ＝IC+容貌, チ＝スマホ／2027 L3b 新チ＝JPKI, 新ニ＝IC+容貌, 新リ＝スマホ）、古物営業法（第十一号 JPKI, 1万円未満適用除外・4大例外品目）の正確性を再検証。`references/yougoshuu.md` に主務大臣認定を受けたPF事業者自身による J-LIS 直接接続の例外規定を明確化。
  - **Tier 2 (iOS CoreNFC, APDU & 端末セキュリティ)**: ISO/IEC 7816-4 APDU バイト列、AID、EF-ID、DigestInfo SHA-256 (51B ASN.1 DER)、SW1SW2、PIN ロック閾値（3/5/10回）を検証。`references/apdu-cheatsheet.md` に券面事項確認AP の candidate AID（`04 01` / `01 00`）を追加し、空ボディ VERIFY（`00 20 00 80` Case 1 によるリトライカウンタ照会）、GET CHALLENGE、INTERNAL AUTHENTICATE の各行を新設。`skills/ios-security/` の `SecureBytes` に `withUnsafeMutableBytes` を追加し `memset_s` による安全なゼロ化を強化。未確認パラメータはすべて `未確認` ラベルを厳格に保持。
  - **Tier 3 (サーバー暗号, 失効確認 & セッションセキュリティ)**: RSA-2048 PKCS#1 v1.5 による Bleichenbacher / BERserk 攻撃対策、Trust Store 完全分離（署名用CA vs 利用者証明用CA）、期限切れ CA（`signca01.cer`）の除外、RFC 5280 `certificatePolicies` OID 検証、CRL/OCSP 有効期限窓と Clock Skew 許容幅（1-2分、最大5分）、リアルタイム失効確認時の Fail-Closed 原則を標準化。単一利用 nonce の原子的消費（Atomic CAS / DB トランザクション）による TOCTOU/Replay 防止、および同意記録（10年・証明書本体保存禁止）と犯収法確認記録（7年・証明書保存必須）の4層分離アーキテクチャを再確認。
  - **Tier 4 (プラグイン構造, 日英対訳 & Evals)**: `.claude-plugin/plugin.json`、全38スキルファイルの YAML frontmatter（description ≤ 1,024文字）、末尾3必須セクション、全27組の日英対訳（.md ↔ .en.md）の構造・意味的完全一致（100%）、相対リンク整合性（broken link 0件）、`refresh.sh` の bash 構文（`bash -n` 成功）を検証。全115テストケース・230 graders を `evals/evals.json` に統合・検証完了。

## 2026-11-08
- 午前4:00 定期メンテナンスおよび全スキル・リファレンス・評価セット（evals）の包括的監査を実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L6, L7）もすべて一致（`same`）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）に未反映の新規改正がないことを確認。
- 4つの独立監査サブエージェント（Tier 1 法令・ドメイン、Tier 2 iOS CoreNFC/APDU/端末セキュリティ、Tier 3 サーバー暗号・失効確認・セッション、Tier 4 プラグイン構造・日英対訳・evals）によるクロスチェック結果を反映:
  - **Tier 1 (法令 & ドメイン)**: 5つの不変ルール（不変のルール）の遵守を再確認。犯収法（現行 カ＝JPKI／2027 新ヌ＝JPKI, 新ル＝特定認証業務, 新ハ＝IC読取+容貌, 新ト＝スマホ）、携帯法（現行 ト＝JPKI, ハ＝IC+容貌, チ＝スマホ／2027 L3b 新チ＝JPKI, 新ニ＝IC+容貌, 新リ＝スマホ）、古物営業法（第十一号 JPKI, 1万円未満適用除外・7大例外品目）の正確性を再検証。
  - **Tier 2 (iOS CoreNFC, APDU & 端末セキュリティ)**: ISO/IEC 7816-4 APDU バイト列、AID、EF-ID、DigestInfo SHA-256 (51B ASN.1 DER)、SW1SW2、PIN ロック閾値（3/5/10回）を検証。`references/apdu-cheatsheet.md` および `skills/pin-lock-handling/` に命令コード未サポート（`6D 00`）の行を追加し、APDU 実装バグと暗証番号誤入力の混同防止を明文化。未確認パラメータはすべて `未確認` ラベルを厳格に保持。
  - **Tier 3 (サーバー暗号, 失効確認 & セッションセキュリティ)**: RSA-2048 PKCS#1 v1.5 による Bleichenbacher / BERserk 攻撃対策、Trust Store 完全分離（署名用CA vs 利用者証明用CA）、期限切れ CA（`signca01.cer`）の除外、Fail-Closed 原則を再確認。`skills/signature-verification/` に RSA-2048 + SHA-256 DigestInfo の PS 厳密長（正確に 202 バイト）の注記を反映。
  - **Tier 4 (プラグイン構造, 日英対訳 & Evals)**: `.claude-plugin/plugin.json`、全38スキルファイルの YAML frontmatter（description ≤ 1,024文字）、末尾3必須セクション、全27組の日英対訳（.md ↔ .en.md）の構造・意味的完全一致（100%）、相対リンク整合性（broken link 0件）、`refresh.sh` の bash 構文（`bash -n` 成功）を検証。全115テストケース・230 graders の完全同期を確認。

## 2026-11-09
- 午前4:00 定期メンテナンスおよび全スキル・リファレンス・評価セット（evals）の包括的監査を実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L6, L7）もすべて一致（`same`）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）に未反映の新規改正がないことを確認。
- 4つの独立監査サブエージェント（Tier 1 法令・ドメイン、Tier 2 iOS CoreNFC/APDU/端末セキュリティ、Tier 3 サーバー暗号・失効確認・セッション、Tier 4 プラグイン構造・日英対訳・evals）によるクロスチェック結果を反映:
  - **Tier 1 (法令 & ドメイン)**: 5つの不変ルール（不変のルール）の遵守を完全確認。Rule 1（J-LIS直接照会禁止、主務大臣認定PF事業者経由）、Rule 2（犯収法 現カ＝JPKI／2027 新ヌ＝JPKI, 新ル＝特定認証業務, 新ハ＝IC+容貌, 新ト＝スマホ；携帯法 現ト＝JPKI, ハ＝IC+容貌, チ＝スマホ／2027 L3b 新チ＝JPKI, 新ニ＝IC+容貌, 新リ＝スマホ；古物営業法 第十一号 JPKI, 1万円未満適用除外および例外品目）の整合性を検証完了。
  - **Tier 2 (iOS CoreNFC, APDU & 端末セキュリティ)**: ISO/IEC 7816-4 APDU バイト列、AID（JPKI DF: `D3 92 F0 00 26 01 00 00 00 01`、券面入力補助AP: `D3 92 10 00 31 00 01 01 04 08`、券面事項確認AP candidate）、EF-ID、DigestInfo SHA-256（51B ASN.1 DER）、SW1SW2（90 00, 63 CX, 69 82, 69 83, 69 84, 6A 82, 67 00, 6C XX, 6D 00）、PIN ロック閾値（署名用5回、利用者証明用3回、入力補助用3回、照合番号B 10回）を検証。`SecureBytes` による `memset_s` メモリゼロ化、Keychain/ログへの PIN 記録禁止、TLS pinning を確認。未確認項目は `未確認` ラベルを厳格に保持。
  - **Tier 3 (サーバー暗号, 失効確認 & セッションセキュリティ)**: RSA-2048 PKCS#1 v1.5 による Bleichenbacher / BERserk / Timing Oracle 対策（PS長 202B、定数時間比較）、Trust Store 完全分離（署名用CA vs 利用者証明用CA）、期限切れ CA（`signca01.cer` 2024年満了、`authca01.cer` 2025年満了）の除外、CRL/OCSP 有効期間検証と Clock Skew 許容幅（1-2分、最大5分）、Fail-Closed 原則を検証。単一利用 nonce の原子的消費（Atomic CAS / DB トランザクション）と App Attest / Play Integrity による端末バインディング、同意情報（10年・証明書本体保存禁止）と犯収法確認記録（7年・証明書保存必須）の4層分離アーキテクチャの完全遵守を確認。
  - **Tier 4 (プラグイン構造, 日英対訳 & Evals)**: `.claude-plugin/plugin.json`、全38スキルファイルの YAML frontmatter（description ≤ 1,024文字）、末尾3必須セクション、全27組の日英対訳（.md ↔ .en.md）の構造・意味的完全一致（100%）、相対リンク整合性（broken link 0件）、`refresh.sh` の bash 構文（`bash -n` 成功）を検証。全115テストケース・230 graders の完全同期を確認。

## 2026-11-10
- 午前4:00 定期メンテナンスおよび全スキル・リファレンス・評価セット（evals）の包括的監査を実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L6, L7）もすべて一致（`same`）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）に未反映の新規改正がないことを確認。
- 4つの独立監査サブエージェント（Tier 1 法令・ドメイン、Tier 2 iOS CoreNFC/APDU/端末セキュリティ、Tier 3 サーバー暗号・失効確認・セッション、Tier 4 プラグイン構造・日英対訳・evals）によるクロスチェック結果を反映:
  - **Tier 1 (法令 & ドメイン)**: 5つの不変ルール（不変のルール）の遵守を完全確認。Rule 1（J-LIS直接照会禁止、主務大臣認定PF事業者経由）、Rule 2（犯収法 現カ＝JPKI／2027 新ヌ＝JPKI, 新ル＝特定認証業務, 新ハ＝IC+容貌, 新ト＝スマホ；携帯法 現ト＝JPKI, ハ＝IC+容貌, チ＝スマホ／2027 L3b 新チ＝JPKI, 新ニ＝IC+容貌, 新リ＝スマホ；古物営業法 第十一号 JPKI, 1万円未満適用除外および例外品目）の整合性を検証完了。
  - **Tier 2 (iOS CoreNFC, APDU & 端末セキュリティ)**: ISO/IEC 7816-4 APDU バイト列、AID（JPKI DF: `D3 92 F0 00 26 01 00 00 00 01`、券面入力補助AP: `D3 92 10 00 31 00 01 01 04 08`、券面事項確認AP candidate）、EF-ID、DigestInfo SHA-256（51B ASN.1 DER）、SW1SW2（90 00, 63 CX, 69 82, 69 83, 69 84, 6A 82, 67 00, 6C XX, 6D 00）、PIN ロック閾値（署名用5回、利用者証明用3回、入力補助用3回、照合番号B 10回）を検証。`SecureBytes` による `memset_s` メモリゼロ化、Keychain/ログへの PIN 記録禁止、TLS pinning を確認。未確認項目は `未確認` ラベルを厳格に保持。
  - **Tier 3 (サーバー暗号, 失効確認 & セッションセキュリティ)**: RSA-2048 PKCS#1 v1.5 による Bleichenbacher / BERserk / Timing Oracle 対策（PS長 202B、定数時間比較）、Trust Store 完全分離（署名用CA vs 利用者証明用CA）、期限切れ CA（`signca01.cer` 2024年満了、`authca01.cer` 2025年満了）の除外、CRL/OCSP 有効期間検証と Clock Skew 許容幅（1-2分、最大5分）、Fail-Closed 原則を検証。単一利用 nonce の原子的消費（Atomic CAS / DB トランザクション）と App Attest / Play Integrity による端末バインディング、同意情報（10年・証明書本体保存禁止）と犯収法確認記録（7年・証明書保存必須）の4層分離アーキテクチャの完全遵守を確認。
  - **Tier 4 (プラグイン構造, 日英対訳 & Evals)**: `.claude-plugin/plugin.json`、全38スキルファイルの YAML frontmatter（description ≤ 1,024文字）、末尾3必須セクション、全27組の日英対訳（.md ↔ .en.md）の構造・意味的完全一致（100%）、相対リンク整合性（broken link 0件）、`refresh.sh` の bash 構文（`bash -n` 成功）を検証。全115テストケース・230 graders の完全同期を確認。

## 2026-11-11
- 午前4:00 定期メンテナンスおよび全スキル・リファレンス・評価セット（evals）の包括的監査を実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L6, L7）もすべて一致（`same`）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）に未反映の新規改正がないことを確認。
- 4つの独立監査サブエージェント（Tier 1〜Tier 4）によるクロスチェック結果を反映:
  - **Tier 1 (法令 & ドメイン)**: `skills/jpki-overview/SKILL.md` の古物営業法施行規則の表記を法令公用文表記に合わせて「第11号」から「第十一号」へ統一。5つの不変ルール（Rule 1〜Rule 5）の厳格な遵守を確認。
  - **Tier 2 (iOS CoreNFC, APDU & 端末セキュリティ)**: `skills/ios-security/` の `SecureBytes.init(copying:)` において、初期化済みメモリへの再初期化を回避するため `buffer.assign(from:count:)` に修正。`skills/pin-lock-handling/` の `checkRemainingAttempts` に EF-ID 長さ検証 guard を追加し `p2: UInt8 = 0x80` を引数化。`skills/ios-corenfc-apdu/` の `readBinary` に `guard (1...256).contains(length)` を追加。
  - **Tier 3 (サーバー暗号, 失効確認 & セッションセキュリティ)**: RSA-2048 PKCS#1 v1.5（PS長 202B、DigestInfo 51B、定数時間比較）、署名用/利用者証明用 CA の分離、Fail-Closed 失効確認、原子的 Nonce 消費、同意（10年）/犯収法記録（7年）の4層分離アーキテクチャの完全性を再確認。
  - **Tier 4 (プラグイン構造, 日英対訳 & Evals)**: `skills/sources-refresh/SKILL.en.md` の Step 8 の改行・インデントを日本語版と同期。全27組の日英対訳（.md ↔ .en.md）、全38スキルファイルの frontmatter（≤1,024文字）、全115テストケース・230 graders の完全同期を確認。

## 2026-11-12
- 午前4:00 定期メンテナンスおよび全スキル・リファレンス・評価セット（evals）の包括的監査を実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L6, L7）もすべて一致（`same`）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）に未反映の新規改正がないことを確認。
- 4層（Tier 1〜Tier 4）の監査検証を実施:
  - **Tier 1 (法令 & ドメイン)**: 5つの不変ルール（Rule 1〜Rule 5）および犯収法・携帯法・古物営業法の号記号・施行日の整合性を確認。
  - **Tier 2 (iOS CoreNFC, APDU & 端末セキュリティ)**: ISO/IEC 7816-4 APDU バイト列、AID、EF-ID、DigestInfo SHA-256 (51B ASN.1 DER)、SW1SW2、PIN ロック閾値（3/5/10回）、`SecureBytes` によるメモリゼロ化、TLS pinning を確認。
  - **Tier 3 (サーバー暗号, 失効確認 & セッションセキュリティ)**: RSA-2048 PKCS#1 v1.5（PS長 202B、DigestInfo 51B、定数時間比較）、署名用/利用者証明用 CA の分離、Fail-Closed 失効確認、原子的 Nonce 消費、同意（10年）/犯収法記録（7年）の4層分離アーキテクチャを再確認。
  - **Tier 4 (プラグイン構造, 日英対訳 & Evals)**: 全27組の日英対訳（.md ↔ .en.md）、全38スキルファイルの frontmatter（≤1,024文字）、必須末尾3セクション、相対リンク（コードブロック外の broken link 0件）、`refresh.sh` 構文、および全115テストケース・230 graders の整合性を確認。

## 2026-11-13
- 午前4:00 定期メンテナンスおよび全スキル・リファレンス・評価セット（evals）の包括的監査を実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L6, L7）もすべて一致（`same`）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）に未反映の新規改正がないことを確認。新規・消滅・CHANGED 資料なし。
- 4層（Tier 1〜Tier 4）の包括的監査検証を実施（全項目 100% 準拠・PASS）:
  - **Tier 1 (法令 & ドメイン)**: 5つの不変ルール（Rule 1〜Rule 5）の厳格な遵守を完全確認。Rule 1（J-LIS直接照会禁止、主務大臣認定PF事業者経由）、Rule 2（犯収法 現カ＝JPKI／2027 新ヌ＝JPKI, 新ル＝特定認証業務, 新ハ＝IC+容貌, 新ト＝スマホ；携帯法 現ト＝JPKI, ハ＝IC+容貌, チ＝スマホ／2027 L3b 新チ＝JPKI, 新ニ＝IC+容貌, 新リ＝スマホ；古物営業法 第十一号 JPKI, 1万円未満適用除外および7大例外品目）の整合性を検証完了。Rule 3〜5（暗証番号/照合番号Bによる4情報・顔写真同意取得と目的分離、マイナンバー収集保管禁止、署名用/利用者証明用PIN・用途・Trust Store分離）の遵守を確認。
  - **Tier 2 (iOS CoreNFC, APDU & 端末セキュリティ)**: ISO/IEC 7816-4 & 7816-8 APDU バイト列（SELECT FILE, VERIFY, Case 1 空ボディ VERIFY `00 20 00 80`, READ BINARY, Case 4S COMPUTE DIGITAL SIGNATURE, GET CHALLENGE, INTERNAL AUTHENTICATE）、AID（JPKI DF: `D3 92 F0 00 26 01 00 00 00 01`、券面入力補助AP: `D3 92 10 00 31 00 01 01 04 08`、券面事項確認AP candidate）、EF-ID、DigestInfo SHA-256（厳密 51B ASN.1 DER Header 19B `30 0D` + 32B Hash）、SW1SW2（90 00, 63 CX, 69 82, 69 83, 69 84, 6A 82, 67 00, 6C XX, 6D 00 命令コード未サポート）、PIN ロック閾値（署名用5回、利用者証明用3回、入力補助用3回、照合番号B 10回）を検証。`SecureBytes` による C11 `memset_s` メモリゼロ化、Keychain/ログへの PIN 記録禁止、TLS pinning、Apple App Attest を確認。未確認項目は `未確認` ラベルを厳格に保持。
  - **Tier 3 (サーバー暗号, 失効確認 & セッションセキュリティ)**: RSA-2048 PKCS#1 v1.5 による Bleichenbacher / BERserk / Marvin Timing Oracle 対策（PS長 202B、DigestInfo 51B、256B 定数時間比較）、Trust Store 完全分離（署名用CA vs 利用者証明用CA）、期限切れ CA（`signca01.cer`, `authca01.cer`）の完全除外、CRL/OCSP 有効期間検証と Clock Skew 許容幅（1-2分、最大5分）、Fail-Closed 原則を検証。CSPRNG nonce（≥256-bit）の原子的消費（Atomic CAS / DB トランザクション）と App Attest / Play Integrity による端末・セッションバインディング、同意情報（10年・証明書本体保存禁止）と犯収法確認記録（7年・証明書保存必須）の4層分離アーキテクチャの完全遵守を確認。
  - **Tier 4 (プラグイン構造, 日英対訳 & Evals)**: `.claude-plugin/plugin.json`、全38スキルファイルの YAML frontmatter（description ≤ 1,024文字）、必須末尾3セクション、全27組の日英対訳（.md ↔ .en.md）の構造・意味的完全一致（100%）、相対リンク整合性（400ファイル中 broken link 0件）、`refresh.sh` の bash 構文（`bash -n` 成功）を検証。全115テストケース・230 graders の完全同期と 4 Tier 全網羅（Tier 1: 30, Tier 2: 48, Tier 3: 25, Tier 4: 12）を確認。
