---
name: jpki-ap-riyousha
description: マイナンバーカードの利用者証明用電子証明書を使った当人認証（チャレンジレスポンス）を iOS で実装する際に使用。JPKI-AP の SELECT、利用者証明用暗証番号（4桁 数字）の VERIFY、サーバーが発行したチャレンジ（nonce）への署名、利用者証明用電子証明書（DER）の READ とサーバー送信を扱う。サーバーは利用者証明用認証局へのチェーン検証・署名検証に加え発行番号 照合で同一カードを特定し、ログイン等の繰り返し当人認証に使う。基本4情報を持たないため単独では犯収法の身元確認に使えない。nonce 生成・発行番号 照合・有効性確認・署名検証はサーバー側（対象外）。
---

# JPKI-AP で利用者証明用の鍵・証明書を使う（当人認証 / チャレンジレスポンス）

マイナンバーカードの `JPKI-AP` にある **利用者証明用の秘密鍵でサーバーのチャレンジ（nonce）に署名し、利用者証明用電子証明書（DER）を読み出して**サーバーへ渡すまでの手順リファレンス。サーバーは証明書を利用者証明用認証局までチェーン検証したうえで署名を検証し、証明書の**発行番号**を保存済みの値と照合して「同じ人の同じカード」であることを確認する（当人認証）。署名検証・発行番号照合・有効性確認・nonce 発行はすべてサーバー側で行う（このスキルの対象外）。

犯収法の方法名と適用時期はここで断定しない。詳細は `honnin-kakunin-houhou` / `references/method-map.md` を参照。

## このスキルを使う場面

- iOS アプリでサイトログイン等の当人認証を、利用者証明用電子証明書のチャレンジレスポンスで実装するとき
- 利用者証明用暗証番号（4桁 数字）の VERIFY と、SW による残り試行回数の読み取りを実装するとき
- サーバーが払い出したチャレンジ（nonce）に `JPKI-AP` の利用者証明用秘密鍵で署名する APDU を確認するとき
- 利用者証明用電子証明書（DER）を読み出してサーバーへ渡し、発行番号でログイン者を特定させる分担を確認するとき

nonce の発行・セッション状態管理は `ekyc-session-orchestration`、電子証明書の有効性確認は `jlis-yukousei-kakunin`、署名検証は `signature-verification`、ロック・残回数の UX は `pin-lock-handling` を参照。CoreNFC のセッション確立・APDU 送受信は `ios-corenfc-apdu`、鍵・暗証番号の取り扱いは `ios-security`。

## 前提

- `ios-corenfc-apdu` を完了していること（`NFCTagReaderSession` の確立、`NFCISO7816Tag` への `connect`、`sendCommand`、256 バイト超の分割 READ、`Info.plist` の `select-identifiers` への AID 列挙）。
- APDU のバイト列は `references/apdu-cheatsheet.md` に記録済みの形のみを使う。`未確認` の項目は実装前に検証する。
- **チャレンジ（nonce）はサーバーが生成する。** サーバーがセッションごとに乱数を発行し、アプリはそれ（またはそのハッシュ）に署名するだけ。アプリが nonce を発行しない。
- 署名アルゴリズムは RSA-2048 / PKCS#1 v1.5 / SHA-256（`未確認`：現行仕様・他ハッシュ対応は要検証。`apdu-cheatsheet.md`）。パディングはカード内部で行われる。
- 利用者証明用電子証明書には**基本4情報（氏名・住所・生年月日・性別）が入っていない**。持っているのは発行番号と有効期間のみ（`references/jpki-introduction.ja.md` §5.2.2）。

## 署名用との違い

