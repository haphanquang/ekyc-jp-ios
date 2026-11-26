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

## 2026-11-23
- 午前4:00 定期メンテナンスおよび4つの独立監査サブエージェント（Tier 1〜Tier 4）による全スキル・リファレンス・評価セットのクロスチェック・アップグレードを実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L6, L7）もすべて一致（`same`）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）以降の未反映改正がないことを確認。新規・消滅・CHANGED 資料なし。
- 独立監査（Tier 1〜Tier 4）で検出された確定課題（e-Gov API・PDF 05・RFC 5280/6960 一次確認に基づく修正）を全日英ペアに反映:
  - **Tier 1 (法令 & ドメイン)**: `references/hourei-eKYC.md` §2 および `references/method-map.md` に犯収法施行規則 2027-04-01 版第19条第1項第2号（イ＝新ハ、ホ＝新ト、ヘ＝リ〜ル・電磁的記録限定）の e-Gov 一次確認抜粋を補完し、携帯法 2027 年版「新ホ ← 現行ニ」の表記載を修正。`skills/kihon-4-jouhou-doui/` の 2026-05-26 振り仮名施行表現・部分同意の不利益禁止表現・PDF 05 FAQ A.10（国外転出時の翌日7時 CRL 記載）を精査更新。`skills/honnin-kakunin-houhou/`・`references/method-map.md` の Android版提供予定表現と確認日注記、`skills/sources-refresh/` の携帯法2027年対象表記、`skills/platform-jigyousha/` の CRL 時刻・英語表記を整合化。
  - **Tier 2 (iOS CoreNFC, APDU & 端末セキュリティ)**: `skills/kenmen-nyuryoku-hojo-ap/` の本文と Swift サンプル（`.shogoB` 14桁解錠が未確認であること）の内部矛盾と typo を解消。`skills/kenmen-nyuryoku-hojo-ap/` と `skills/kenmen-jikou-kakunin-ap/` に `SecureBytes` (`memset_s`) の CoW 回避注記および `kind` ガードを追加。`skills/pin-lock-handling/` の空ボディ VERIFY（Case 1 4B 表記・実カード対応可否の未確認事項記載）、`skills/ios-corenfc-apdu/`・`jpki-ap-shomei`・`jpki-ap-riyousha` の `rawAPDU` throwing 化と AID 長ガード（`!` 強制アンラップ排除）、`skills/ios-nfc-ux-errors/` のデバッグログ制限（生 APDU 出力禁止との整合）、`skills/ios-security/` の `SecureBytes.init(count:)` 負値ガード・`keyId` の `...ThisDeviceOnly` 保護・`UIScreen.isCaptured` fail-closed（`?? true`）・App Attest チェック項目を強化。
  - **Tier 3 (サーバー暗号, 失効確認 & セッションセキュリティ)**: `skills/signature-verification/` で利用者証明用証明書の `certificatePolicies` OID を署名用から分離（未確認事項にも追記）し、手順 3 で弱い証明書署名ハッシュ（SHA-1 等）を禁止、`SKILL.md` L117 の `authca01.cer` 表記を「期限切れ」に統一。`skills/jpki-ap-riyousha/` の nonce 消費参照先を「手順 4」から「手順 1」へ修正。`skills/jlis-yukousei-kakunin/` に OCSP `SingleResponse.certID` 一致検証・`nextUpdate` 省略時の鮮度制限・手順 4（有効期限検証）を大前提として追記（PDF 05 APPENDIX ①b/②b）し、`rejected` 遷移を `ekyc-session-orchestration` と統一。`skills/ekyc-session-orchestration/` のステートマシン表（`created -> rejected` / PAD 先行 `created -> card_read -> nonce_issued -> signed`）の整合性修正、クロスアーティファクト／二証明書バインディング、レート制限・同時セッション制限、`Idempotency-Key` リクエストハッシュ検証、および容貌画像保存先の委譲先修正（`doui-jouhou-kanri` → `honnin-kakunin-houhou`）を実施。`skills/doui-jouhou-kanri/` の携帯法第4条第2項の保存期間誤記（7年 → 3年）を e-Gov 一次条文に基づき是正し、同意有効期間 10 年の根拠条文（公的個人認証法施行規則第35条の2第4項）と DEK/KMS 鍵のストア間完全分離を明記。
  - **Tier 4 (プラグイン構造, 日英対訳 & Evals)**: `references/sources.md`（PDF 09 に `signature-verification`、PDF 29 に `jpki-overview` を追加、最終更新 `2026-11-23`）、`README.md` / `README.en.md`（2026-09-30 経過措置終了・携帯法 2027 年改正・`hourei-eKYC.en.md` リンク・最終レビュー日）、`evals/signature-verification/neg-03`（`step 4` → `step 1`）および英語プロンプト 19 件の `answer-is-grounded.md` 言語要件を更新。全27組の日英対訳・38ファイル frontmatter・115テストケース/230 graders・`refresh.sh` 構文を検証完了。

