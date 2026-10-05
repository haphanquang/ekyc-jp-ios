# APDU / AID / SW1SW2 早見表

最終確認日: 2026-09-08

> J-LIS の正式な技術仕様書は NDA が必要。本表は公開情報（TrustDock 解説記事、個人ブログ、
> OSS 実装）からの整理であり、`未確認` の項目は実装前に必ず検証すること。
> ここに載せた 16 進値がそのまま iOS 実装へコピーされるため、推測でバイト列・AID・
> keyref・ロック回数を記載しないこと。各 AP の値は実装前の検証で確定する。
>
> 本表で「ヘ方式」に言及する箇所があるが、本人確認方法の名称・記号・時期の定義・確定状況は
> `skills/honnin-kakunin-houhou/SKILL.md` と `references/method-map.md` を唯一の典拠とする。
> ここでは技術的な文脈（どの照合値を送るか）でのみ用いる。

## NFC 前提

- マイナンバーカードは ISO/IEC 14443 **Type-B**（zenn.dev/trustdock で明記）。
- iOS では `NFCTagReaderSession(pollingOption: .iso14443)` → `.iso7816(tag)`。
- コマンドは ISO/IEC 7816-4 準拠の APDU（zenn.dev/trustdock）。

## AID 一覧

| アプリ | AID | 備考 |
|---|---|---|
| JPKI-AP（公的個人認証AP） | `D3 92 F0 00 26 01 00 00 00 01` | tex2e・moritamori・kopaneet の 3 ソースで一致 |
| 券面入力補助AP | `D3 92 10 00 31 00 01 01 04 08` | kopaneet・tex2e の 2 ソースで一致（いずれも個人ブログ・J-LIS 一次資料は要検証） |
| 券面事項確認AP | `未確認` | AID 実値は公開ソースで確認できず。デジタル庁「マイナンバーカードのアプリの概要／AP構成」はアクセスコントロールを照会番号ベースと説明：マイナンバー12桁 → 表＋裏（4情報＋顔写真の画像／マイナンバーの画像）、生年月日6桁＋有効期限西暦4桁＋セキュリティコード4桁 → 表のみ（1ソースのみ・要検証：digital.go.jp） |
| 住基AP | `未確認` | 公開ソースで実値を確認できず |

## 主要 APDU

