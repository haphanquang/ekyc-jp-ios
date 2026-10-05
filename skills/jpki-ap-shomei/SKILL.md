---
name: jpki-ap-shomei
description: マイナンバーカードの署名用電子証明書 読み取りと JPKI 電子署名 生成を iOS で実装する際に使用。JPKI-AP の SELECT、署名用 暗証番号（6〜16桁 英数字）の VERIFY、COMPUTE DIGITAL SIGNATURE による署名（サーバーが組み立てた to-be-signed の本文を表示し、ハッシュはアプリが計算する＝WYSIWYS）、署名用電子証明書 EF（DER）の READ、署名と証明書のサーバー送信を扱う。カ方式 iOS実装。ロック・残回数の UX、サーバー側の署名検証・有効性確認は対象外。
---

# JPKI-AP で署名用の鍵・証明書を使う（署名生成）

マイナンバーカードの `JPKI-AP` にある **署名用の秘密鍵で電子署名を生成し、署名用電子証明書（DER）を読み出して**サーバーへ渡すまでの手順リファレンス。署名の検証と J-LIS の有効性確認はサーバー側で行う（このスキルの対象外）。

犯収法の方法名（カ方式ほか）と適用時期はここで断定しない。詳細は `honnin-kakunin-houhou` / `references/method-map.md` を参照。

## このスキルを使う場面

- iOS アプリで署名用電子証明書を読み取り、JPKI 電子署名を生成する実装を書くとき
- `COMPUTE DIGITAL SIGNATURE` の APDU（CLA INS P1 P2）と入力データ形式を確認するとき
- 署名用 暗証番号（6〜16桁 英数字）の VERIFY と、SW による残り試行回数の読み取りを実装するとき
- サーバーへ渡すもの（署名値・証明書 DER）と、サーバーが用意するもの（署名対象データ）の分担を確認するとき

ロック・残回数の UX は `pin-lock-handling`、サーバー側の署名検証は `signature-verification`、電子証明書の有効性確認は `jlis-yukousei-kakunin` を参照。CoreNFC のセッション確立・APDU 送受信は `ios-corenfc-apdu`。

## 前提

- `ios-corenfc-apdu` を完了していること（`NFCTagReaderSession` の確立、`NFCISO7816Tag` への `connect`、`sendCommand` による APDU 送受信、256 バイト超の分割 READ、`Info.plist` の `select-identifiers` への AID 列挙）。
- APDU のバイト列は `references/apdu-cheatsheet.md` に記録済みの形のみを使う。`未確認` の項目は実装前に検証する。
- **署名対象データ（to-be-signed）はサーバーが組み立てる。** サーバーが本文＋セッションごとの nonce から to-be-signed データを作る。アプリが nonce を発行しない。
- **既定: アプリは to-be-signed を受け取り、本文を表示し、ハッシュを自分で計算する（WYSIWYS）。** 署名用の鍵による電子署名は電子署名法 §3 の推定効が及びうる重い署名なので、サーバーから届いた「中身の分からないハッシュ」にそのまま署名しない。
  1. アプリは自社 eKYC セッション API（TLS、`ios-security` のピン留め方針）から、当該セッションの to-be-signed バイト列（本文と nonce を含む正準形式）を受け取る。
  2. アプリは to-be-signed から本文を取り出して画面に表示し、利用者が内容を確認してから暗証番号入力へ進む。
  3. アプリは `SHA256.hash(data: toBeSigned)`（CryptoKit）で自らハッシュを計算し、それを手順 5 の DigestInfo に入れる。
  - 当該セッション以外の経路（プッシュ通知・URL スキーム・他アプリ・WebView 等）から来たハッシュやデータには署名しない。
  - サーバーが生ハッシュしか返せない構成は例外扱いとし、その場合も本文は必ず表示する。サーバー側の組み立ては `ekyc-session-orchestration` / `signature-verification`。
- 署名アルゴリズムは RSA-2048 / PKCS#1 v1.5 / SHA-256（`未確認`：現行仕様・他ハッシュ対応は要検証。`apdu-cheatsheet.md`）。パディングはカード内部で行われる。

