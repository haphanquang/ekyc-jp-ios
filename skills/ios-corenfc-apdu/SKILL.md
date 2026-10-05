---
name: ios-corenfc-apdu
description: iOS の CoreNFC でマイナンバーカードを読み取る際に使用。NFCTagReaderSession の生成、NFCISO7816Tag への connect、APDU 送信（NFCISO7816APDU / sendCommand）、entitlement 設定（readersession.formats = TAG）、Info.plist の com.apple.developer.nfc.readersession.iso7816.select-identifiers（SELECT する AID の列挙）と NFCReaderUsageDescription、Type-B カードのポーリング、SELECT / READ BINARY と 256 バイト超の分割読み取りを扱うときに使用。JPKI 固有の VERIFY PIN / 署名生成は対象外（jpki-ap-shomei / jpki-ap-riyousha 参照）。
---

# iOS CoreNFC で APDU を送る（トランスポート層）

マイナンバーカードの IC チップと APDU で対話するための **Xcode プロジェクト設定** と **CoreNFC セッションの組み立て方** をまとめた手順リファレンス。ここで扱うのは汎用のトランスポート層（セッション確立・タグ接続・APDU 送受信・SELECT / READ BINARY）まで。各 AP の AID・EF 識別子・暗証番号・署名生成の APDU は含めない（`mynumber-card-ic` / `references/apdu-cheatsheet.md` / 各 AP スキルを参照）。

## このスキルを使う場面

- iOS アプリで CoreNFC を使ってマイナンバーカードを読む実装を始めるとき
- `NFCTagReaderSession` / `NFCISO7816Tag` / `NFCISO7816APDU` / `sendCommand` の使い方と戻り値を確認するとき
- NFC の entitlement・capability・`Info.plist`・provisioning profile を設定するとき
- SELECT FILE や READ BINARY の APDU を組み立て、256 バイトを超える EF をループで読むとき
- セッションが即座に invalidate する／タグが `didDetect` に来ない等の初期設定不備を切り分けるとき

JPKI の PIN 照合・電子署名生成の手順が必要なら `jpki-ap-shomei` / `jpki-ap-riyousha`、券面系は `kenmen-nyuryoku-hojo-ap` / `kenmen-jikou-kakunin-ap`、エラーの UX 文言は `ios-nfc-ux-errors`、鍵・PIN の取り扱いは `ios-security` を参照。

## プロジェクト設定

- [ ] **capability を追加する** — Xcode の Signing & Capabilities で「Near Field Communication Tag Reading」を追加する。これで `com.apple.developer.nfc.readersession.formats` に `TAG` フォーマットが入る。Apple Developer ポータルの App ID でも「NFC Tag Reading」を有効化し、その App ID に紐づく provisioning profile を使う（profile に NFC が無いと実機ビルドが失敗する）。
- [ ] **SELECT する AID を `Info.plist` に列挙する** — `Info.plist` の `com.apple.developer.nfc.readersession.iso7816.select-identifiers`（文字列配列、iOS 13.0+）に、アプリが SELECT FILE（DF 名）で選択する AP の AID を 16 進文字列で列挙する。ここに無い AID は OS がフィルタし、`sendCommand` の SELECT が通らない／タグが `didDetect` に渡らないことがある。マイナンバーカード各 AP の AID 実値は `references/apdu-cheatsheet.md` を参照（本プラグイン時点で JPKI-AP 以外は `未確認` または 1 ソースのみ。確定してから列挙する）。アプリが SELECT する AID の入手（AID 開示申請）については `platform-jigyousha` を参照。
- [ ] **`Info.plist` に `NFCReaderUsageDescription` を設定する** — NFC ハードウェアを使う理由を説明する非空の文字列を入れる。未設定・空文字だとセッション生成直後に `tagReaderSession(_:didInvalidateWithError:)` で失敗する。
- [ ] **実機で確認する（Simulator 不可）** — CoreNFC は NFC 対応 iPhone の実機でのみ動作する。Simulator ではビルドできても読み取りは動かない。マイナンバーカードは ISO/IEC 14443 **Type-B**。ポーリングは `.iso14443` を指定する（Type A / B とも `.iso14443` に含まれる）。テストには実物のカードが要る。

## セッションの実装