## 2026-11-24
- 午前4:00 定期メンテナンスおよび4つの独立監査サブエージェント（Tier 1〜Tier 4）による全スキル・リファレンス・評価セットのクロスチェック・アップグレードを実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L6, L7）もすべて一致（`same`、L3 は再確認含め一致）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）以降の未反映改正がないことを確認。新規・消滅・CHANGED 資料なし。
- 独立監査（Tier 1〜Tier 4）で検出された確定事項（PDF 05 一次確認・e-Gov API v2・RFC 5280/Swift 並行性）を全日英ペアに反映:
  - **Tier 1 (法令 & ドメイン)**: `skills/platform-jigyousha/` および `skills/jpki-overview/` に PDF 05 §4(2)ア(ｴ)・(ｵ)・§6(2)ア（公的個人認証法施行規則第29条みなし署名検証者である SP事業者の電子証明書保持禁止・発行番号取得/保持禁止、技術的基準第31条第4号・法第63条のシリアル番号制限）を追記。`skills/kihon-4-jouhou-doui/` の PDF 05 節番号誤記（`§5(5)` → `§5(3)⑤`、範囲 `44〜50ページ` → `44〜51ページ`）を一次 PDF に基づき修正。`skills/jpki-overview/` の PDF 21 説明を実態（利用プロセス・App Clip 例）に修正し、`skills/platform-jigyousha/` の §2 参照と `jpki-introduction.ja.md` §5.1.2 ※5 出典を補完。`references/sources.md`（PDF 05 に `jlis-yukousei-kakunin` を追加、L8 携帯法本法 `417AC1000000031_20260529_508AC0000000025`・L9 公的個人認証法施行規則 `415M60000008120_20260614_508M60004008011` を追加）、`references/hourei-eKYC.md`（§6・§7 条文抜粋を追加、§3 重複表現を整理）、`references/refresh.sh`（L8/L9 自動突合を追加）、`skills/honnin-kakunin-houhou/`（携帯法第4条第2項の3年保存を明記）、`references/yougoshuu.en.md`（`Confirming with J-LIS ... via an authorized Platform Operator` の語順修正）、`README.md`（2027-04-01 行の犯収法/携帯法区別明確化）および関連ファイルの最終確認日を更新。
  - **Tier 2 (iOS CoreNFC, APDU & 端末セキュリティ)**: `skills/ios-security/` の `SecureBytes.count` を `NSLock` で保護された算出プロパティへ変更して `@unchecked Sendable` 下の並行データ競合を解消し、ログ出力禁止項目およびチェックリストに電子証明書（DER：署名用・利用者証明用）を明記し、`attestKey` の初回チャレンジ表現を `ekyc-session-orchestration` と整合。`skills/ios-nfc-ux-errors/` の PIN ロック行に `69 84` / `63 C0` を追記。
  - **Tier 3 (サーバー暗号, 失効確認 & セッションセキュリティ)**: `skills/signature-verification/` に `extendedKeyUsage`（用途外 EKU 拒否とプロファイル仕様未確認事項）および `md5WithRSAEncryption` 拒否を追記し、検証手順の並びを安全実行順（`1 → 2a → 3 → 4 → 2 → 5`、番号互換維持）へ整理、2027-04-01 施行規則第19条第1項第2号ヘ・古物営業法第十一号（職業・年齢、3年帳簿保存）および PDF 09 出典を補完、`jpki-ap-riyousha` 未確認事項との整合を追記。`skills/jlis-yukousei-kakunin/` に CRL `nextUpdate` 省略時の fail-closed 基準と PDF 05（APPENDIX ①b/②b）出典を追記。`skills/doui-jouhou-kanri/` の分離設計を同意情報（10年）・犯収法（7年）・携帯法（3年）・古物営業法（3年）の4法令ストア／DEK・KMS 鍵完全分離へ拡張し、照会・開示請求で利用者証明用電子証明書を用いる場合のサーバー検証パイプライン経由を明記。
  - **Tier 4 (プラグイン構造, 日英対訳 & Evals)**: `skills/signature-verification/SKILL.md` の `description` を全トリガー語維持のまま UTF-8 バイト長 1,024 バイト以下へ調整。全27組の日英対訳・38ファイル frontmatter・115テストケース/230 graders・相対リンク・`refresh.sh` 構文を検証完了。


