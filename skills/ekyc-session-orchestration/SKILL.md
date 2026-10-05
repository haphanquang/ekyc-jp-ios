---
name: ekyc-session-orchestration
description: サーバー側で 1 回の eKYC セッションを設計・実装する際に使用。eKYCセッション設計（サーバー）、nonce・チャレンジの生成と束縛、状態遷移・ステートマシン（created → nonce_issued → card_read → signed → verifying → validity_checked → completed / rejected / expired）、session token による端末バインディング、リプレイ・中継攻撃（中継）対策、冪等性（Idempotency-Key）、画像インジェクション対策（容貌撮影時のサーバー側 liveness・真贋判定）、状態遷移ごとの監査ログを扱う。アプリ側の IC 読取・署名生成、署名検証の暗号処理、J-LIS 有効性確認の詳細は対象外（各スキルへ委譲）。
---

# サーバー側 eKYC セッション設計（nonce・ステートマシン・リプレイ／中継／インジェクション対策）

アプリ（`jpki-ap-shomei` / `jpki-ap-riyousha`）が IC チップを読み取り、サーバーが署名を検証し（`signature-verification`）、電子証明書の有効性を確認する（`jlis-yukousei-kakunin`）——この一連を **1 本のサーバー管理セッション**としてつなぎ、リプレイ・中継・画像インジェクションを防ぐための設計リファレンス。

このスキルは**オーケストレーション層**を担当する。各ステップの中身（APDU、署名アルゴリズム、証明書チェーン、PF事業者 API）は再説明せず、状態の持ち方・遷移条件・nonce の束縛・監査だけを定義する。

犯収法の方法名（号記号）と施行時期はこのスキルで断定しない。`honnin-kakunin-houhou` / `references/method-map.md` を参照。犯収法上の確認記録の保存期間（7 年）は `honnin-kakunin-houhou` の「確認記録の作成・保存」、同意情報の扱い・同意の有効期間（10 年）は `doui-jouhou-kanri` を参照。

## このスキルを使う場面

- サーバーで eKYC セッションを開始し、状態遷移を管理するエンドポイント群を設計・実装するとき
- nonce / チャレンジをどこで生成し、どのステップまで有効とし、いつ使い捨てるかを決めるとき
- session token をアプリインスタンスに束縛し、別コンテキストからの再利用を弾く設計をするとき
- リプレイ・中継（中継＝リレー）攻撃に対して、署名結果を「このセッションの nonce」に縛る仕組みを入れるとき
- 状態変更する各呼び出しに Idempotency-Key を付け、リトライで二重に前進しないようにするとき
- 容貌撮影を含むフロー（ヘ方式時）で、liveness / 真贋判定をサーバー側の責務として設計するとき
- 状態遷移ごとの監査ログに何を残すか決めるとき

アプリ側の IC 読取・署名生成は `jpki-ap-shomei` / `jpki-ap-riyousha`、署名検証は `signature-verification`、有効性確認は `jlis-yukousei-kakunin`、PF事業者 / SP事業者の役割分担は `platform-jigyousha` を参照。

## セッションの状態遷移

1 セッション ＝ 1 つの状態機械。**前方向の遷移のみ**を許し、いずれかのステップが失敗したら `rejected`、全体 TTL または nonce TTL を超えたら `expired` に落とす。`completed` / `rejected` / `expired` は終端で、そこから他状態へは戻らない。終端に達したら session token を失効させる。

| 状態 | 何が起きた | 次に許される遷移 | タイムアウト |
|---|---|---|---|
| `created` | アプリがセッション開始を要求。サーバーが session token を発行し、要求元のアプリインスタンスに束縛。まだ nonce は無い | `nonce_issued` / `expired` | 全体 TTL |
| `nonce_issued` | サーバーが CSPRNG で nonce を生成してセッションに束縛し、署名対象データ（本文 ＋ nonce の to-be-signed）を用意してアプリへ返した | `card_read` / `rejected` / `expired` | nonce TTL（短。例: 数分） |
| `card_read` | アプリが IC チップ読取と暗証番号 VERIFY を完了（ヘ方式時は容貌撮影もこの段で完了）。まだ署名は届いていない | `signed` / `rejected` / `expired` | 全体 TTL |
| `signed` | アプリが nonce 入りデータへの電子署名（＋証明書 DER、ヘ方式時は署名付き容貌画像）をサーバーへ送信した | `verifying` / `rejected` / `expired` | 全体 TTL |
| `verifying` | サーバーが署名検証・証明書チェーン・有効期限・**nonce 突合**・基本4情報突合を実行中（`signature-verification`） | `validity_checked` / `rejected` / `expired` | 処理タイムアウト＋全体 TTL |
| `validity_checked` | PF事業者 API 経由で電子証明書の有効性確認が完了し「有効」だった（`jlis-yukousei-kakunin`） | `completed` / `rejected` / `expired` | 処理タイムアウト＋全体 TTL |
| `completed` | 全ステップ成功。確認記録を確定し、session token を失効 | （終端） | — |
| `rejected` | いずれかのステップが失敗（署名不一致・nonce 不一致・失効・4情報不一致・liveness 不合格・タイムアウト等）。事由を記録し session token を失効 | （終端） | — |
| `expired` | 全体 TTL または nonce TTL を超過。事由を記録し session token を失効 | （終端） | — |