```swift
import CoreNFC

final class CardReader: NSObject, NFCTagReaderSessionDelegate {
    private var session: NFCTagReaderSession?

    func begin() {
        guard NFCTagReaderSession.readingAvailable else { return }   // 非対応機種・Simulator は false
        // convenience init?(pollingOption:delegate:queue:) — queue: nil で専用ディスパッチキュー
        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self, queue: nil)
        session?.alertMessage = "マイナンバーカードを iPhone の上部にあてて、動かさずに持ってください"
        session?.begin()
    }

    // セッションが有効化された（ここでスキャンシートが表示される）
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {}

    // セッション終了（ユーザーキャンセル / タイムアウト / エラー / invalidate 呼び出し）
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        self.session = nil
        // error を ios-nfc-ux-errors のマッピングで日本語表示。UI 更新は main へ dispatch する
    }

    // タグ検出。複数来ることがあるので ISO 7816 のタグを 1 枚だけ選ぶ
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let firstTag = tags.first, case let .iso7816(iso7816Tag) = firstTag else {
            session.invalidate(errorMessage: "対応していないカードです")
            return
        }
        Task {
            do {
                try await session.connect(to: firstTag)         // func connect(to:) async throws
                try await self.readCard(tag: iso7816Tag, session: session)
                session.alertMessage = "読み取りが完了しました"
                session.invalidate()                            // 成功時も必ず閉じる
            } catch {
                session.invalidate(errorMessage: "読み取りに失敗しました。もう一度お試しください")
            }
        }
    }
}
```

- デリゲートのコールバックは `queue:` に渡したキュー（`nil` なら CoreNFC の専用キュー）で呼ばれる。UI 更新は `DispatchQueue.main` へ回す。
- 読み取り中にカードが離れると次の `sendCommand` が throw する。原則セッション全体をやり直す（`session.restartPolling()` で再ポーリングもできる）。
- 1 セッション中に複数の APDU を送れる。`connect` は 1 回、そのあと `sendCommand` を必要な回数呼ぶ。
- **1 セッションはアクティブ化から約 60 秒でシステムが自動 invalidate する**（`didInvalidateWithError` に `NFCReaderError.readerSessionInvalidationErrorSessionTimeout`）。署名フロー（証明書の分割 READ ＋ VERIFY ＋ 署名生成）はこの中で完結させる。**セッション中にサーバー往復をしない** — 署名対象データ（to-be-signed）は `session.begin()` の前にサーバーから取得し、本文の表示とハッシュ計算もセッション前に済ませておき（`jpki-ap-shomei`）、署名値・証明書のサーバー送信はセッションを閉じた後に行う。暗証番号の入力もセッション開始前に済ませる（`ios-nfc-ux-errors`）。

## APDU の送受信

APDU（ISO/IEC 7816-4）の構造は `CLA INS P1 P2 [Lc Data] [Le]`。`NFCISO7816APDU` はこの各フィールドを表す。

```swift
extension CardReader {
    // (A) フィールド指定で作る（Lc / Le はフレームワークが付与）
    //     init(instructionClass:instructionCode:p1Parameter:p2Parameter:data:expectedResponseLength:)
    func readBinaryAPDU(offset: Int, expectedLen: Int) -> NFCISO7816APDU {
        NFCISO7816APDU(instructionClass: 0x00,
                       instructionCode: 0xB0,                        // READ BINARY
                       p1Parameter: UInt8((offset >> 8) & 0xFF),     // offset 上位
                       p2Parameter: UInt8(offset & 0xFF),            // offset 下位
                       data: Data(),
                       expectedResponseLength: expectedLen)          // 負値なら Le フィールドを送らない
    }

    // (B) 生バイト列から作る（Lc は自分で含める）— init?(data:)
    func rawAPDU(_ bytes: [UInt8]) -> NFCISO7816APDU {
        NFCISO7816APDU(data: Data(bytes))!
    }

    // 送信。async 版は戻り値の型でオーバーロードが決まる
    func send(_ apdu: NFCISO7816APDU, to tag: NFCISO7816Tag) async throws -> (Data, UInt8, UInt8) {
        // func sendCommand(apdu:) async throws -> (Data, UInt8, UInt8)
        //   data = 応答データ本体、sw1 sw2 = ステータスワード
        // 別オーバーロード: async throws -> NFCISO7816ResponseAPDU
        //   （.payload / .statusWord1 / .statusWord2）
        // completionHandler 版: (Data, UInt8, UInt8, Error?) -> Void
        let (data, sw1, sw2) = try await tag.sendCommand(apdu: apdu)
        return (data, sw1, sw2)
    }
}
```

