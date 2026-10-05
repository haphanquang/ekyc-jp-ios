---
name: kenmen-nyuryoku-hojo-ap
description: 券面入力補助AP から 基本4情報（氏名・住所・生年月日・性別）を テキスト取得 する iOS 実装で使用。ヘ方式 IC読取（IC読取＋容貌撮影）向け。カード券面記載の 生年月日6桁＋有効期限（西暦4桁）＋セキュリティコード4桁 を解錠情報として使う想定だが、この14桁がどの keyref・EF・整形に対応するかは公開仕様に無く未確認（公開例は4桁PINのみ）。基本4情報を READ BINARY で読み取る。このAPは署名しない読み取り専用。個人番号の読出し・容貌照合・カ方式（JPKI署名）は対象外。ヘ方式で条文が求めるIC内顔写真は本APには無く、券面事項確認AP（kenmen-jikou-kakunin-ap）で取得する。
---

# 券面入力補助AP で基本4情報をテキスト取得する

マイナンバーカードの `券面入力補助AP` から **基本4情報（氏名・住所・生年月日・性別）をテキストとして READ BINARY で読み出す**手順リファレンス。ヘ方式（IC読取＋容貌撮影）で、券面撮影・容貌撮影と組み合わせて使う。**このAPは電子署名の機能を持たない。** 暗号学的な真正性証明が無いため、ヘ方式ではサーバー側の 容貌照合（撮影容貌との組合せ）で本人性を担保する（照合はサーバー側の責務。このスキルの対象外）。

犯収法などの方法名（ヘ方式・カ方式ほか）と適用時期はここで断定しない。詳細は `honnin-kakunin-houhou` / `references/method-map.md` を参照。

## このスキルを使う場面

- iOS アプリで、券面撮影＋容貌撮影に加えて IC から基本4情報をテキストで取得する実装を書くとき（ヘ方式）
- 券面入力補助AP の SELECT・解錠・基本4情報の READ BINARY の APDU を確認するとき
- 利用者が 4桁の暗証番号を入力しない構成（カード券面の記載値で解錠）を実装するとき

個人番号（個人番号）も同じ AP 内にあるが、その読出しには別の解錠と番号法上の根拠が要る → `kenmen-jikou-kakunin-ap`。ロック・残回数の UX は `pin-lock-handling`。電子署名で真正性を確認するならカ方式 → `jpki-ap-shomei`。

## 前提

- `ios-corenfc-apdu` を完了していること（`NFCTagReaderSession` の確立、`NFCISO7816Tag` への `connect`、`sendCommand` による APDU 送受信、256 バイト超の分割 READ、`Info.plist` の `select-identifiers` への AID 列挙）。
- APDU のバイト列は `references/apdu-cheatsheet.md` に記録済みの形のみ使う。`未確認` の項目は実装前に検証する。推測でバイト列を組み立てない。
- カードから読んだ基本4情報は RAM でのみ保持し、サーバー送信後に破棄する（`ios-security`）。

## 解錠情報

ヘ方式では、利用者が**物理カードの券面に記載された値**を書き写して入力する。暗証番号（4桁）を記憶していなくても解錠できるのが特徴で、これがヘ方式の離脱率の低さにつながる（`references/pdfs/33_guide-liquid-ekyc.pdf` p11。ベンダー資料）。

| 要素 | 桁数 | 備考 |
|---|---|---|
| 生年月日 | 6桁 | カード券面の生年月日。数字6桁への整形（西暦/和暦・ゼロ埋め・並び順）は `未確認` |
| 有効期限 | 4桁 | 西暦の年（例: `2030`）。PDF 33 p11 は「有効期限西暦4桁」と記載 |
| セキュリティコード | 4桁 | カード券面に記載の4桁 |

合計 14 桁。この 14 桁を解錠情報として VERIFY に送る（PDF 33 p11）。**14 桁を送る際の keyref（P2）・Lc・対象 EF・文字整形（ASCII 連結か否か、区切りの有無）は公開ソースに無く `未確認`。** 下記手順の tex2e の例は 4桁の券面入力補助用暗証番号を送るもので、14 桁の解錠とは別経路の可能性がある。