- **全体 TTL は短く保つ**（IC 読取・撮影・通信の現実的な所要時間 ＋ 余裕。長時間開いたセッションは攻撃者の作業時間になる）。具体値は運用・離脱率とのトレードオフで決め、`未確認事項`に残す。
- 状態を飛ばす遷移（`created` → `signed` 等）、後退する遷移、終端からの遷移はすべて拒否し `rejected` として監査に残す。
- `verifying` / `validity_checked` での失敗は再試行の余地があるもの（ネットワーク・5xx）と確定失敗（署名不一致・失効）を区別する。確定失敗は即 `rejected`。再試行は `jlis-yukousei-kakunin` の有界リトライ設計に従い、上限到達で `rejected`。
- **滞留セッションの回収（reaper）**: `created`〜`validity_checked` のどの状態でも、作成時刻からの全体 TTL・`nonce_issued` からの nonce TTL・各処理状態の処理タイムアウトを**バックグラウンドの定期ジョブ**でも検査し、超過したセッションを `expired`（処理中に下流が応答しない場合は `rejected`）へ落として監査エントリを残す。プロセス再起動・クラッシュ・下流の無応答で `verifying` / `validity_checked` のまま宙に浮くセッションを残さない。終端化のたびに session token を失効させる。

## nonce と端末バインディング

### nonce / チャレンジ

- **nonce はサーバーが生成する。** CSPRNG（暗号論的に安全な乱数生成器）で十分な長さ（例: 128〜256bit）を取り、`nonce_issued` の状態に入るときにそのセッション ID へ束縛する。
- **アプリは nonce を発明しない。** アプリが署名するのは、サーバーが「本文（申込内容のハッシュ等）＋ その nonce」から組み立てた署名対象データ（またはそのハッシュ）だけ（`jpki-ap-shomei` / `jpki-ap-riyousha` の前提と一致させる。生バイト列を渡すか SHA-256 ハッシュを渡すか、DigestInfo でラップするかはアプリ側スキルの `未確認事項` とすり合わせる）。
- **単回・短 TTL。** nonce は 1 セッションの 1 回の署名にだけ使える。使用済み・期限切れ・別セッション発行の nonce を含む署名は `verifying` で失敗させる。消費は確認と同じ原子的操作（条件付き UPDATE / compare-and-set）で行い、検証失敗時も消費済みのままにする（`signature-verification` 手順 4）。
- nonce をログ・URL・エラーメッセージにそのまま出さない（監査ログには識別子／ハッシュで残す）。
- **本文（署名対象）は「利用者が何に署名したか」が意味を持つ具体的な文言にする（WYSIWYS）。** 「本人確認への同意」「◯◯銀行 普通預金口座開設の申込」等、取引・同意の内容を人間可読の形で含める。裸のランダム値やセッション ID だけに署名させない。攻撃者が被害者のカードに「攻撃者のセッションの本文」を署名させても、本文が被害者の意図と食い違えば審査・監査で検知できる。**既定の受け渡しは「サーバーは本文と nonce を含む to-be-signed バイト列（正準形式）をアプリへ返し、アプリが本文を画面表示し、アプリ自身が SHA-256 を計算して署名する」**（`jpki-ap-shomei`「前提」）。サーバーは自分が保持する to-be-signed で検証するので、アプリが別の内容をハッシュしていれば検証で落ちる。ハッシュだけを渡す構成は、利用者が署名内容を確認できず、サーバーやその経路の侵害で任意の内容に署名させられるため例外扱いにする。to-be-signed の正準形式（エンコード・区切り）はサーバーとアプリで固定し、`未確認事項` のハッシュ形式とすり合わせる。署名は、この本文に対してのみ意味を持つ。

### 端末バインディング