| 操作 | CLA INS P1 P2 | データ | 備考 |
|---|---|---|---|
| SELECT (DF/AID) | `00 A4 04 0C` | AID | tex2e・moritamori・kopaneet で一致 |
| SELECT (EF) | `00 A4 02 0C` | EF-ID (2B) | tex2e（例: 認証用証明書 `00 0A`、署名用証明書 `00 01`、署名用秘密鍵 `00 1A`、署名用PIN `00 1B`。**認証用（＝利用者証明用）秘密鍵 `00 17`、認証用（＝利用者証明用）暗証番号 `00 18`** も tex2e に記載。`（1ソースのみ・要検証）`）。**券面入力補助AP: 券面入力補助用暗証番号 `00 11`、基本4情報 `00 02`、個人番号 `00 01`**（tex2e・kopaneet の 2 ソースで一致・`（要検証）`） |
| VERIFY (暗証番号) | `00 20 00 80` | PIN バイト列（ASCII） | JPKI-AP の PIN 照合で P2=`80`（tex2e・moritamori・kopaneet で一致）。**券面入力補助AP も tex2e に P2=`80`・Lc=`04` の 4 桁 PIN 例あり（`00 20 00 80 04 31 32 33 34`）**。ただし ヘ方式で送る「生年月日6＋有効期限4＋セキュリティコード4」14 桁の keyref・Lc・整形は `未確認`。他 AP（券面事項確認・住基）の keyref も `未確認` |
| READ BINARY | `00 B0 <offset-hi> <offset-lo>` | ― | 256B 超は分割。tex2e・kopaneet で INS=`B0` を確認、offset を P1P2 に置くのは ISO/IEC 7816-4 標準。**券面入力補助AP の基本4情報**は tex2e の例で `00 B0 00 02 01`（3 バイト目の長さバイトのみ）→ `00 B0 00 00 71`（本体、最大 112B・UTF-8・TLV `FF 20` 配下に `DF 21`〜`DF 25`（`DF 25` 性別 1B `31`/`32`/`33`））。TLV のタグ・長さ・全長・発行年差異（先頭 2B）は `（1ソースのみ・要検証：tex2e）` |
| COMPUTE DIGITAL SIGNATURE | `80 2A 00 80` | DigestInfo（ハッシュに ASN.1 DigestInfo を付与した DER） | CLA/INS/P1/P2 は tex2e・moritamori・kopaneet で一致。入力を DigestInfo とする点は tex2e 記事の実装例のみ（`（1ソースのみ・要検証）`）。tex2e の例では SHA-256 の DigestInfo プレフィックス + 32B ハッシュ（Lc=`33`）を送信。プレフィックスは RFC 8017（PKCS#1 v1.5）準拠で `30 31 30 0D 06 09 60 86 48 01 65 03 04 02 01 05 00 04 20`（内側 SEQ 長 `0D` = OID 11B + NULL 2B）。tex2e の記事が `30 0B` と表記していれば誤植とみられる（外側 `30 31`・Lc `33` は NULL 込みの長さと整合。要検証）。カード内部で PKCS#1 v1.5 パディングし RSA-2048 で署名（`SHA256withRSA`、tex2e 1ソースのみ）。事前に対象秘密鍵（EF `00 1A`）・PIN（EF `00 1B`）を SELECT/VERIFY 済みであること。MSE（Manage Security Environment）は tex2e の手順には無い（`未確認`）。**利用者証明用（認証用）のチャレンジレスポンス（当人認証）でも tex2e は同じ `80 2A 00 80` を使用**（認証用暗証番号 EF `00 18` を VERIFY → 認証用秘密鍵 EF `00 17` を SELECT → `80 2A 00 80` でサーバーのチャレンジに署名）。`（1ソースのみ・要検証）`。INTERNAL AUTHENTICATE（`00 88 …`）等の別コマンドで行う実装の有無は `未確認` |

## SW1SW2

| SW1SW2 | 意味 | 対応 |
|---|---|---|
| `90 00` | 正常終了 | 全ソースで一致 |
| `63 CX` | 暗証番号不一致。残り X 回 | pin-lock-handling 参照。ISO/IEC 7816-4 標準値。moritamori・kopaneet が応答コードとして言及するが、JPKI 固有の一次ソースは `未確認` |
| `63 00` | 暗証番号不一致（残り回数を返さない挙動の可能性） | pin-lock-handling 参照。ISO/IEC 7816-4 標準値。マイナンバーカードで不一致時に `63 00` を返す AP があるかは `未確認` |
| `69 83` | 認証方法がロック | pin-lock-handling 参照。ISO/IEC 7816-4 標準値。JPKI 固有の一次ソースは `未確認` |
| `6A 88` | 参照すべきデータが見つからない（keyref／EF の誤り等） | pin-lock-handling 参照。ISO/IEC 7816-4 標準値。実装バグを疑う（SELECT した AP・EF・keyref を見直す）。JPKI 固有の一次ソースは `未確認` |
| `6A 82` | ファイル/AP が見つからない | AID/EF を確認。ISO/IEC 7816-4 標準値。JPKI 固有の一次ソースは `未確認` |

## 暗証番号の桁数・ロック回数