| | 利用者証明用電子証明書 | 署名用電子証明書 |
|---|---|---|
| 主な用途 | サイトへのログイン等の当人認証（繰り返し利用）| 申込・契約など電子文書の作成・送信（真正性の証明）|
| 暗証番号 | 4桁 数字（桁数は zenn.dev/trustdock・tex2e で一致）| 6〜16桁 英数字 |
| ロック回数 | 3（確認済：J-LIS `jpki.go.jp`。`apdu-cheatsheet.md`）| 5（確認済：J-LIS `jpki.go.jp`）|
| 基本4情報 | 保持しない（発行番号・有効期間のみ）| 保持する |
| サーバーの検証 | チャレンジ署名の検証 ＋ 発行番号の照合で本人（同一カード）を特定 | 署名検証 ＋ 基本4情報の照合 |
| 失効条件 | 有効期間満了、本人死亡・国外転出等（基本4情報の変更では失効しない）| 上記に加え基本4情報の変更（引越し・婚姻等）|
| 犯収法の身元確認 | **単独では不可**（基本4情報を返せない）| 公的個人認証による身元確認（「カ方式」等）に使用（→ `jpki-ap-shomei` / `honnin-kakunin-houhou`）|
| 実装スキル | このスキル | `jpki-ap-shomei` |

tex2e によれば、チャレンジレスポンスに使う APDU 自体は署名用の署名生成とほぼ同じ（`COMPUTE DIGITAL SIGNATURE` `80 2A 00 80`）で、違いは対象の鍵・暗証番号・証明書の EF と、サーバーが署名対象として渡すデータ（本文ハッシュではなくセッションごとの nonce）である（1ソースのみ・要検証。別コマンドの可能性は `## 未確認事項`）。

## チャレンジレスポンスの手順

サーバーがセッションに紐づくチャレンジ（nonce）を発行済みである前提。1 セッション内で下記を順に送り、各ステップの応答 SW が `90 00` でなければ中断する。

- [ ] **1. JPKI-AP を SELECT** — `00 A4 04 0C 0A D3 92 F0 00 26 01 00 00 00 01`（AID は tex2e・moritamori・kopaneet の 3 ソースで一致）。`6A 82` なら AID / `Info.plist` の `select-identifiers` を見直す。
- [ ] **2. 利用者証明用暗証番号の EF を SELECT** — `00 A4 02 0C 02 00 18`（EF-ID `00 18` は tex2e が「認証用PIN」として記載。`（1ソースのみ・要検証）`。`apdu-cheatsheet.md`）。
- [ ] **3. 利用者証明用暗証番号を VERIFY** — `00 20 00 80` ＋ 暗証番号 4 桁の ASCII バイト列（keyref P2=`80` は 3 ソース一致。tex2e の例は `00 20 00 80 04 31 32 33 34`）。応答 SW を確認する:
  - `90 00`: 照合成功。
  - `63 CX`: 不一致。下位ニブル `X` が残り試行回数（ISO/IEC 7816-4 標準値。JPKI 固有の一次ソースは `未確認`）。**自動リトライしない。** 残回数の提示・ロック手前の警告・解錠導線は `pin-lock-handling` に委譲する。利用者証明用のロック回数は 3 回（確認済：J-LIS `jpki.go.jp`。`pin-lock-handling` / `apdu-cheatsheet.md`）。
  - `69 83`: ロック済み。`pin-lock-handling` 参照。
- [ ] **4. 利用者証明用秘密鍵の EF を SELECT** — `00 A4 02 0C 02 00 17`（EF-ID `00 17` は tex2e が「認証用秘密鍵」として記載。`（1ソースのみ・要検証）`。MSE / Manage Security Environment は tex2e の手順には無い。`未確認`）。
- [ ] **5. チャレンジに署名する（COMPUTE DIGITAL SIGNATURE）** — `80 2A 00 80` ＋ サーバーのチャレンジから作った署名対象データ。tex2e は利用者証明用（認証用）でも署名用と同じ `80 2A 00 80` を使い、SHA-256 の DigestInfo プレフィックス（RFC 8017 準拠）`30 31 30 0D 06 09 60 86 48 01 65 03 04 02 01 05 00 04 20` に 32 バイトのハッシュを連結して Lc=`33` で送る。チャレンジレスポンスに `80 2A 00 80` を使う点・入力を DigestInfo とする点はいずれも **tex2e 1 ソースのみ・要検証**。応答データが RSA-2048 の署名値（256 バイト・要検証）、末尾 SW が `90 00`。
  - サーバーが「nonce の生バイト列」を渡すのか「nonce の SHA-256 ハッシュ」を渡すのかは、サーバー実装（`ekyc-session-orchestration`）と合わせる。DigestInfo でラップするか否かも含めて `未確認`。
  - `INTERNAL AUTHENTICATE`（`00 88 …`）等の別コマンドでチャレンジレスポンスを行う実装の有無は `未確認`。tex2e の手順には無い。