## 読み取り手順

1 セッション内で順に送る。各応答 SW が `90 00` でなければ中断する。APDU は `references/apdu-cheatsheet.md` の記録値と tex2e の実装例（`（要検証）`）に基づく。

- [ ] **1. 券面入力補助AP を SELECT** — `00 A4 04 0C 0A D3 92 10 00 31 00 01 01 04 08`（AID は kopaneet・tex2e の 2 ソースで一致。J-LIS 一次資料では `未確認`）。`6A 82` なら AID / `Info.plist` の `select-identifiers` を見直す。
- [ ] **2. 券面入力補助用暗証番号の EF を SELECT** — `00 A4 02 0C 02 00 11`（EF-ID は tex2e・kopaneet の 2 ソース。`（要検証）`）。
- [ ] **3. 解錠情報を VERIFY** — `00 20 00 80` ＋ 解錠情報の ASCII バイト列。
  - tex2e の例は 4桁 PIN: `00 20 00 80 04 31 32 33 34`（`1234`。keyref P2=`80`）。
  - **ヘ方式では 4桁 PIN の代わりに券面記載の 14 桁（生年月日6＋有効期限4＋セキュリティコード4）を送る**（PDF 33 p11）。この場合の P2・Lc・整形は `未確認`。
  - SW: `90 00` 成功 / `63 CX` 不一致・残り `X` 回（ISO/IEC 7816-4 標準値。マイナンバーカード固有の一次ソースは `未確認`）/ `69 83` ロック。
  - **自動リトライしない。** 残回数の提示・ロック手前の警告・解錠導線は `pin-lock-handling` に委譲する。
- [ ] **4. 基本4情報ファイルの EF を SELECT** — `00 A4 02 0C 02 00 02`（EF-ID は tex2e・kopaneet の 2 ソース。`（要検証）`）。
- [ ] **5. データ長を READ BINARY** — tex2e の例では `00 B0 00 02 01` で 3 バイト目の長さバイトのみ読む（`（1ソースのみ・要検証：tex2e）`）。
- [ ] **6. 本体を READ BINARY** — tex2e の例では `00 B0 00 00 71`。応答は TLV で、`FF 20`（外側）配下に `DF 21`（ヘッダ）/ `DF 22`（氏名）/ `DF 23`（住所）/ `DF 24`（生年月日）/ `DF 25`（性別・1 バイト、`31`=男 `32`=女 `33`=その他）が並ぶ。氏名・住所は UTF-8。**この TLV のタグ・長さ・全長・終了条件は tex2e 1 ソースのみで `未確認`。推測でパースしない。**

```swift
extension CardReader {
    // 手順 3: 解錠情報の VERIFY。ヘ方式は券面記載の 14 桁を渡す。
    // keyref / Lc / 整形は未確認のため、確定したバイト列に差し替えて使う。
    // VerifyOutcome / PINKind / pinBytes / interpret は pin-lock-handling で定義。
    // kind: 4 桁 PIN なら .kenmenHojo、ヘ方式の券面記載 14 桁なら .shogoB
    func verifyKenmenUnlock(_ unlock: String, kind: PINKind, tag: NFCISO7816Tag) async throws -> VerifyOutcome {
        let bytes = try pinBytes(unlock, kind: kind)         // 全角→半角・桁数チェック（違反はカードへ送らない）
        let apdu = rawAPDU([0x00, 0x20, 0x00, 0x80, UInt8(bytes.count)] + bytes)
        let (_, sw1, sw2) = try await send(apdu, to: tag)
        return interpret(sw1: sw1, sw2: sw2)                // pin-lock-handling
    }

    // 手順 4〜6: 基本4情報の EF を選択して読む。TLV パースは確定仕様が出るまで実装しない。
    func readKihon4(tag: NFCISO7816Tag) async throws -> Data {
        try await selectEF(efID: [0x00, 0x02], tag: tag)     // 00 A4 02 0C 02 00 02（要検証）
        // 本体は最大 112 バイト（kopaneet）で、一部のカードは FF 20 の前に 2 バイト付くため、
        // TLV ヘッダから全長を決め打ちしない。256 バイトを 1 回で要求し、62 82（終端）で返った分を使う。
        // 90 00 / 62 82 以外は readBinary が throw する（ios-corenfc-apdu）
        let raw = try await readBinary(offset: 0, length: 256, tag: tag)
        return raw   // TLV（FF20 / DF21..DF25）。タグ・長さは未確認。氏名・住所は UTF-8
    }
}
```