| 暗証番号 | 桁数 | ロック回数 | 備考 |
|---|---|---|---|
| 署名用 | 6〜16 英数字 | **5（確認済：J-LIS `jpki.go.jp`）** | jpki.go.jp「署名用電子証明書のパスワード（６～１６桁の英数字）は、５回間違えるとロックされます」（procedure/password.html「5回連続で間違って入力した場合、パスワードロックがかかってしまい」）。桁数は zenn.dev/trustdock・tex2e で一致 |
| 利用者証明用 | 4 数字 | **3（確認済：J-LIS `jpki.go.jp`）** | jpki.go.jp「利用者証明用電子証明書のパスワード（４桁の数字）は、３回間違えるとロックされます」（procedure/password.html「3回連続でパスワードを間違って入力した場合、パスワードロックがかかってしまい」）。桁数は zenn.dev/trustdock・tex2e で一致 |
| 券面入力補助用 | 4 数字（※ヘ方式では 4 桁 PIN を使わず照会番号で解錠する経路もある。下記「券面事項確認用」参照） | **3（確認済：`kojinbango-card.go.jp`（マイナンバーカード総合サイト）・マイナポータル FAQ 2385・`services.digital.go.jp`）** | 総合サイト「数字4桁で構成し…3回入力を間違いロックされた場合については、お住まいの市区町村で暗証番号再設定の手続きが必要」。kopaneet・tex2e も「連続3回失敗でロック」。**`33_guide-liquid-ekyc.pdf` p11 の「10回」は 4 桁 PIN でなく 14 桁の照会番号（照合番号B＝下記「券面事項確認用」）の回数を指す。経路が別で矛盾ではない。** 4 桁 PIN の解錠パラメータの keyref は `未確認` |
| 券面事項確認用（照合番号B・14 桁） | 生年月日6＋有効期限（西暦4）＋セキュリティコード4＝14 桁（記憶する固定 PIN でなく券面記載値ベースの照会番号） | **10（確認済：`services.digital.go.jp`・松山市（照合番号B ロック解除ページ）・PocketSign SDK ドキュメント・ITmedia が一致）** | digital.go.jp「入力項目を続けて10回間違えた場合、個人番号カードがロックされます」。松山市「照合番号Bを10回連続して入力を誤るとロック。顔認証に10回連続で失敗した場合もロック」。桁整形・keyref・VERIFY 経路は `未確認` |
| 個人番号用（照合番号A・12 桁） | マイナンバー12桁（記憶する固定 PIN でなく券面記載値ベースの照会番号） | 未確認（照合番号B と同じ「10回」の可能性が高いが、照合番号A のロック回数を明記した一次ソースを確認できず） | digital.go.jp AP構成資料。12桁は券面目視入力の正誤チェック用途。個人番号の利用は番号法別表の事務に限定 |
| （参考）住民基本台帳用 | 4 数字 | 3（1ソースのみ・要検証：練馬区。複数自治体サイトが「3回」と記載） | eKYC では通常使用しない。J-LIS 一次資料は `未確認` |

## 出典