- [ ] **6. 利用者証明用電子証明書の EF を SELECT ＆ READ** — `00 A4 02 0C 02 00 0A`（EF-ID `00 0A` は tex2e。証明書取得には暗証番号は不要）。先頭 4 バイトの ASN.1 長フィールドから DER 全長を求め、`00 B0 <offset 上位> <offset 下位>` で分割 READ する（`ios-corenfc-apdu` の分割読み取りを使う）。

```swift
extension CardReader {
    // 手順 3: 利用者証明用暗証番号（4桁 数字）の VERIFY。SW を呼び出し側へ返し、
    //         リトライは pin-lock-handling に委ねる
    //         （VerifyOutcome / pinBytes / interpret は pin-lock-handling で定義）
    func verifyRiyoushaPIN(_ pin: String, tag: NFCISO7816Tag) async throws -> VerifyOutcome {
        let bytes = try pinBytes(pin, kind: .riyousha)             // "１２３４" も "1234" -> 31 32 33 34
        try await selectEF(efID: [0x00, 0x18], tag: tag)          // 00 A4 02 0C 02 00 18（1ソース・要検証）
        let apdu = rawAPDU([0x00, 0x20, 0x00, 0x80, UInt8(bytes.count)] + bytes)
        let (_, sw1, sw2) = try await send(apdu, to: tag)
        return interpret(sw1: sw1, sw2: sw2)                // pin-lock-handling
    }

    // 手順 4-5: 利用者証明用秘密鍵でサーバーのチャレンジ（SHA-256 ハッシュ 32B）に署名する
    func signChallenge(sha256 challengeHash: Data, tag: NFCISO7816Tag) async throws -> Data {
        guard challengeHash.count == 32 else { throw ReaderError.invalidInput }
        try await selectEF(efID: [0x00, 0x17], tag: tag)          // 00 A4 02 0C 02 00 17（1ソース・要検証）
        // RFC 8017 (PKCS#1 v1.5) の SHA-256 DigestInfo プレフィックス。内側 SEQUENCE 長は 0x0D。
        // サーバーが生 nonce を渡す設計なら、ハッシュ化とこのラップはサーバー仕様に合わせる（未確認）
        let digestInfoPrefix: [UInt8] = [
            0x30, 0x31, 0x30, 0x0D, 0x06, 0x09, 0x60, 0x86, 0x48, 0x01,
            0x65, 0x03, 0x04, 0x02, 0x01, 0x05, 0x00, 0x04, 0x20,
        ]
        let digestInfo = digestInfoPrefix + Array(challengeHash)   // 全長 0x33 = 51 バイト
        let apdu = rawAPDU([0x80, 0x2A, 0x00, 0x80, UInt8(digestInfo.count)] + digestInfo + [0x00])
        let (sig, sw1, sw2) = try await send(apdu, to: tag)
        guard sw1 == 0x90, sw2 == 0x00 else { throw ReaderError.signFailed(sw1, sw2) }
        return sig                                                 // RSA-2048 署名値（256 バイト）
    }

    // 手順 6: 利用者証明用電子証明書（DER）。基本4情報は含まれない
    func readRiyoushaCertificate(tag: NFCISO7816Tag) async throws -> Data {
        try await selectEF(efID: [0x00, 0x0A], tag: tag)          // 00 A4 02 0C 02 00 0A
        return try await readSelectedTLV(tag: tag)                 // ios-corenfc-apdu: DER ヘッダの全長どおりに分割 READ
    }
}
```

## 発行番号での特定