- `created` でサーバーが **session token** を発行し、要求元のアプリインスタンス（インストール単位）に結び付ける。以後のすべての状態変更呼び出しでこの token を要求し、**発行時と異なるコンテキストからの使用（別インスタンス、想定外の経路）は拒否**して `rejected` にする。
- **端末バインディングだけでは中継（リレー）を防げない。** session token は bearer なので、転送されればどの端末からでも使える。**口座開設等の eKYC では、Apple の App Attest（`DCAppAttestService` の `attestKey(_:clientDataHash:)` / `generateAssertion(_:clientDataHash:)`）によるアプリインスタンス検証を既定にする**（DeviceCheck の `DCDevice` は用途が異なり単独では不足）。サーバーが発行した **challenge をこのセッションの nonce と同一の値にコミット**し、アプリは `clientDataHash` にそれを含めて assertion を作り、サーバーが challenge の一致・アテステーション署名（Apple ルートへの連鎖）・カウンタ単調増加を検証する。これで「正規アプリの、この端末インスタンスが、このセッションの nonce に対して」署名したことまで縛れる。非対応端末（古い OS 等）向けのフォールバックを持つ場合は、そのセッションを目視審査キューへ回すなど扱いを分ける。attestation object / authenticator data の各フィールド検証・カウンタ許容差・キー失効時の再登録・Apple ルート証明書のピン留めは Apple の一次ドキュメントで実装前に確認すること（`未確認事項`）。
- 端末バインディングは「アプリが正規」を示すだけで、「カードと PIN を持つ人間が本人」を示すものではない。後者は JPKI の署名検証と有効性確認、および（ヘ方式時は）容貌の突合で担保する。

## リプレイ・中継対策

- **nonce の単回性 ＋ 短 TTL**（上記）。同じ nonce・同じ署名値が二度出てきたら再利用として `rejected`。過去に受理した署名のハッシュを一定期間記録し、突合する。
- **署名結果を「このセッションの nonce」に束縛。** `verifying` で、署名対象データに含まれる nonce が「サーバーが当該セッションに払い出した値そのもの」であることを照合する（`signature-verification` の nonce 突合ステップ）。別セッションで正当に作られた署名をこのセッションに持ち込めない。
- **タイムスタンプ／有効期限チェック。** セッション作成時刻・nonce 発行時刻を記録し、各遷移で全体 TTL / nonce TTL を検査する。クロックはサーバー基準。
- **アプリインスタンス束縛（App Attest）を既定にする**（上記「端末バインディング」）。転送された署名 blob ＋ token を非正規アプリから持ち込む経路は、challenge ＝ nonce のアテステーション検証で塞ぐ。
- **中継（リレー）攻撃の残余リスク。** 攻撃者が**実物のカードと正しい PIN を制御**して被害者の手続きに割り込むケースは、nonce の単回性・App Attest だけでは防げない（正規アプリ・正規端末で攻撃者自身が操作している）。この残余リスクは、JPKI ＋ 容貌（ヘ方式）による顔の突合や、繰り返しの当人認証（`jpki-ap-riyousha`）、および WYSIWYS な本文（上記）で低減する設計にする。方法の選定と号記号は `honnin-kakunin-houhou` を参照（ここで再導出しない）。
- セッション token・nonce・署名対象データはすべてサーバー保持。アプリが自己申告した状態（「liveness は端末で確認済み」等）を信用して遷移しない。

## 冪等性

- **状態変更する各呼び出し（開始、署名提出、再検証トリガ等）に Idempotency-Key を要求する。** アプリがリトライ時に同じ key を送れるようにし、サーバーは key ＋ セッション ID ＋ 対象状態の組で「最初の結果」を記録する。
- **同じ key の再送は最初の結果をそのまま返す。** 2 度目の呼び出しで状態を二重に前進させない（`signed` を 2 回受けて 2 回検証しない、`completed` を 2 回確定しない）。
- 処理中に同じ key が来た場合は「処理中」を返し、並行実行しない（セッション単位のロック）。
- 確定した結果（`rejected` / `completed` / 有効性確認の判定）はリトライで別の結果に化けさせない（`jlis-yukousei-kakunin` の「結果を別の結果に化けさせない」と同じ原則）。
- PF事業者 API 呼び出しにも別途 Idempotency-Key を伝播し、二重課金・二重記録を防ぐ（`jlis-yukousei-kakunin`）。

## 画像インジェクション対策（ヘ方式時）