- https://zenn.dev/trustdock/articles/66a228895294bc （TrustDock「公的個人認証（JPKI）入門」）— NFC Type-B、ISO 7816 APDU、署名用 PIN 6〜16 英数字（失敗 5 回）、利用者証明用 4 数字、券面事項入力補助用 PIN 失敗 3 回。AID・APDU の 16 進値の記載なし。
- https://tex2e.github.io/blog/protocol/jpki-mynumbercard-with-apdu （「マイナンバーカードとAPDUで署名データ作成」）— JPKI-AP AID `D3 92 F0 00 26 01 00 00 00 01`、SELECT `00 A4 04 0C` / `00 A4 02 0C`、VERIFY `00 20 00 80`、COMPUTE DIGITAL SIGNATURE `80 2A 00 80`、READ BINARY INS `B0`、EF-ID の例（署名用秘密鍵 `00 1A`、署名用PIN `00 1B`、署名用証明書 `00 01`、認証用＝利用者証明用秘密鍵 `00 17`、認証用＝利用者証明用暗証番号 `00 18`、認証用＝利用者証明用証明書 `00 0A`）、認証用（利用者証明用）でも `80 2A 00 80` を使用（VERIFY 例 `00 20 00 80 04 31 32 33 34` の 4 桁 ASCII）、`80 2A 00 80` へ SHA-256 DigestInfo（RFC 8017 準拠プレフィックス `30 31 30 0D 06 09 60 86 48 01 65 03 04 02 01 05 00 04 20` + 32B。tex2e が `0B` と表記していれば誤植）を Lc=`33` で送る実装例、`SHA256withRSA` / PKCS#1 v1.5、証明書は先頭 4B の長さから全長を求めて READ BINARY を分割、`90 00`。取得日 2026-09-08。
- https://qiita.com/YMarumo/items/fc398f9e64da405e1500 （「マイナンバーカードアプリケーション #NFC」）— HTTP 200 で取得可。4 AP（JPKI-AP・券面事項確認AP・券面入力補助AP・住基AP）の概要のみ。AID・APDU・SW1SW2・暗証番号仕様の具体値は記載なし。
- https://blog.moritamori.net/entry/my-number-card-with-apdu （「APDUプロトコルを通じてマイナンバーカードで電子署名する方法」）— JPKI-AP AID、SELECT `00 A4 04 0C`、VERIFY `00 20 00 80`、COMPUTE DIGITAL SIGNATURE `80 2A 00 80`、SW `63CX` / `6983` を応答コードとして言及。
- https://zenn.dev/kopaneet/articles/1ee74f87eb31d3 （「マイナンバーカードから基本4情報の取得」）— 券面入力補助AP AID `D3 92 10 00 31 00 01 01 04 08`（tex2e と一致）、JPKI-AP AID、EF-ID の例（基本4情報 `00 02`、個人番号 `00 01`、入力補助用PIN `00 11`）、SELECT/VERIFY/READ BINARY の INS、本体は 3 バイト目に長さ・最大 112B・UTF-8、「連続3回失敗でロック」。取得日 2026-09-08。
- https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/68bc86d6-94d7-4fe8-a592-302d78828e1f/d8c514f8/20231102_policies_mynumber_pros-and-safety_outline_01.pdf （デジタル庁「マイナンバーカードのアプリの概要／AP構成」）— 券面AP（＝券面事項確認AP）の用途＝対面での券面記載情報の改ざん検知・本人確認の証跡としての画像利用、記録情報＝表面：4情報＋顔写真の画像／裏面：マイナンバーの画像、アクセスコントロール＝マイナンバー12桁で表と裏、生年月日6桁＋有効期限西暦4桁＋セキュリティコード4桁で表のみ。券面入力補助AP のマイナンバーは「番号法に基づく事務でのみ利用可能」。AID・EF・APDU バイト列の記載はなし。取得日 2026-09-08。
- https://qiita.com/ribig/items/3814cf7f095854ce0e61 （「マイナンバーカードから顔写真データを読み込む #APDU」）— 券面事項確認AP を SELECT・照合後にデータ EF を READ BINARY、外側 TLV `FF 20 82 <長さ2B>`、`DF 21`（ヘッダ）/ `DF 22`（生年月日）/ `DF 23`（性別）/ `DF 24`（公開鍵）/ `DF 27`（顔写真）、顔写真は JPEG2000（先頭 `00 00 0C 6A 50 20 20` 付近／末尾 `FF D9`、モノクロ表示）。AID・EF 識別子・VERIFY keyref の 16 進値は本文から抽出できず。個人ブログ・1ソース・要検証。取得日 2026-09-08。
- https://tex2e.github.io/blog/protocol/jpki-mynumbercard-with-apdu — （上記 JPKI-AP に加え）**券面入力補助AP**: DF 名 `D3 92 10 00 31 00 01 01 04 08`、券面入力補助用PIN EF `00 11`、基本4情報 EF `00 02`、個人番号 EF `00 01`、VERIFY `00 20 00 80 04 31 32 33 34`（4 桁 PIN 例）、READ BINARY `00 B0 00 02 01`（長さ）→ `00 B0 00 00 71`（本体）、TLV `FF 20` / `DF 21`〜`DF 25`、性別 `31`=男/`32`=女/`33`=その他、氏名・住所は UTF-8、2023 年頃発行分は先頭に余分 2B。取得日 2026-09-08。