## 2026-11-25
- 午前4:00 定期メンテナンスおよび4つの独立監査サブエージェント（Tier 1〜Tier 4）による全スキル・リファレンス・評価セットのクロスチェック・アップグレードを実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L3b, L6〜L9）もすべて一致（`same`）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）以降の未反映改正がないことを確認。新規・消滅・CHANGED 資料なし。
- 独立監査（Tier 1〜Tier 4）で検出された確定事項を全日英ペアに反映:
  - **Tier 1 (法令 & ドメイン)**: `skills/sources-refresh/` の `description` および手順 8 に `携帯電話不正利用防止法（本法）`（第4条・L8/§6）と `公的個人認証法施行規則`（第29条・第35条の2・L9/§7）を補完し `refresh.sh` の検査対象と完全一致化。`skills/platform-jigyousha/` の PDF 05（第1.8版）§4(2)ア(ｴ)(ｵ) 引用ページを PDF ページ表記（`30〜31ページ`）から印刷ページ表記（`29〜30ページ`）へ統一（PDFKit にて実確認）。
  - **Tier 2 (iOS CoreNFC, APDU & 端末セキュリティ)**: `references/apdu-cheatsheet.md` の空ボディ VERIFY（Case 1: 4B）から ISO/IEC 7816-4 §5.1 と矛盾する `または Lc=0` 表記を削除。`skills/ios-security/` の `SecureBytes.init(copying:)` における Swift 5.8+ 非推奨 `buffer.assign(from:count:)` を `buffer.update(from:count:)` へ更新し、`DCAppAttestService.shared.isSupported` の事前確認と App Clip 鍵スコープ分離、および `UIScreen.isCaptured` 初期表示チェックと通知オブザーバ保持を追記。`skills/ios-nfc-ux-errors/` の App Clip サイズ上限要約（L89）を出典（L115：`iOS 15 以前 10 MB / iOS 16 以前 15 MB / iOS 17 以降 最大 100 MB`）と整合化。
  - **Tier 3 (サーバー暗号, 失効確認 & セッションセキュリティ)**: `skills/doui-jouhou-kanri/` の最新4情報提供サービス同意取得の根拠条文誤記（公的個人認証法第17条 → **第18条第3項および同法施行規則第35条の2**）を `hourei-eKYC.md` §7 の e-Gov 一次条文に基づき是正。`skills/ekyc-session-orchestration/` および `skills/jpki-ap-riyousha/` において、二証明書登録時の単回 nonce 消費（1 回の原子的 `signed` リクエストで両署名を提出して単回消費するか、別リクエスト時は同一 `session_id` に束縛した別々の単回 nonce を発行）とドメイン分離ペイロード（署名用 `本文 + nonce` / 利用者証明用 `nonce` チャレンジ）を明確化。
  - **Tier 4 (プラグイン構造, 日英対訳 & Evals)**: 全27組の日英対訳・38ファイル frontmatter（文字数/UTF-8バイト数 ≤ 1,024）・末尾必須セクション・相対リンク・`refresh.sh` 構文・全115テストケース/230 graders の完全同期を再検証。