フローに容貌撮影を含む場合（IC チップ読取に容貌撮影を組み合わせる方法。「ヘ方式」等の号記号・適用時期は `honnin-kakunin-houhou` を参照）、**liveness / 真贋判定 / カメラインジェクション検知はサーバー側の責務**とする。

- **アプリが「本人が実際に写っている」ことを保証したという前提を置かない。** 端末アプリは改変・エミュレート・映像差し替えが可能。判定はサーバーが受け取った画像（および付随データ）に対して行う。
- LIQUID eKYC は、顔画像を用いた不正検知として次を挙げている（**LIQUID のアプローチ**として参照。一般原則の例示であり、CV の中身はここで再教育しない）:
  - **容貌真贋判定** — ディスプレイ攻撃・写真攻撃によるなりすましを検知する真贋判定。同社の顔認証向けなりすまし検知 AI「**Liquid PAD**」（`references/pdfs/33_guide-liquid-ekyc.pdf` p19）。
  - **カメラインジェクション攻撃判定** — スマホや PC のカメラ制御をハッキングし、ツールで仮想的な映像に差し替えた攻撃かどうかを判定（同 p19）。
  - **容貌パッシブ判定** — ランダムアクション（表情筋 ＋ フラッシュ）を省いても真贋を確認できる有償オプション。スコアが低い場合は目視確認へ（同 p10）。
  - 過去ユーザー同一人物判定・顔／本人特定事項の使いまわし判定・警告リスト判定（約 10,000 件の容貌データ等）との突合（同 p19）。
- **PAD（Presentation Attack Detection）の国際規格 `ISO/IEC 30107`** は実在の標準。LIQUID は「Liquid PAD」が第三者評価機関 Fime 社から `ISO/IEC 30107` の公式確認書を受領したとしている（同 p20）。自前実装・他ベンダー採用いずれでも、真贋判定の評価軸として `ISO/IEC 30107` を基準にできる。
- 設計上の扱い: 容貌撮影を含むフローでは `card_read` の完了条件に「サーバー側 liveness / 真贋判定に合格」を含め、不合格は `rejected`。スコアが閾値未満のグレーゾーンは目視審査キューへ回し、自動で `completed` にしない。判定結果（スコア、判定モデル、警告リスト該当有無）を監査ログに残す。
- 容貌画像そのものの保存可否・期間は `doui-jouhou-kanri` を参照。

## 監査

**すべての状態遷移**（成功・失敗・拒否された遷移試行を含む）を追記専用（append-only）／改ざん困難な形で記録する。

各エントリに最低限残す:

- セッション ID、遷移前状態 → 遷移後状態
- タイムスタンプ（タイムゾーン付き）
- アクター（アプリインスタンス ID / session token の識別子、サーバー処理、PF事業者応答 等）
- 事由（成功、または失敗・拒否の理由コード: `nonce_mismatch` / `nonce_expired` / `signature_invalid` / `chain_invalid` / `four_info_mismatch` / `revoked` / `expired_cert` / `liveness_failed` / `token_context_mismatch` / `ttl_exceeded` / `idempotency_replay` 等）
- nonce の識別子（生値は残さない）、Idempotency-Key
- 関連する下流結果の参照 ID: 署名検証の結果 ID（`signature-verification`）、有効性確認の参照 ID・照会日時・確認方式（`jlis-yukousei-kakunin`）、liveness / 真贋判定のスコアと判定
- ヘ方式時: 容貌の突合結果・警告リスト該当有無

- ログは後から編集・削除できない設計にする（追記のみ、ハッシュチェーン／WORM ストレージ等。具体手段は運用要件で決める）。
- 監査ログは犯収法の確認記録・確認方法の証跡につながる。**保存期間（確認記録は契約終了日等から 7 年）は `honnin-kakunin-houhou` の「確認記録の作成・保存」、方法の号記号は `honnin-kakunin-houhou` / `references/method-map.md` を参照し、このスキルで断定しない。**
- 監査ログに基本4情報の生値・暗証番号・秘密鍵・証明書 DER を残さない（突合に必要な範囲を超えて保持しない。`signature-verification` / `jlis-yukousei-kakunin` の「保存しない」項目と一致させる）。

## 出典

`references/pdfs/` の PDF は第三者の著作物のためリポジトリに含めない。手元に無ければ `bash references/refresh.sh` で取得する（URL・SHA256 は `references/sources.md`）。