- https://www.jpki.go.jp/procedure/password.html （J-LIS「公的個人認証サービス ポータルサイト」— 電子証明書のパスワードをロック／失念した場合の解除方法。署名用は「5回連続」でロック、利用者証明用は「3回連続」でロック。ロック解除は (a) もう一方のパスワードが使えればスマートフォンアプリ＋コンビニのキオスク端末で初期化、(b) マイナンバーカードを持参して住民票のある市区町村窓口で再設定。郵送・オンライン不可。HTTP 200。取得日 2026-09-08）
- https://www.jpki.go.jp/ （J-LIS ポータルトップ — 利用者証明用（4桁）は3回、署名用（6〜16桁 英数字）は5回でロック。ロック解除はスマホアプリ＋コンビニのキオスク端末での初期化・再設定、または市区町村窓口での再設定。HTTP 200。取得日 2026-09-08）
- https://www.kojinbango-card.go.jp/faq_pin2/ （マイナンバーカード総合サイト FAQ「券面事項入力補助アプリの暗証番号とは何ですか？」— 数字4桁。3回入力を間違いロックされた場合は市区町村で暗証番号再設定の手続きが必要。HTTP 200。取得日 2026-09-08）
- https://services.digital.go.jp/mynumbercard/info-passcode/ （デジタル庁「マイナンバーカードの券面事項入力補助用暗証番号」— 券面入力補助用暗証番号は数字4桁・3回でロック。券面AP読み取りの照会番号は生年月日6＋有効期限西暦4＋セキュリティコード4の14桁で、続けて10回間違えるとカードがロック。HTTP 200。取得日 2026-09-08）
- https://www.city.matsuyama.ehime.jp/kurashi/tetsuzuki/mynumberseido/syo-go-bango.html （松山市「照合番号Bのロック解除」— 照合番号B（券面記載の14桁）を10回連続で誤入力するとロック。顔認証10回連続失敗でもロック。解除は市区町村窓口にマイナンバーカードを持参。HTTP 200。取得日 2026-09-08）
- https://docs.p8n.app/docs/verify-cardinfo/guide/sdk/pin-number/mynacard （PocketSign 券面事項 SDK ドキュメント— 券面事項入力補助用暗証番号（4桁）の試行可能回数は3回、照合番号B（14桁）の試行可能回数は10回。時間経過でリセットされず、照合成功時のみ初期値に戻る。ロック時は市区町村窓口で初期化。ベンダー資料・要検証。取得日 2026-09-08）
- https://www.city.nerima.tokyo.jp/kurashi/mynumber/mynumber_card/ansho/shokika_kohteki.html （練馬区「暗証番号の初期化・再設定（ロックの解除）」— 署名用5回／利用者証明用3回／住民基本台帳用3回／券面事項入力補助用3回でロック。解除は区民事務所窓口、郵便・インターネット不可。自治体資料。取得日 2026-09-08）
- ekyc-jp/references/pdfs/06_certificate-expiry-what-to-do.pdf （J-LIS「電子証明書が失効する場合とその対応」— 失効事由と失効理由コード（affiliationChanged / cessationOfOperation / superseded / certificateHold）。暗証番号ロック回数の記載はなし）

## 未確認事項

