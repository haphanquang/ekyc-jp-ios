---
name: ios-nfc-ux-errors
description: iOS で NFC 読み取り UX とエラーメッセージ 日本語 を設計するときに使用。読み取り失敗 ハンドリング（カードが早く離れた・PIN 違い・PIN ロック・タイムアウト・マイナンバーカードでない・NFC 使用不可・セッション多重・タグ接続喪失）を NFCReaderError コードと友好的な文言へ対応づける表、iPhone アンテナ位置の案内、セッション中の alertMessage 更新、App Clip 公的個人認証（インストール不要フロー）の使いどころ、初回読み取り前のオンボーディングを扱う。PIN 残り回数・ロック解除の詳細は pin-lock-handling、セッション／APDU の仕組みは ios-corenfc-apdu。
---

# iOS NFC 読み取りの UX とエラー文言

マイナンバーカードの NFC 読み取りで発生するエラーを **利用者が次に何をすればよいか分かる日本語** に翻訳し、読み取り成功率を上げ離脱を防ぐためのリファレンス。CoreNFC のセッション確立・APDU 送受信は `ios-corenfc-apdu`、暗証番号の残り回数表示・ロック解除の案内は `pin-lock-handling` を参照。犯収法の方法名・適用時期はここで断定しない（`honnin-kakunin-houhou`）。

## このスキルを使う場面

- `didInvalidateWithError` で受け取った `Error` を利用者向けの日本語文言に変換するとき
- 読み取り失敗の原因別に「もう一度」「窓口へ」など出し分けを設計するとき
- 「iPhone のどこにカードをあてるか」「動かさないで」の案内文・図を作るとき
- 読み取り進行に合わせて `session.alertMessage` を書き換えるとき
- アプリをインストールさせずに公的個人認証を行う App Clip を検討するとき
- 初回読み取り前のオンボーディング（タップ位置・暗証番号・動かさない）を組むとき

## エラーとユーザー向け文言

`didInvalidateWithError` の `error` は `error as? NFCReaderError` でキャストし、`.code` で分岐する。`NFCReaderError.Code` の値は Apple ドキュメントで確認済み（下記出典）。**PIN 違い・PIN ロック・「マイナンバーカードでない」は CoreNFC のエラーではなく、APDU 応答 SW1SW2 や自前の判定から来る** ため、対応する `NFCReaderError` コードは無い。文言は例。プロダクトのトーンに合わせて調整する。

| 状況 | NFCReaderError 等 | ユーザー向け文言（例） |
|---|---|---|
| 読み取り中にカードが離れた／接続が切れた | `readerTransceiveErrorTagConnectionLost` | 「カードが離れました。カードを iPhone の上部にあて、読み取りが終わるまで動かさないでください」 |
| 再試行の上限超過（密着不足・手ぶれ） | `readerTransceiveErrorRetryExceeded` | 「うまく読み取れませんでした。ケースを外し、カードを動かさずにもう一度お試しください」 |
| カードから予期しない応答 | `readerTransceiveErrorTagResponseError` | 「カードを読み取れませんでした。もう一度お試しください」 |
| セッションのタイムアウト（一定時間タグ未検出） | `readerSessionInvalidationErrorSessionTimeout` | 「時間内に読み取れませんでした。もう一度お試しください」 |
| 利用者がシートを閉じた／キャンセル | `readerSessionInvalidationErrorUserCanceled` | エラー表示しない。無言で前の画面に戻す（必要なら「読み取りを中止しました」） |
| システムが一時的にビジー／別セッションが有効なまま `begin()` した | `readerSessionInvalidationErrorSystemIsBusy` | 「いま読み取りを開始できません。少し待ってからもう一度お試しください」 |
| セッションが予期せず終了 | `readerSessionInvalidationErrorSessionTerminatedUnexpectedly` | 「読み取りが中断されました。もう一度お試しください」 |
| NFC 無線が無効（機内モード等） | `readerErrorRadioDisabled` | 「NFC が使えない状態です。機内モードなどの設定を確認し、もう一度お試しください」 |
| この端末が NFC 読み取り非対応 | エラーではなく `NFCTagReaderSession.readingAvailable == false` を事前判定 | 「この iPhone は NFC 読み取りに対応していません」（読み取りボタンを出さない） |
| セキュリティ違反（entitlement 不備等） | `readerErrorSecurityViolation` | 実装・配布設定の不具合。利用者には一般的な失敗表示に留める |
| APDU パラメータ／パケット長の不正 | `readerErrorInvalidParameter` / `readerErrorInvalidParameterLength` / `readerTransceiveErrorPacketTooLong` | 実装バグ。利用者には「読み取りに失敗しました」。ログで APDU を確認する |
| かざしたのがマイナンバーカードでない／対応 AP が無い | CoreNFC エラーなし。`didDetect` で `case .iso7816` 以外、または SELECT が `6A 82` を返す。自前で `session.invalidate(errorMessage:)` | 「マイナンバーカードを読み取れませんでした。マイナンバーカードであることを確認してください」 |
| 暗証番号が違う | CoreNFC エラーなし。VERIFY 応答 `63 CX`（`X` が残り回数） | 「暗証番号が違います。残り ◯ 回入力できます」→ 詳細は `pin-lock-handling` |
| 暗証番号がロックされた | CoreNFC エラーなし。VERIFY 応答 `69 83` | 「暗証番号がロックされました。市区町村の窓口などでの手続きが必要です」→ 導線は `pin-lock-handling` |