- `sw1 == 0x90 && sw2 == 0x00` が正常終了。それ以外の SW1SW2 の意味は `references/apdu-cheatsheet.md` と `pin-lock-handling` を参照（`63 CX` = 残り試行回数、`69 83` = ロック、`6A 82` = ファイル / AP なし 等。いずれも ISO/IEC 7816-4 の標準値で、マイナンバーカード固有の挙動は要検証）。
- `NFCISO7816Tag` のプロパティ（`initialSelectedAID`、`identifier`、`historicalBytes`、`applicationData`）でタグ情報を取得できる。

## SELECT と READ BINARY

APDU のバイト列は `references/apdu-cheatsheet.md` に記録済みの形を使う（推測値をコピーしない。`未確認` の項目は実装前に検証すること）。

| 操作 | CLA INS P1 P2 | データ | 備考 |
|---|---|---|---|
| SELECT（DF 名 / AID） | `00 A4 04 0C` | AID | AP を選択。P2=`0C` は応答データを返さない指定 |
| SELECT（EF 識別子） | `00 A4 02 0C` | EF-ID（2 バイト） | AP を SELECT した後、AP 内の EF を選択。識別子は AP ごとに異なり大半が `未確認` |
| READ BINARY | `00 B0` + offset 上位 + offset 下位 | ― | 選択中の EF を offset から読む |

```swift
// 読み取り・署名で投げるエラー。SW はそのまま持たせ、解釈は ios-nfc-ux-errors / pin-lock-handling で行う
enum ReaderError: Error {
    case selectFailed(UInt8, UInt8)
    case readFailed(offset: Int, sw1: UInt8, sw2: UInt8)
    case signFailed(UInt8, UInt8)
    case malformedTLV
    case truncated(expected: Int, got: Int)
    case offsetOutOfRange(Int)
    case invalidInput
}

extension CardReader {
    // SELECT by AID: 生バイト列は 00 A4 04 0C <Lc> <AID...>
    func selectAP(aid: [UInt8], tag: NFCISO7816Tag) async throws {
        let apdu = rawAPDU([0x00, 0xA4, 0x04, 0x0C, UInt8(aid.count)] + aid)
        let (_, sw1, sw2) = try await send(apdu, to: tag)
        guard sw1 == 0x90, sw2 == 0x00 else { throw ReaderError.selectFailed(sw1, sw2) }
    }

    // SELECT by EF id: 00 A4 02 0C 02 <ef-hi> <ef-lo>
    func selectEF(efID: [UInt8], tag: NFCISO7816Tag) async throws {
        let apdu = rawAPDU([0x00, 0xA4, 0x02, 0x0C, 0x02] + efID)
        let (_, sw1, sw2) = try await send(apdu, to: tag)
        guard sw1 == 0x90, sw2 == 0x00 else { throw ReaderError.selectFailed(sw1, sw2) }
    }

    // READ BINARY を 1 回送る。90 00 以外は必ず throw する（途中までのデータを黙って返さない）
    func readBinary(offset: Int, length: Int, tag: NFCISO7816Tag) async throws -> Data {
        // P1 の最上位ビットが 1 だと「短縮 EF 識別子」指定の意味になるため、offset は 15 bit まで
        guard (0...0x7FFF).contains(offset) else { throw ReaderError.offsetOutOfRange(offset) }
        var (data, sw1, sw2) = try await send(readBinaryAPDU(offset: offset, expectedLen: length), to: tag)
        if sw1 == 0x6C {   // Le 誤り: カードが示した長さで 1 回だけ再送する（ISO/IEC 7816-4）
            let le = sw2 == 0 ? 256 : Int(sw2)
            (data, sw1, sw2) = try await send(readBinaryAPDU(offset: offset, expectedLen: le), to: tag)
        }
        switch (sw1, sw2) {
        case (0x90, 0x00): return data
        case (0x62, 0x82): return data   // 要求長より手前でファイル終端。返ったデータ自体は有効
        default: throw ReaderError.readFailed(offset: offset, sw1: sw1, sw2: sw2)
        }
    }

    // 選択中の EF の先頭にある TLV（電子証明書の DER など）1 個を、ヘッダが示す長さどおりに読む。
    // EF の残り（パディング）は読まない。どこかで 90 00 以外が返れば throw する
    func readSelectedTLV(tag: NFCISO7816Tag, chunk: Int = 256) async throws -> Data {
        let head = try await readBinary(offset: 0, length: 8, tag: tag)   // タグ＋長さフィールドに十分
        let total = try Self.tlvTotalLength(head)                         // ヘッダ込みの全長
        var result = Data(head.prefix(total))
        while result.count < total {
            let want = min(chunk, total - result.count)
            let part = try await readBinary(offset: result.count, length: want, tag: tag)
            guard !part.isEmpty else { throw ReaderError.truncated(expected: total, got: result.count) }
            result.append(part.prefix(want))
        }
        return result
    }

    // BER-TLV ヘッダ（タグ 1 バイト以上＋長さ 1〜4 バイト）から、ヘッダ込みの全長を求める
    static func tlvTotalLength(_ head: Data) throws -> Int {
        let b = [UInt8](head)
        guard !b.isEmpty else { throw ReaderError.malformedTLV }
        var i = 1
        if b[0] & 0x1F == 0x1F {                           // 複数バイトのタグ（例: FF 20）
            while i < b.count, b[i] & 0x80 != 0 { i += 1 }
            i += 1
        }
        guard i < b.count else { throw ReaderError.malformedTLV }
        let first = b[i]
        if first < 0x80 { return i + 1 + Int(first) }        // 短形式
        let n = Int(first & 0x7F)                           // 長形式: 後続 n バイトが長さ
        guard (1...3).contains(n), i + n < b.count else { throw ReaderError.malformedTLV }
        let len = b[(i + 1)...(i + n)].reduce(0) { $0 << 8 | Int($1) }
        return i + 1 + n + len
    }
}
```