- 2023 年頃に発行されたカードでは応答先頭に余分な 2 バイト（`FF 20` の前）が付くとの報告がある（tex2e 追記・`ny-a` の修正）。ヘッダ位置を固定オフセットで決め打ちしない。
- 本体長は最大 112 バイトとの記載（kopaneet）。ただし外字画像を含む版など EF レイアウトの網羅は `未確認`。

## カ方式との使い分け

| | ヘ方式（このスキル） | カ方式 |
|---|---|---|
| 使う AP | 券面入力補助AP | JPKI-AP／署名用（`jpki-ap-shomei`） |
| 解錠 | 券面記載の 生年月日6＋有効期限4＋セキュリティコード4（14 桁） | 署名用暗証番号（6〜16 桁英数字） |
| 取得物 | 基本4情報のテキスト（＋撮影容貌・IC 顔写真） | 署名用電子証明書（DER）＋秘密鍵による電子署名値 |
| 真正性の担保 | 暗号学的証明なし → サーバー側の容貌照合と組合せ | 電子署名の検証＋証明書の有効性確認（`signature-verification` / `jlis-yukousei-kakunin`） |
| 署名 | しない（読み取り専用） | する |

方法名・号記号・適用時期は断定しない。`honnin-kakunin-houhou` / `references/method-map.md` を参照。

## やってはいけないこと

- **暗証番号・解錠情報を保存しない。** メモリ上も最小限にし、VERIFY 後に破棄する。Keychain・UserDefaults・ログ・クラッシュレポートに残さない。
- **`63 CX` で自動リトライしない。** ロックに近づける。UX は `pin-lock-handling`。
- **TLV を推測でパースしない。** タグ・長さ・全長が `未確認` のまま決め打ち実装しない。
- **個人番号を、この AP のついでに読まない。** 番号法上の根拠・別の解錠が要る（`kenmen-jikou-kakunin-ap`）。
- **端末側で容貌照合・本人性判定をしない。** 撮影容貌との照合はサーバー側。J-LIS へ直接照会しない。
- 犯収法の方法名・施行時期をこのスキルで断定しない（`honnin-kakunin-houhou` / `references/method-map.md`）。

## 出典

`references/pdfs/` の PDF は第三者の著作物のためリポジトリに含めない。手元に無ければ `bash references/refresh.sh` で取得する（URL・SHA256 は `references/sources.md`）。