## 署名生成の手順

1 セッション内で下記を順に送る。各ステップの応答 SW が `90 00` でなければ中断する。

- [ ] **1. JPKI-AP を SELECT** — `00 A4 04 0C 0A D3 92 F0 00 26 01 00 00 00 01`（AID は tex2e・moritamori・kopaneet の 3 ソースで一致）。`6A 82` なら AID / `Info.plist` の `select-identifiers` を見直す。
- [ ] **2. 署名用 暗証番号の EF を SELECT** — `00 A4 02 0C 02 00 1B`（EF-ID は tex2e）。
- [ ] **3. 暗証番号を VERIFY** — `00 20 00 80` + 暗証番号の ASCII バイト列（keyref P2=`80` は 3 ソース一致）。6〜16 桁の英数字（桁数は zenn.dev/trustdock・tex2e で一致）。応答 SW を確認する:
  - `90 00`: 照合成功。
  - `63 CX`: 不一致。下位ニブル `X` が残り試行回数（ISO/IEC 7816-4 標準値。JPKI 固有の一次ソースは `未確認`）。**自動リトライしない。** 残回数の提示・ロック手前の警告・ロック時の解錠導線は `pin-lock-handling` に委譲する。
  - `69 83`: ロック済み。`pin-lock-handling` 参照。
- [ ] **4. 署名用秘密鍵の EF を SELECT** — `00 A4 02 0C 02 00 1A`（EF-ID は tex2e。MSE / Manage Security Environment は tex2e の手順には無い。`未確認`）。
- [ ] **5. COMPUTE DIGITAL SIGNATURE** — `80 2A 00 80` + アプリが to-be-signed から計算した SHA-256 ハッシュ（「前提」の 3）で作った DigestInfo（DER）。tex2e の実装例では SHA-256 の DigestInfo プレフィックス（RFC 8017 準拠）`30 31 30 0D 06 09 60 86 48 01 65 03 04 02 01 05 00 04 20` に 32 バイトのハッシュを連結し、Lc=`33`（0x33 = 51 = プレフィックス 19 + ハッシュ 32）で送る（`入力を DigestInfo とする点は tex2e 1 ソースのみ・要検証`）。応答データが RSA-2048 の署名値（256 バイト・要検証）、末尾 SW が `90 00`。

```swift
extension CardReader {
    // 手順 2〜3: 署名用 暗証番号の EF を SELECT してから VERIFY。SW を呼び出し側へ返し、
    // リトライは pin-lock-handling に委ねる（VerifyOutcome / pinBytes / interpret はそこで定義）
    func verifyShomeiPIN(_ pin: String, tag: NFCISO7816Tag) async throws -> VerifyOutcome {
        // 署名用 暗証番号は「英大文字 + 数字 6〜16 桁」。全角→半角・大文字化・形式チェックを
        // カードへ送る前に行う（形式違反は throw され、試行回数を消費しない）
        let bytes = try pinBytes(pin, kind: .shomei)
        try await selectEF(efID: [0x00, 0x1B], tag: tag)   // 手順 2: 署名用 暗証番号 EF（00 A4 02 0C 02 00 1B）
        let apdu = rawAPDU([0x00, 0x20, 0x00, 0x80, UInt8(bytes.count)] + bytes)
        let (_, sw1, sw2) = try await send(apdu, to: tag)
        return interpret(sw1: sw1, sw2: sw2)                // pin-lock-handling
    }

    // 手順 4〜5: 署名用秘密鍵の EF を SELECT してから、SHA-256 ハッシュ（32B）に
    // DigestInfo を付けて署名を計算。hash はアプリが to-be-signed から自分で計算したもの:
    //   let hash = Data(SHA256.hash(data: toBeSigned))   // import CryptoKit
    func computeSignature(sha256 hash: Data, tag: NFCISO7816Tag) async throws -> Data {
        guard hash.count == 32 else { throw ReaderError.invalidInput }   // 本番でクラッシュさせない
        try await selectEF(efID: [0x00, 0x1A], tag: tag)   // 手順 4: 署名用秘密鍵 EF（00 A4 02 0C 02 00 1A）
        // RFC 8017 (PKCS#1 v1.5) の SHA-256 DigestInfo プレフィックス。内側 SEQUENCE 長は
        // 0x0D（OID 11B + NULL 2B）。tex2e の記事が 0x0B と表記していれば誤植とみられる（未確認）
        let digestInfoPrefix: [UInt8] = [
            0x30, 0x31, 0x30, 0x0D, 0x06, 0x09, 0x60, 0x86, 0x48, 0x01,
            0x65, 0x03, 0x04, 0x02, 0x01, 0x05, 0x00, 0x04, 0x20,
        ]
        let digestInfo = digestInfoPrefix + Array(hash)     // 全長 0x33 = 51 バイト
        let apdu = rawAPDU([0x80, 0x2A, 0x00, 0x80, UInt8(digestInfo.count)] + digestInfo + [0x00])
        let (sig, sw1, sw2) = try await send(apdu, to: tag)
        guard sw1 == 0x90, sw2 == 0x00 else { throw ReaderError.signFailed(sw1, sw2) }
        return sig                                          // RSA-2048 署名値（256 バイト）
    }
}
```