- 1 回の READ BINARY で読めるのは短 Le で最大 256 バイト。大きい EF（電子証明書など）は **先頭の TLV / ASN.1 ヘッダから全長を求め、その長さちょうどまで** offset を進めて読む（`readSelectedTLV`）。「返りが要求長より短ければ終わり」で止めると、EF 後半のパディングまで読んでしまう。
- **`90 00` 以外で黙ってループを抜けない。** `69 82`（セキュリティ状態不満足）等で抜けると、途中で切れた証明書を正常値として返してしまう。`62 82`（ファイル終端）は返ったデータを使い、`6C xx` は示された Le で 1 回だけ再送し、それ以外は throw する。マイナンバーカードが実際に返す終了時の SW・EF ごとの最大長は `未確認`（下記参照）。
- 先頭に TLV が無い EF（例: 一部のカードで `FF 20` の前に 2 バイト付く券面入力補助AP の基本4情報）は `readSelectedTLV` を使わず、各 AP のスキルの指示に従う。
- 上記の `readBinary` / `readSelectedTLV` / `tlvTotalLength` は、モックのカードで「パディング付き EF・`62 82`・`6C xx`・途中の `69 82`・複数バイトタグ `FF 20`」を Swift 6 言語モードで検証済み（2026-09-25）。実カードでの挙動は別途確認する。
- SELECT の P1P2（`00 A4 04 0C` / `00 A4 02 0C`）が全 AP で共通かは `apdu-cheatsheet.md` の確度表に従う。
- **JPKI 固有の APDU（VERIFY による暗証番号照合、COMPUTE DIGITAL SIGNATURE による署名生成）は本スキルの対象外。** バイト列は `apdu-cheatsheet.md`、手順は署名用が `jpki-ap-shomei`、利用者証明用が `jpki-ap-riyousha` を参照。本スキルは汎用のトランスポート層だけを扱う。

## よくある失敗

