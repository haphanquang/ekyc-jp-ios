---
name: sources-refresh
description: 一次資料（digital.go.jp の JPKI 関連ページ・PDF、および e-Gov 法令検索の犯収法・携帯法・古物営業法の施行規則および公的個人認証法のリビジョン）を再取得して差分を確認する際に使用。資料更新 / 出典の再取得 / JPKI資料の最新化 / digital.go.jp 差分チェック / 犯収法・携帯法の号記号の再確認 / sources.md・hourei-eKYC.md 更新。`references/refresh.sh` を実行し、新規・消滅・内容変更（CHANGED）を報告する。スクリプトは SKILL.md を書き換えない。CHANGED 資料をどのスキルへ反映するかは人が判断する。
---

# 一次資料の再取得と差分チェック（sources-refresh）

`references/refresh.sh` は一次資料を取り直し、`references/sources.md` の記録と突き合わせて
**新規・消滅・CHANGED（内容変更）・same（変化なし）** を報告するだけのツール。
どの `SKILL.md` も自動では変更しない。CHANGED があったとき、どのスキルの記述を見直すかは
このスキルの手順に沿って**人が判断する**。

## このスキルを使う場面

- 定期メンテナンス。前回の `最終確認日` からおおむね 3 ヶ月が経過したとき。
- 2026 年・2027 年の制度改正の時期に関わる質問（犯収法・携帯法の改正時期、施行スケジュール、
  経過措置など）に答える前。古い `sources.md` のまま断定しない。
- ガイドラインの版番号・プラットフォーム事業者一覧・様式が変わった可能性に気づいたとき。
- `sources.md` の URL でリンク切れ（404）を見つけたとき。

## 手順

各ステップを実行時の todo にする。

1. **`references/sources.md` を読み取る。** 既知の一次ページ 2 点、PDF 一覧（URL・取得日・SHA256・
   使用スキル）、`## 未取得` の行を把握する。
2. **一次ページ 2 点を再取得する。** 日本語版・英語版の
   `jpki-introduction` ページを取り直す（`refresh.sh` が実施）。
3. **ページから `.pdf` リンクを抽出する。** `refresh.sh` が `href="...pdf"` を集め、
   相対パスを絶対 URL へ正規化して `sources.md` の既知 URL と比較する。
4. **新規・消滅・CHANGED に分類する。**
   - 新規 = ページにあるが `sources.md` に無い URL。
   - 消滅 = `sources.md` にあるがページから消えた URL。
   - CHANGED は次のステップで判定する。
5. **既知 PDF を再ダウンロードし SHA256 を比較する。** `refresh.sh` が各 URL を取り直し、
   `sources.md` に記録した SHA256 と照合する。一致すれば `same`、不一致なら `CHANGED` と表示する。
   取得した PDF は `references/pdfs/NN_*.pdf` に保存する（第三者の著作物のためリポジトリには
   含めない。`.gitignore` 対象のローカルキャッシュ）。

   ```
   bash references/refresh.sh
   ```

6. **`sources.md` と `references/CHANGELOG-sources.md` を更新する。**
   新規 URL は行を追加、消滅 URL は `## 未取得` へ移すか削除して理由を書く。
   CHANGED は SHA256 と取得日を更新する。変更内容を日付付きで `CHANGELOG-sources.md` に記録する。
7. **CHANGED 資料の『使用スキル』列のスキルを見直す。** `sources.md` の当該行の「使用スキル」列に
   挙がっているスキルを開き、引用箇所・数値・版番号が新しい PDF と食い違っていないか確認する。
   食い違いがあれば人が判断して直す。`refresh.sh` はスキル本文を変更しない。
8. **e-Gov 法令リビジョンを突合する。** `refresh.sh` が犯収法施行規則（現行・2027-04-01 未施行版）・
   携帯法施行規則・公的個人認証法・古物営業法施行規則の**リビジョン ID** を e-Gov 法令検索 API v2 から取得し、
   `references/hourei-eKYC.md` に記録した「取得リビジョン」と比較する。`CHANGED` なら、
   e-Gov で当該リビジョンの条文（特に犯収法施行規則第6条第1項第1号の号記号、第19条、
   携帯法施行規則第3条、公的個人認証法第17条、古物営業法施行規則第15条第3項）を読み直し、`hourei-eKYC.md` の抜粋・リビジョン ID
   を更新したうえで、`references/method-map.md` と `skills/honnin-kakunin-houhou/SKILL.md` の
   号記号・施行時期を人が突合する。2027-04-01 版は施行までに再改正され得るので、制度改正の
   時期に関わる質問の前には毎回このステップを実行する。