## 証明書の読み出し

署名用電子証明書は DER（RSA-2048 で 1 KB 超）なので、必ず分割 READ する。

1. **署名用証明書の EF を SELECT** — `00 A4 02 0C 02 00 01`（EF-ID は tex2e）。
2. **先頭を READ BINARY** — `00 B0 00 00`。応答先頭の ASN.1 SEQUENCE タグ直後の長さフィールド（長形式）から DER 全長を求める。
3. **offset を進めて残りを READ** — `00 B0 <offset 上位> <offset 下位>` を、全長に達するまで繰り返す（`ios-corenfc-apdu` の分割読み取りを使う）。

```swift
extension CardReader {
    func readShomeiCertificate(tag: NFCISO7816Tag) async throws -> Data {
        try await selectEF(efID: [0x00, 0x01], tag: tag)    // 00 A4 02 0C 02 00 01
        let der = try await readSelectedTLV(tag: tag)        // ios-corenfc-apdu: DER ヘッダの全長どおりに分割 READ
        return der                                           // DER のまま保持しない（サーバー送信後に破棄）
    }
}
```

READ BINARY で 256 バイト超を読む際のマイナンバーカードの正確な終了条件（`61 xx` / `6C xx` の有無、EF ごとの最大長）は `未確認`。`ios-corenfc-apdu` の注記に従う。

> 注: 実装によっては、署名用電子証明書（EF `00 01`）の READ 前に**利用者証明用（4桁）暗証番号**の VERIFY が必要との報告がある（`未確認事項`）。`63 CX` / `69 82`（セキュリティ状態不満足）が返る場合はこの前提を疑う。

## サーバーへの受け渡し

- アプリがサーバーへ送るのは **`{ signature: 署名値, certificate: 署名用電子証明書(DER) }`** と、どの署名対象データに対する署名かを示す識別子（サーバーが手順前に払い出したセッション ID 等）。
- サーバーが行うこと（アプリは行わない）:
  - 署名対象データ（本文 + nonce）を再構成し、証明書内の公開鍵で署名を検証する → `signature-verification`。
  - 電子証明書の有効性・失効を PF事業者経由で J-LIS に確認する → `jlis-yukousei-kakunin`。
- 送信が完了したら、端末上の署名値・証明書・ハッシュ・暗証番号入力をすべて破棄する。リトライ時は再度カードから取得する。

## やってはいけないこと