## 2026-11-26
- 午前4:00 定期メンテナンスおよび4つの独立監査サブエージェント（Tier 1〜Tier 4）による全スキル・リファレンス・評価セットのクロスチェック・アップグレードを実施。
- `refresh.sh` 実行により、一次ページ 2 点、PDF 33 点の SHA-256 突合を実施、すべて一致（`same`）。法令リビジョン（L1〜L4, L3b, L6〜L9）もすべて一致（`same`）。e-Gov API にて L5（犯収法本法 `419AC0000000022`）を確認し、現行施行リビジョン（`419AC0000000022_20260812_508AC0000000064`）以降の未反映改正がないことを確認。新規・消滅・CHANGED 資料なし。
- 独立監査（Tier 1〜Tier 4）で検出された軽微な整合性・表記改善を全日英ペアに反映:
  - **Tier 1 (法令 & ドメイン)**: `references/sources.md`（および `.en.md`）の法令表（L1〜L9）の `使用スキル` 列に、実際に本文／`## 出典` で引用しているスキル（L9 の `honnin-kakunin-houhou`、および L1・L2・L4・L5・L6・L7 の二次引用スキル）を補完し最終更新日を `2026-11-26` に更新。`skills/platform-jigyousha/` の `## 出典` に `references/pdfs/10_platform-operators-4-info-list.pdf` を追記。`skills/ekyc-jp/SKILL.en.md` の `prohibited in standard eKYC`（L32/L66）を日本語版（`犯収法eKYCでは取得不可`）に合わせて `prohibited in AML (Act on Prevention of Transfer of Criminal Proceeds) eKYC` へ厳密化。
  - **Tier 2 (iOS CoreNFC, APDU & 端末セキュリティ)**: `skills/kenmen-nyuryoku-hojo-ap/`（L18）において、個人番号テキスト読出し（EF `00 01`）は同 AP 内にある点と、裏面画像・個人番号読出しの券面事項確認APおよび番号法チェックリストの参照先が `kenmen-jikou-kakunin-ap` である点を明確化し、両AP間の境界曖昧さを解消。APDU バイト列・`SecureBytes`（`memset_s`）・`未確認` ラベルの完全維持を確認。
  - **Tier 3 (サーバー暗号, 失効確認 & セッションセキュリティ)**: `skills/jlis-yukousei-kakunin/`（L43 (4)）の OCSP レスポンダ証明書 fail-closed 条件の日英表記（`失効・期限切れ・非信頼` / `revoked/expired/untrusted`）を統一。`skills/jpki-ap-riyousha/`（L137 未確認事項）の登録時同一性表現を、同スキル L103（1回の原子的リクエストでの同一 nonce、または同一 `session_id` に束縛した個別の単回 nonce）と整合化。
  - **Tier 4 (プラグイン構造, 日英対訳 & Evals)**: `claude plugin validate .` パス、全27組の日英対訳・38ファイル frontmatter（≤1,024文字・バイト）・末尾必須セクション・相対リンク（broken link 0件）・`refresh.sh` 構文・全115テストケース/230 graders の完全同期を検証。