- `references/apdu-cheatsheet.md`（券面入力補助AP の AID、EF-ID（`00 11` / `00 02` / `00 01`）、SELECT / VERIFY / READ BINARY のバイト列と各値の確度、SW1SW2、ロック回数）
- `references/pdfs/33_guide-liquid-ekyc.pdf` p11（LIQUID eKYC のご案内 ICチップ方式版 — ヘ方式の説明、マイナンバーカードの認証情報＝「生年月日6桁＋有効期限西暦4桁＋セキュリティコード4桁」、主な取得データ＝氏名／生年月日／住所／性別・IC 顔写真・撮影容貌、ロック回数「10回」と記載＝これは 14 桁 照合番号B（券面事項確認AP）の回数で、4 桁 PIN の 3 回とは別。ベンダー資料。取得日 2026-09-08）
- <https://zenn.dev/trustdock/articles/66a228895294bc>（TrustDock「公的個人認証（JPKI）入門」— 券面事項入力補助AP は基本4情報とマイナンバーをテキストで読み出す AP、アクセスに 4桁数字の暗証番号、連続 3 回失敗でロック。取得日 2026-09-08）
- <https://www.kojinbango-card.go.jp/faq_pin2/>（マイナンバーカード総合サイト FAQ「券面事項入力補助アプリの暗証番号とは何ですか？」— 数字 4 桁、3 回誤入力でロック、市区町村で再設定。取得日 2026-09-08）
- <https://services.digital.go.jp/mynumbercard/info-passcode/>（デジタル庁「マイナンバーカードの券面事項入力補助用暗証番号」— 4 桁・3 回でロック。券面AP読み取りの照会番号は 14 桁で、続けて 10 回誤るとカードがロック。取得日 2026-09-08）
- <https://tex2e.github.io/blog/protocol/jpki-mynumbercard-with-apdu>（「マイナンバーカードとAPDUで署名データ作成」— 券面入力補助AP DF 名 `D3 92 10 00 31 00 01 01 04 08`、SELECT `00 A4 04 0C` / `00 A4 02 0C`、券面入力補助用PIN EF `00 11`、基本4情報 EF `00 02`、VERIFY `00 20 00 80 04 31 32 33 34`、READ BINARY `00 B0 00 02 01` → `00 B0 00 00 71`、TLV `FF 20` / `DF 21`〜`DF 25`、性別 `31`/`32`/`33`、氏名・住所は UTF-8、2023 年頃発行分の先頭 2 バイト補正。取得日 2026-09-08）
- <https://zenn.dev/kopaneet/articles/1ee74f87eb31d3>（「マイナンバーカードから基本4情報の取得」— 券面入力補助AP AID `D3 92 10 00 31 00 01 01 04 08`、EF-ID（基本4情報 `00 02` / 個人番号 `00 01` / 入力補助用PIN `00 11`）、SELECT/VERIFY/READ BINARY の順序、本体は 3 バイト目に長さ・最大 112 バイト・UTF-8、連続 3 回失敗でロック。取得日 2026-09-08）

## 最終確認日: 2026-09-11

## 未確認事項

- **ロック回数。** 券面入力補助用の 4 桁 PIN は連続 3 回でロック（確認済：マイナンバーカード総合サイト `kojinbango-card.go.jp`・マイナポータル FAQ・デジタル庁 `services.digital.go.jp`。`references/apdu-cheatsheet.md`）。`references/pdfs/33_guide-liquid-ekyc.pdf` p11 の「10回」は 4 桁 PIN ではなく、券面記載値で読み取る 14 桁の照合番号B（券面事項確認AP）のロック回数（確認済：デジタル庁・松山市・PocketSign）。**4 桁 PIN の 3 回と 14 桁 照合番号B の 10 回は別の認証情報であり、矛盾ではない。** 4 桁 PIN の解錠パラメータの keyref は未確認。
- **ヘ方式の解錠情報（14 桁）の送り方。** 生年月日6＋有効期限4＋セキュリティコード4 の桁整形（西暦/和暦・ゼロ埋め・並び順）、連結時の区切りの有無、VERIFY の keyref（P2）・Lc・対象 EF。公開ソースは 4桁 PIN の VERIFY 例しか示さない。
- **AID `D3 92 10 00 31 00 01 01 04 08`。** kopaneet・tex2e の 2 ソースで一致するが、いずれも個人ブログ。J-LIS の技術仕様（NDA）で未確認。
- **基本4情報の TLV レイアウト。** `FF 20` 外側、`DF 21`〜`DF 25` の各タグ・長さ・全長・READ の終了条件・最大長。tex2e 1 ソースのみ。発行年による差異（先頭余分バイト、外字画像の有無）も要検証。
- **EF-ID（`00 11` / `00 02` / `00 01`）と VERIFY keyref。** tex2e・kopaneet の 2 ソースだが J-LIS 一次資料では未確認。
- **セキュリティコード 4桁の券面上の記載位置**と、券面入力補助用暗証番号（4桁）との関係。