- **暗証番号はカードへの VERIFY にだけ使う。** サーバー・分析 SDK・ペーストボードへ送らず、Keychain（生体認証付きの「暗証番号を記憶」も含む）・UserDefaults・ログ・クラッシュレポートに保存しない。メモリ上も最小限にとどめ、VERIFY 後は即座に破棄する。
- **端末内でローカルに署名検証しない。** 証明書チェーン検証・失効確認・有効性確認はサーバー（PF事業者経由）の責務。アプリから J-LIS へ直接照会しない。
- **署名対象の nonce をアプリで生成しない。** 必ずサーバーが払い出した to-be-signed に署名する。
- **本文を表示せずに署名しない。サーバーから届いたハッシュを検算なしで署名しない。** ハッシュはアプリが to-be-signed から計算する（「前提」参照）。
- **カードから読んだデータ（証明書 DER・署名値・秘密鍵に関する情報）をリクエストの範囲を超えて保持しない。**
- **`63 CX` で自動リトライしない。** ロック回数に近づける。UX は `pin-lock-handling`。
- 犯収法の方法名・施行時期をこのスキルで断定しない（`honnin-kakunin-houhou` / `references/method-map.md`）。

## 出典

- <https://tex2e.github.io/blog/protocol/jpki-mynumbercard-with-apdu>（「マイナンバーカードとAPDUで署名データ作成」— JPKI-AP AID、SELECT `00 A4 04 0C` / `00 A4 02 0C`、署名用秘密鍵 EF `00 1A` / 暗証番号 EF `00 1B` / 証明書 EF `00 01`、VERIFY `00 20 00 80`、COMPUTE DIGITAL SIGNATURE `80 2A 00 80` と SHA-256 DigestInfo（Lc=`33`）、`SHA256withRSA` / PKCS#1 v1.5、証明書の分割 READ。取得日 2026-09-08）
- `references/apdu-cheatsheet.md`（AID・SELECT / VERIFY / READ BINARY / COMPUTE DIGITAL SIGNATURE のバイト列と各値の確度、SW1SW2、暗証番号の桁数）
- <https://zenn.dev/trustdock/articles/66a228895294bc>（TrustDock「公的個人認証（JPKI）入門」— NFC Type-B、ISO 7816 APDU、署名用 暗証番号 6〜16 英数字・失敗 5 回でロック。取得日 2026-09-08）
- <https://www.jpki.go.jp/procedure/password.html>（J-LIS「公的個人認証サービス ポータルサイト」— 署名用電子証明書のパスワード（6〜16桁の英数字）は 5 回連続で間違えるとロック。取得日 2026-09-08）

## 最終確認日: 2026-09-11

## 未確認事項

- `COMPUTE DIGITAL SIGNATURE` の入力形式（DigestInfo か生ハッシュか、パディングの要否）。tex2e が具体的なバイト列（SHA-256 プレフィックス + 32B、Lc=`33`）を示すが依然 1 ソースのみ。実装前に検証すること。
- DigestInfo プレフィックスの内側 SEQUENCE 長。本スキルは RFC 8017 準拠の `30 0D`（OID 11B + NULL 2B）を採用。tex2e の記事が `30 0B` と表記していれば誤植とみられる（外側 `30 31` と Lc=`33` は NULL 込みの長さと整合する）。実カード / 正式仕様で要確認。
- 署名前の MSE（Manage Security Environment）等の前処理の要否。tex2e の手順には無い。
- 署名アルゴリズム（RSA-2048 / PKCS#1 v1.5 / SHA-256）の現行仕様、他ハッシュ・鍵長への対応。
- 署名用秘密鍵 EF `00 1A`・暗証番号 EF `00 1B`・証明書 EF `00 01` の EF-ID（tex2e 1 ソース）。
- `63 CX` の下位ニブルが残り試行回数か、`69 83` がロックか（ISO/IEC 7816-4 標準値。JPKI 固有の一次ソースは `未確認`）。署名用の失敗ロック回数 5 回は J-LIS `jpki.go.jp` で確認済（`pin-lock-handling` / `apdu-cheatsheet.md`）。
- READ BINARY で証明書 EF（256 バイト超）を読む際の終了条件と最大読み取り長。
- **署名用電子証明書（EF `00 01`）の READ に、利用者証明用（4桁）暗証番号の事前 VERIFY が必要か。** 複数の実装で「署名用証明書の読み出しには利用者証明用パスワードが要る」との報告がある（`jpki-ap-riyousha` の利用者証明用証明書は暗証番号不要）。必要な場合、フロー全体で 2 種類の暗証番号入力が要る設計になる。実カード / 正式仕様で要検証。