- 成功時・失敗時とも `session.invalidate()` でセッションを閉じる。利用者に理由を見せたいときは `session.invalidate(errorMessage:)` を使うと、システムのスキャンシート上に赤字で文言が表示される。
- 上表の詳細な文言・画面遷移は自前の UI 側で出す。システムシートの文言は短く、アプリ内の結果画面で「なぜ失敗したか」「次にどうするか」を丁寧に示す（PDF 33 の「失敗の理由を具体的に提示する」）。
- デリゲートのコールバックはセッションのキューで呼ばれる。UI 更新は `DispatchQueue.main` へ回す（`ios-corenfc-apdu`）。

## アンテナ位置と持ち方

- **NFC アンテナの位置は iPhone の機種により異なる。** 確実に言えるのは「**iPhone 上部（カメラ付近〜上端）にカードの中央を合わせる**」まで。機種ごとの座標表を事実として掲載しない（下記「未確認事項」）。
- 案内の要点:
  - iPhone の**上部**にカードの**中央**をあてる（カード全体ではなく中心を意識させる）
  - **ケースを外す**（特に手帳型・金属・カードケース一体型・MagSafe アクセサリ）
  - あてたら**動かさず数秒待つ**。読み取り中は iPhone もカードも動かさない
  - IC カードを複数枚重ねない（交通系 IC などとの干渉）
  - 少し位置をずらして数秒ずつ試す。うまくいかないときは前後・左右に数ミリ動かす
- PDF 33 は Android について「機種によって読取位置が異なる中、誰でも簡単にタッチすべき位置を特定できる」IC チップ自動探索機能に言及している。iOS でも「上部」という大枠は共通だが、機種別の正確な位置は端末により異なる前提で案内する。
- 図解は「iPhone 上部にカードを重ねる」概念図に留め、特定機種の当て方を全機種の正解として描かない。

## セッション中の alertMessage

`session.alertMessage` はシステムのスキャンシートに表示される文字列で、セッション中いつでも書き換えられる。進行に合わせて更新し、利用者を誘導する。

```swift
// セッション開始時
session.alertMessage = "マイナンバーカードを iPhone の上部にあてて、動かさずに持ってください"

// タグ検出・connect 後、読み取り処理の途中で
session.alertMessage = "読み取り中です。カードを動かさないでください"

// 長い EF（証明書など）の読み取りが進んだら
session.alertMessage = "もう少しで完了します。そのまま動かさないでください"

// 成功
session.alertMessage = "読み取りが完了しました"
session.invalidate()

// 失敗（システムシートに赤字で表示される）
session.invalidate(errorMessage: "読み取りに失敗しました。ケースを外してもう一度お試しください")
```