- **Simulator で試す** — NFC は実機のみ。`NFCTagReaderSession.readingAvailable` が `false` を返す。
- **AID を `.entitlements` に書く／`Info.plist` に列挙し忘れる** — `select-identifiers` は `Info.plist` のキー（`.entitlements` に入れるのは `readersession.formats` だけ）。`Info.plist` の `select-identifiers` に無い AID を SELECT しようとすると失敗する／タグが `didDetect` に来ない。
- **provisioning profile に NFC が無い** — App ID で NFC Tag Reading を有効化していないと実機ビルド／実行ができない。
- **`NFCReaderUsageDescription` 未設定** — セッション生成直後に `didInvalidateWithError` で即終了する。
- **`pollingOption` の指定ミス** — `.iso14443` 以外だと Type-B のマイナンバーカードが検出されない。
- **256 バイト超を 1 回で読めると思い込む** — 途中で切れる。offset を進めてループする。
- **エラー SW でループを `break` して部分データを返す／EF 末尾のパディングまで読む** — 証明書が壊れる。`readSelectedTLV` のように全長を求め、`90 00` 以外は throw する。
- **`invalidate()` を呼ばない／セッションを多重生成する** — 成功時も必ず閉じる。同時に複数セッションは持てない。
- **セッション中にサーバー往復を挟む** — 約 60 秒でシステムに切られる（`readerSessionInvalidationErrorSessionTimeout`）。ハッシュ取得・署名送信はセッション外で行う。
- **コールバックのスレッドを無視して UI 更新** — デリゲートは専用キューで呼ばれる。`DispatchQueue.main` へ回す。
- **`didDetect` で先頭タグを無条件に使う** — `case .iso7816` で ISO 7816 タグを選び、違えば `invalidate(errorMessage:)`。
- **カードが離れてもリトライしない／リトライしすぎる** — `sendCommand` の throw はセッションをやり直す。PIN 照合を伴う処理は自動リトライしない（`pin-lock-handling`）。

## 出典

- <https://developer.apple.com/documentation/corenfc/nfctagreadersession>（`init(pollingOption:delegate:queue:)`、`PollingOption`（`.iso14443` / `.iso15693` / `.iso18092`）、`connect(to:) async throws`、`invalidate()` / `invalidate(errorMessage:)`、`restartPolling()`、`readingAvailable`、必要な entitlement と `NFCReaderUsageDescription`。取得日 2026-09-08）
- <https://developer.apple.com/documentation/corenfc/nfciso7816tag>（`sendCommand(apdu:)` の各オーバーロードと戻り値 `(Data, UInt8, UInt8)` / `NFCISO7816ResponseAPDU`（`payload` / `statusWord1` / `statusWord2`）、`initialSelectedAID` ほかのプロパティ、`NFCTag` の `case .iso7816(any NFCISO7816Tag)`。取得日 2026-09-08）
- <https://developer.apple.com/documentation/corenfc/nfciso7816apdu>（`init(instructionClass:instructionCode:p1Parameter:p2Parameter:data:expectedResponseLength:)`、`init?(data:)`、`expectedResponseLength` が負値のとき Le フィールドを送らない。取得日 2026-09-08）
- <https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.nfc.readersession.iso7816.select-identifiers>（アプリが SELECT する AID の文字列配列。iOS 13.0+。ドキュメント上は Entitlements 配下にあるが、`NFCISO7816Tag` のページは「information property list key」と記載しており、実装では `Info.plist` に置く（TRETJapanNFCReader の README も同じ）。取得日 2026-09-08、再確認 2026-09-25）
- <https://zenn.dev/trustdock/articles/66a228895294bc>（TrustDock「公的個人認証（JPKI）入門」— マイナンバーカードが NFC Type-B、通信は ISO/IEC 7816-4 の APDU。iOS 実装コードは Vol.1 には無いが前提として確認。取得日 2026-09-08）
- `references/apdu-cheatsheet.md`（SELECT / READ BINARY のバイト列 `00 A4 04 0C` / `00 A4 02 0C` / `00 B0`、AID、SW1SW2 と各値の確度）

## 最終確認日: 2026-09-11

## 未確認事項

- `Info.plist` の `select-identifiers` に列挙すべきマイナンバーカード各 AP の AID 文字列。JPKI-AP 以外は `references/apdu-cheatsheet.md` でも `未確認` または 1 ソースのみ。実装前に検証すること。
- READ BINARY で 256 バイト超を読む際のマイナンバーカードの正確な終了条件（Le=0 で最大長要求ができるか、`61 xx` / `6C xx` を返すか、EF ごとの最大読み取り長）。上記コードは TLV ヘッダの全長で終了し、`62 82` / `6C xx` を ISO/IEC 7816-4 どおりに扱うが、実カードでの挙動は要検証。
- SELECT（EF 識別子）の P1P2 `00 A4 02 0C` が全 AP で共通か。`apdu-cheatsheet.md` では JPKI-AP の例のみ。
- `.iso14443` 指定時にマイナンバーカード（ISO/IEC 14443 Type-B）が確実に `case .iso7816` として渡ってくるか。TrustDock は Type-B と明記するが、Apple ドキュメントは Type A / B の区別を明記していない。
- APDU の Extended Length（Lc / Le が 3 バイト）にマイナンバーカードが対応するか。本スキルのコードは短 Le を前提にしている。