- 利用者証明用電子証明書は基本4情報を持たないため、サーバーは「誰か」を氏名等では特定できない。代わりに**発行番号**（電子証明書ごとに一意な番号）で特定する。
- サーバー側の流れ（アプリは行わない）:
  1. **登録（アカウントへの紐付け）は、完了した eKYC セッションの中でだけ行う。** 同じ NFC セッションで署名用・利用者証明用の両方の電子証明書を読み、両方の鍵で**そのセッションの nonce** に署名させ、署名用側の身元確認（`signature-verification` 手順 1〜5 ＋ `jlis-yukousei-kakunin`）が成功したときに限り、利用者証明用電子証明書の **(issuer DER, 発行番号) の組**をそのアカウントに保存する。ログイン済みというだけで利用者証明用電子証明書を追加登録させない（攻撃者が自分のカードを被害者のアカウントに登録できてしまう）。両証明書が同一カード由来であることを PF事業者の紐付け機能で確かめられるかは `未確認事項`。
  2. ログインのたびに、届いた利用者証明用電子証明書を**利用者証明用認証局までチェーン検証**し、有効期限を確認する（`signature-verification`「利用者証明用電子証明書にも同じ検証を適用する」）。**証明書内の公開鍵で署名を検証するだけでは不十分**：発行番号は秘密ではないので、攻撃者は被害者の発行番号を入れた自己署名証明書を作り、自分の鍵で署名できる。
  3. チェーンが通った証明書の公開鍵で、署名がそのセッションの nonce に対するものであることを検証する（nonce は原子的に消費。`signature-verification` 手順 4）。
  4. 証明書の (issuer DER, 発行番号) が保存済みの組と一致するかを照合する（発行番号だけで照合しない）。
  5. 有効性確認（`jlis-yukousei-kakunin`）をログインのたびに行う。
  6. 2〜5 がすべて成功したときだけ「同一人物・同一カードによる当人認証成功」と判定する。
- 発行番号が証明書 DER のどのフィールド（X.509 の serialNumber か独自拡張か）に入るか、専用 EF から読めるかは `未確認`。アプリは**証明書 DER をそのままサーバーへ送る**だけとし、パースはサーバーが行う。
- カードの更新・再発行（引越しでの失効・有効期限切れなど）で発行番号は変わる。発行番号の不一致は「別人」ではなく「カードが変わった」可能性があるため、サーバー側で再登録フローへ誘導する。
- 発行番号が一致しても、その電子証明書が失効していないことは別途確認が必要 → `jlis-yukousei-kakunin`（PF事業者経由。アプリ／サーバーから J-LIS へ直接照会しない）。
- nonce の発行・セッションとの紐付け・リプレイ対策は `ekyc-session-orchestration`。

## 使ってはいけない場面

- **単独で犯収法の身元確認（本人特定事項の確認）に使わない。** 利用者証明用電子証明書は基本4情報を返せないため、氏名・住所・生年月日を確認できない。用途は当人認証（ログイン・繰り返しの本人性確認・端末やアカウントとの紐付け）に限る。犯収法の方法名・適用時期は `honnin-kakunin-houhou` / `references/method-map.md` を参照。JPKI による身元確認が必要なら署名用電子証明書を使う → `jpki-ap-shomei`。
- **端末内でチャレンジ署名・発行番号・証明書チェーンを検証しない。** 署名検証・発行番号照合・失効確認はサーバー（PF事業者経由）の責務。アプリから J-LIS へ直接照会しない。
- **チャレンジ（nonce）をアプリで生成しない。** 必ずサーバーが払い出したものに署名する。アプリ生成の値に署名させるとリプレイ／リレー攻撃を許す。
- **暗証番号はカードへの VERIFY にだけ使う。** サーバー・分析 SDK・ペーストボードへ送らず、Keychain（生体認証付きの「暗証番号を記憶」も含む）・UserDefaults・ログ・クラッシュレポートに保存しない。メモリ上も最小限にとどめ、VERIFY 後は即座に破棄する（`ios-security`）。
- **`63 CX` で自動リトライしない。** ロック回数に近づける。UX は `pin-lock-handling`。
- **カードから読んだデータ（証明書 DER・署名値）をリクエストの範囲を超えて保持しない。** サーバー送信後に破棄し、リトライ時は再度カードから取得する。
- 犯収法の方法名・施行時期をこのスキルで断定しない。

## 出典