- `alertMessage` は簡潔に。詳細な手順・原因はアプリ内の画面で示す。
- 暗証番号の入力はシステムシート上ではできない。VERIFY を伴うフローでは、セッション開始前にアプリ内で暗証番号を入力させ、セッション中は「動かさない」の案内だけに集中させる。

## App Clip の使いどころ

- **App Clip とは**、フルアプリをインストールせずに一部機能を即時に使える軽量版。Web ページや Spotlight などデジタル経路から起動する。PDF 21 は公的個人認証の App Clip 対応を挙げ、従来の「App Store を起動 → 検索 → 入手 → 起動」を「Web へアクセス → App Clip 起動」に短縮し、**インストールの手間を省いてサービス離脱を防ぐ**効果を示している。
- **向いている場面**: 初回の口座開設・ユーザー登録など、1 回だけ本人確認できればよく、アプリ常用を前提にしない導線。離脱率が高い「アプリのインストール」ステップを飛ばせる。
- **NFC / CoreNFC との関係**: Apple の「App Clip で機能しないフレームワーク一覧」に CoreNFC は含まれていない。App Clip 側でも NFC の capability / entitlement（`ios-corenfc-apdu` 参照）を設定する必要がある。ただし「App Clip 内で CoreNFC の読み取りセッションが動作する」と明記した Apple の公式記述は確認できていない（下記「未確認事項」）。実装前に検証すること。
- **制約**:
  - App Clip はバックグラウンド動作ができない。NFC の**バックグラウンドタグ読み取り**は使えず、前面のリーダーセッション（`NFCTagReaderSession` / `NFCNDEFReaderSession`）に限られる。マイナンバーカード読み取りは前面セッションなので通常は問題ない。
  - サイズ上限がある（iOS のバージョンにより 15 MB / 100 MB。詳細と条件は下記出典）。読み取り・暗証番号入力に必要な最小構成に絞る。
  - App Clip は対応する 1 つのフルアプリと組で提供し、フルアプリは App Clip と同じ機能を含む必要がある。
- フルアプリと App Clip で読み取り・エラー処理コードを共有し、UX 文言・オンボーディングも同じものを使う。

## オンボーディング

初回の読み取り前に、失敗の主因を先回りして説明する画面を 1 枚挟む（PDF 33 の「想定される失敗シーンを全て考慮した丁寧なインストラクションページ」）。

- [ ] **あてる位置** — 「iPhone の**上部**にカードの**中央**を重ねる」。図は概念図に留める（機種別座標は出さない）
- [ ] **ケースを外す** — 手帳型・金属・カード一体型ケース、MagSafe アクセサリを外す
- [ ] **動かさない** — 「あてたまま動かさず数秒待つ」。読み取り中に離すと最初からやり直しになることを伝える
- [ ] **暗証番号の準備** — どの暗証番号（桁数・種類）が必要かを明示する。種類を取り違えさせない（`pin-lock-handling`）
- [ ] **所要時間の目安** — 「10〜20 秒ほどかかります」など、待ち時間があることを事前に伝える
- [ ] **失敗しても大丈夫な範囲** — 読み取り自体の失敗は暗証番号の試行回数に影響しないこと。ただし暗証番号を間違えると残り回数が減ることは正しく伝える
- [ ] **中断・再開** — 途中でやめても最初からやり直せること
- App Clip では、この画面と読み取り画面だけで完結するよう構成する。

## 出典

`references/pdfs/` の PDF は第三者の著作物のためリポジトリに含めない。手元に無ければ `bash references/refresh.sh` で取得する（URL・SHA256 は `references/sources.md`）。