- `references/pdfs/33_guide-liquid-ekyc.pdf`（p10, p19-20 — JPKI+（容貌）概要と目視確認の条件、「高度な不正検知判定機能」＝容貌真贋判定・カメラインジェクション攻撃判定・過去ユーザー同一人物判定・顔／本人特定事項の使いまわし判定・警告リスト判定、なりすまし検知 AI「Liquid PAD」、`ISO/IEC 30107` の公式確認書を Fime 社から受領）※ベンダー資料。不正検知の手法・数値は同社の説明であり公的仕様ではない
- `signature-verification`（`verifying` 段の署名検証・証明書チェーン・有効期限・nonce 突合・基本4情報突合。「暗号的に正しい」≠「有効」）
- `jlis-yukousei-kakunin`（`validity_checked` 段の PF事業者 API 経由の有効性確認、有界リトライ・冪等キー・fail closed・監査ログ項目）
- `jpki-ap-shomei` / `jpki-ap-riyousha`（アプリ側の IC 読取・署名生成の前提。「チャレンジ（nonce）はサーバーが生成する」「アプリが nonce を発行しない」）
- `platform-jigyousha`（PF事業者 / SP事業者の役割分担、有効性確認の委託境界）
- `honnin-kakunin-houhou` / `references/method-map.md`（本人確認方法の号記号・施行時期の唯一の定義元。IC読取＋容貌撮影を伴う方法（ヘ方式等）の位置づけ。犯収法の確認記録・取引記録の作成・保存（7 年）は「確認記録の作成・保存」）
- `doui-jouhou-kanri`（同意情報の管理、容貌画像の保存可否、最新4情報提供サービスの同意の有効期間（10 年）。犯収法の記録保存 7 年とは別制度）
- <https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction>（デジタル庁「公的個人認証サービス（JPKI）」§5 認証の仕組み、チャレンジレスポンス、有効性確認の方式。取得日 2026-09-08、HTTP 200）
- <https://developer.apple.com/documentation/devicecheck/dcappattestservice>（Apple「DCAppAttestService」— App Attest の `generateKey()` / `attestKey(_:clientDataHash:)` / `generateAssertion(_:clientDataHash:)`。取得日 2026-09-08、HTTP 200）
- <https://developer.apple.com/documentation/devicecheck/validating-apps-that-connect-to-your-server>（Apple「Validating apps that connect to your server」— サーバー発行 challenge の検証、assertion のカウンタ検証。取得日 2026-09-08、HTTP 200）

## 最終確認日: 2026-09-11

## 未確認事項

- **全体 TTL・nonce TTL の具体値。** IC 読取・容貌撮影・通信の現実的所要時間と離脱率のトレードオフで決める設計判断。一次的な推奨値の出典は持っていない。
- **App Attest の組み込み詳細。** クラス名（`DCAppAttestService`）と、challenge をアプリが `clientDataHash` に含めて assertion を作りサーバーが検証する流れまでは Apple ドキュメントで確認済み。attestation object / authenticator data の各フィールド検証、カウンタの許容差、キー失効時の再登録フロー、Apple のルート証明書のピン留めは Apple の一次ドキュメントで実装前に確認すること。本スキルは「challenge ＝ セッション nonce」を推奨するが、Apple 側の challenge の長さ・形式の制約に nonce が収まるかは実装時に確認する。
- **署名対象データの受け渡し形式**（サーバーが生 nonce を渡すのか SHA-256 ハッシュか、DigestInfo でのラップの要否、ハッシュ長）。`jpki-ap-shomei` / `jpki-ap-riyousha` / `signature-verification` の `未確認事項` と共通。サーバー実装をアプリ側スキルと整合させること。
- **監査ログの改ざん困難性の実装手段**（ハッシュチェーン、WORM ストレージ、外部タイムスタンプ等）。犯収法の確認記録としての保存期間（7 年）・方法の号記号は `honnin-kakunin-houhou`（「確認記録の作成・保存」）で確認する。
- **中継（リレー）攻撃の残余リスクへの具体的対策の十分性。** 実物カード ＋ 正しい PIN を握る攻撃者に対して、容貌の突合や繰り返し当人認証がどこまで有効かは運用・脅威モデル依存。一次的な評価基準は持っていない。
- **LIQUID の不正検知機能（容貌真贋判定・カメラインジェクション攻撃判定・警告リスト判定）の適用条件・精度・誤検知率。** `references/pdfs/33_guide-liquid-ekyc.pdf` はベンダー資料で、数値（警告リスト約 10,000 件等）・特許技術の内容は同社の説明。採用時は契約先ベンダーの仕様書で確認すること。
- **容貌パッシブ判定 / アクティブ判定のスコア閾値と目視審査への振り分け基準。** 同資料は「スコアが低い場合は目視確認」とのみ記載。