- <https://tex2e.github.io/blog/protocol/jpki-mynumbercard-with-apdu>（「マイナンバーカードとAPDUで署名データ作成」— JPKI-AP AID `D3 92 F0 00 26 01 00 00 00 01`、SELECT `00 A4 04 0C` / `00 A4 02 0C`、認証用（＝利用者証明用）PIN EF `00 18` / 認証用秘密鍵 EF `00 17` / 認証用証明書 EF `00 0A`、VERIFY `00 20 00 80`（4桁 ASCII 例 `00 20 00 80 04 31 32 33 34`）、認証用でも COMPUTE DIGITAL SIGNATURE `80 2A 00 80` を使用、SHA-256 DigestInfo（Lc=`33`）、`SHA256withRSA` / PKCS#1 v1.5、証明書の分割 READ。取得日 2026-09-08）
- `references/apdu-cheatsheet.md`（AID・SELECT / VERIFY / COMPUTE DIGITAL SIGNATURE / READ BINARY のバイト列と各値の確度、SW1SW2、利用者証明用暗証番号の桁数・ロック回数）
- `references/jpki-introduction.ja.md`（§5.2.2 — 利用者証明用電子証明書は主にサイトへのログインで利用、「ログインした者が利用者本人であること」を確認、基本4情報を保持しない。§5.1.1 失効条件、§5.1.2 有効性確認）。出典元: <https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction>（取得日 2026-09-07）
- <https://zenn.dev/trustdock/articles/66a228895294bc>（TrustDock「公的個人認証（JPKI）入門」— NFC Type-B、ISO 7816 APDU、利用者証明用暗証番号は 4桁 数字、チャレンジレスポンス（サーバーからのチャレンジ → IC カード内での処理 → 応答返却 → サーバー検証）の 4 段階。AID・APDU の 16 進値・発行番号の仕組みの記載なし。取得日 2026-09-08）
- <https://www.jpki.go.jp/procedure/password.html>（J-LIS「公的個人認証サービス ポータルサイト」— 利用者証明用電子証明書のパスワード（4桁の数字）は 3 回連続で間違えるとロック、署名用は 5 回連続。取得日 2026-09-08）

## 最終確認日: 2026-09-08

## 未確認事項

- 利用者証明用（tex2e 表記「認証用」）の秘密鍵 EF `00 17`・暗証番号 EF `00 18` は tex2e 1 ソースのみ（`apdu-cheatsheet.md` に同確度で追記）。実装前に検証すること。
- 署名用・利用者証明用の両電子証明書が同一カード由来であることを、PF事業者の紐付け（シリアル対応）機能で確認できるか。できない場合、登録時の同一性は「同じ NFC セッション・同じ nonce で両方の署名が得られた」ことで担保する。
- チャレンジレスポンスを COMPUTE DIGITAL SIGNATURE `80 2A 00 80` で行うか、`INTERNAL AUTHENTICATE`（`00 88 …`）等の別コマンドか。tex2e は認証用でも `80 2A 00 80` を示すが 1 ソースのみ。
- 手順 5 に渡す入力形式（サーバーのチャレンジ＝生 nonce をそのまま署名するのか、SHA-256 ハッシュか、DigestInfo でラップするか、ハッシュ長）。サーバー仕様（`ekyc-session-orchestration`）と要すり合わせ。
- `63 CX` の下位ニブルが残り試行回数か、`69 83` がロックか（ISO/IEC 7816-4 標準値。JPKI 固有の一次ソースは `未確認`）。利用者証明用暗証番号のロック回数 3 回は J-LIS `jpki.go.jp` で確認済。
- 発行番号が利用者証明用電子証明書のどのフィールド（X.509 serialNumber / 独自拡張）に入るか、専用 EF から読めるか。本スキルは証明書 DER をサーバーがパースする前提。
- 署名アルゴリズム（RSA-2048 / PKCS#1 v1.5 / SHA-256）の現行仕様、他ハッシュ・鍵長への対応。
- 証明書 EF（利用者証明用電子証明書）の READ BINARY の終了条件と最大読み取り長（`ios-corenfc-apdu` の注記に従う）。