- `references/pdfs/21_guide-public-personal-authentication.pdf`（株式会社ダブルスタンダード「公的個人認証を利用した eKYC ソリューション」p6 — App Clip：「Web へアクセス → App Clip 起動 → マイナンバーカードをかざしてパスワード入力」でインストール不要、事業者は「サービス離脱防止への効果が期待できる」。取得日 2026-09-08）
- `references/pdfs/33_guide-liquid-ekyc.pdf`（Liquid「LIQUID eKYC」p16「ユーザの離脱を徹底的に防ぐ仕組み」— インストラクションとエラーハンドリング（想定される失敗シーンを考慮した説明ページ、読取時に失敗理由を具体的に提示）、IC チップ自動探索機能（Android は機種で読取位置が異なる）、高水準のリアルタイム画像品質チェック。取得日 2026-09-08）
- <https://developer.apple.com/documentation/corenfc/nfcreadererror-swift.struct>（`NFCReaderError` と `NFCReaderError.Code`。確認したコード：`readerSessionInvalidationErrorUserCanceled`（The user canceled the reader session）、`readerSessionInvalidationErrorSessionTimeout`（The reader session timed out）、`readerSessionInvalidationErrorSystemIsBusy`（failed because the system is busy）、`readerSessionInvalidationErrorSessionTerminatedUnexpectedly`、`readerTransceiveErrorTagConnectionLost`（lost the connection to the tag）、`readerTransceiveErrorRetryExceeded`（Too many retries）、`readerTransceiveErrorTagResponseError`（The tag responded with an error）、`readerTransceiveErrorPacketTooLong`、`readerTransceiveErrorTagNotConnected`、`readerErrorRadioDisabled`（The NFC wireless radio on the device is disabled）、`readerErrorSecurityViolation`、`readerErrorUnsupportedFeature`、`readerErrorInvalidParameter`、`readerErrorInvalidParameterLength`、`readerErrorParameterOutOfBound`。HTTP 200。取得日 2026-09-08）
- <https://developer.apple.com/documentation/corenfc/nfcreadersessionprotocol/alertmessage>（`alertMessage` はスキャンシートに表示され、セッション中に更新できる。HTTP 200。取得日 2026-09-08）
- <https://developer.apple.com/documentation/corenfc/nfctagreadersession>（`readingAvailable`、`invalidate()` / `invalidate(errorMessage:)`。HTTP 200。取得日 2026-09-08）
- <https://developer.apple.com/documentation/appclip/choosing-the-right-functionality-for-your-app-clip>（App Clip で「実行時に機能しないフレームワーク」一覧に CoreNFC は含まれない。App Clip はバックグラウンド動作不可。サイズ上限 iOS 15 以前 10 MB / iOS 16 以前 15 MB / iOS 17 以降 最大 100 MB（条件付き）。フルアプリと同一機能を含む単一ターゲットで提供。HTTP 200。取得日 2026-09-08）
- `ekyc-jp/skills/ios-corenfc-apdu/SKILL.md` / `ekyc-jp/skills/pin-lock-handling/SKILL.md`（セッション実装・`alertMessage` 初期値・SW1SW2 の解釈との整合）

## 最終確認日: 2026-09-08

## 未確認事項

- iPhone 各機種の NFC アンテナの正確な位置。「上部」という大枠以外は端末により異なり、機種別座標表を裏づける一次ソースは未確認。案内は「iPhone 上部にカード中央」に留める。
- `readerErrorRadioDisabled` が具体的にどの操作（機内モード、一時的なハードウェア無効化など）で発生するか。iPhone には CoreNFC 用の個別 ON/OFF 設定 UI が無く、トリガーの網羅は未確認。
- App Clip 内で `NFCTagReaderSession` による ISO7816 読み取りが実際に動作するか。Apple の「機能しないフレームワーク一覧」に CoreNFC は無いが、App Clip での CoreNFC 動作を明記した公式ドキュメントは未確認。PDF 21 はベンダーが App Clip での公的個人認証を提供していると述べるにとどまる。
- `readerSessionInvalidationErrorSystemIsBusy` が「自アプリで別セッションを閉じ忘れて `begin()` した」ケースで返るかは実挙動で要確認（同時に複数セッションは持てない、という制約自体は `ios-corenfc-apdu` に記載）。
- 上表のユーザー向け文言は例。実際の SW1SW2 とマイナンバーカード固有の挙動の対応は `references/apdu-cheatsheet.md` および `pin-lock-handling` の「未確認事項」に従う。