- 全 AP の AID 実値。券面入力補助AP AID `D3 92 10 00 31 00 01 01 04 08` は kopaneet・tex2e の 2 個人ブログで一致するが J-LIS 一次資料は未確認、券面事項確認AP・住基AP は公開ソースで確認できず。
- VERIFY の keyref：JPKI-AP は P2=`80` で複数ソース一致だが、券面入力補助AP・券面事項確認AP・住基AP・個人番号用の keyref は未確認。
- COMPUTE DIGITAL SIGNATURE の入力形式（DigestInfo / 生ハッシュ / パディングの要否）と署名前に必要な MSE（Manage Security Environment）等の前処理。tex2e が具体的な DigestInfo バイト列（SHA-256 プレフィックス + 32B、Lc=`33`）と「MSE 不要」を示すが、依然 tex2e 1 ソースのみ。署名アルゴリズム（RSA-2048 / PKCS#1 v1.5 / SHA-256）の現行仕様・他ハッシュ対応も要検証。
- EF-ID の網羅リスト（各 AP の証明書・PIN・データファイルの識別子）。利用者証明用（認証用）の秘密鍵 `00 17`・暗証番号 `00 18` は tex2e 1 ソースのみ。
- 利用者証明用のチャレンジレスポンス（当人認証）を COMPUTE DIGITAL SIGNATURE `80 2A 00 80` で行うか、INTERNAL AUTHENTICATE（`00 88 …`）等の別コマンドか。tex2e は認証用でも `80 2A 00 80` を示すが 1 ソースのみ。サーバーのチャレンジ（nonce）をそのまま署名するか DigestInfo でラップするかも要検証。
- 発行番号（利用者証明用電子証明書のシリアル相当）が証明書のどのフィールド（X.509 serialNumber / 独自拡張）に入るか、専用 EF から読めるか。公開ソースでは証明書 DER をパースして取得する前提。
- SW1SW2 の JPKI 固有の一次ソース。`63 CX` `69 83` `6A 82` は ISO/IEC 7816-4 標準値であり、マイナンバーカードの実挙動（特に `63 CX` の X が残り試行回数か）は要検証。
- 各暗証番号のロック回数：署名用 5 回・利用者証明用 3 回は J-LIS `jpki.go.jp` で **確認済**。券面入力補助用（4 桁 PIN）3 回は `kojinbango-card.go.jp`（総合サイト）・マイナポータル FAQ・`services.digital.go.jp` で **確認済**。券面事項確認用の照合番号B（14 桁）10 回は `services.digital.go.jp`・松山市・PocketSign・ITmedia の複数一致で **確認済**。**`33_guide-liquid-ekyc.pdf` p11 の「10回」は 4 桁 PIN でなく 14 桁の照合番号Bを指すと判明し、矛盾は解消。** 未確認で残るのは照合番号A（マイナンバー12桁・個人番号用）のロック回数と、SW1SW2 の JPKI 固有一次ソース。
- 券面入力補助AP の基本4情報 TLV レイアウト（`FF 20` 外側、`DF 21`〜`DF 25` の各タグ・長さ・全長・READ 終了条件・最大長・発行年差異）。tex2e 1 ソースのみ。
- ヘ方式の解錠情報（生年月日6＋有効期限4＋セキュリティコード4 の 14 桁）の桁整形・連結方法・VERIFY keyref（P2）・Lc・対象 EF。公開ソースは 4 桁 PIN の VERIFY 例しか示さない。
- 券面入力補助用 PIN の解錠手続き（生年月日 6 桁 + 有効期限 4 桁 + セキュリティコード 4 桁という構成の正否とバイト順）。
- 券面事項確認AP のアクセスに使う照合番号A（マイナンバー12桁）のロック回数。照合番号B（14桁）は10回で確認済だが、照合番号A を明記した一次ソースは未確認（同じ10回の可能性が高い）。別に記憶する固定 PIN が存在するか（照会番号ベースのみか）も J-LIS 一次資料で未確認。
- 券面事項確認AP の EF レイアウトと TLV（外側 `FF 20`、`DF 21`〜`DF 27` 等の各タグ・長さ・全長・READ 終了条件）。qiita.com/ribig 1ソースのみ。券面入力補助AP の `DF 21`〜`DF 25` とタグ割当が異なる点も要検証。
- 券面事項確認AP の顔写真の画像形式（JPEG2000／グレースケールとの報告は qiita.com/ribig 1ソースのみ）、解像度・色深度・監修ヘッダの有無。