## 結果の読み方

| 表示 | 意味 | 対応 |
|---|---|---|
| `same` | 再取得した PDF が記録と同一。 | 対応不要。 |
| `CHANGED` | PDF の内容が `sources.md` の記録と異なる。新しいファイルはローカルの `pdfs/` に保存済み。 | 手順 6・7 を実施。 |
| `-- 新規 --` に URL | ページに新しい PDF が追加された。 | `sources.md` に行を追加し、必要なら plugin に取り込む。 |
| `-- 消滅 --` に URL | ページから PDF が消えた（差し替え・廃止）。 | 後継資料を探し、`sources.md` を更新。CHANGELOG に記録。 |
| `?? ファイル未対応` | URL に対応するローカル `pdfs/` ファイルが無い（例: `## 未取得` の J-LIS 資料）。 | 想定内。手動取得が必要なものは `## 未取得` のまま。 |
| `!! 取得失敗（HTTP エラー等）` | 既知 URL が 4xx/5xx を返した（リンク切れ・移動）。ローカル PDF は**変更していない**。 | URL を手動で確認し、後継 URL を探して `sources.md` を更新。CHANGELOG に記録。 |
| `!! PDF ではない/小さすぎる応答` | 応答が PDF ヘッダを持たない、または 1KB 未満（エラーページ等）。ローカル PDF は**変更していない**。 | 同上。誤った上書きを避けるためスクリプトは `cp` しない。 |
| `same <法令名> (<リビジョン ID>)` | e-Gov 法令のリビジョンが `hourei-eKYC.md` の記録と同一。 | 対応不要。 |
| `CHANGED <法令名>` ＋ `記録 = … / 現在 = …` | e-Gov 法令が改正され、リビジョン ID が変わった。 | 手順 8 を実施（`hourei-eKYC.md` の抜粋・ID を更新 → `method-map.md`・`honnin-kakunin-houhou` の号記号を人が突合）。 |
| `?? 記録リビジョンが見つからない` | `hourei-eKYC.md` の該当節（`## 1.`〜`## 5.`）に「取得リビジョン」行が無い。節番号を変えたときに起きる。 | `hourei-eKYC.md` の節番号と `refresh.sh` 末尾の `check_law` の第 4 引数を揃える。 |
| `?? リビジョン ID を抽出できず` | e-Gov API の応答からリビジョン ID を取り出せない。 | API v2 の応答形式が変わっていないか手動で確認する。 |

## CHANGED のあとにやること

- [ ] `sources.md` の当該行の SHA256 を新しい値へ更新する。
- [ ] `sources.md` の当該行の取得日を実行日へ更新する。
- [ ] `CHANGELOG-sources.md` に日付・資料名・変更の要点を記入する。
- [ ] 当該行の「使用スキル」に挙がる各スキルの `## 最終確認日` と `## 未確認事項` を見直す。
      引用が古くなっていれば修正し、確認しきれない点は `未確認` として残す。
- [ ] **スキル本文は自動では直さない。** 何をどう直すかは、新旧 PDF を読み比べて人が判断する。
      `refresh.sh` は差分を示すだけで、判断も編集も行わない。

## 出典

- `references/sources.md` — 一次資料の一覧（URL・取得日・SHA256・使用スキル）。
- `references/hourei-eKYC.md` — 犯収法・携帯法・公的個人認証法・古物営業法の一次条文抜粋と e-Gov リビジョン ID。
- `references/refresh.sh` — 再取得と差分チェックのスクリプト（PDF ＋ e-Gov 法令リビジョン）。
- `references/CHANGELOG-sources.md` — 変更履歴。
- 公的個人認証サービス（民間事業者向け）: https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction （2026-09-08 確認）
- e-Gov 法令検索 API v2: https://laws.e-gov.go.jp/api/2/law_data/ （リビジョン ID の突合先。2026-09-10 確認）

## 最終確認日: 2026-09-11

## 未確認事項

なし
