# 用語集（yougoshuu）

最終確認日: 2026-09-08

> このファイルは `ekyc-jp` プラグインの全スキル共通の用語リファレンスです。
> 全19スキルが出そろった段階で各スキルに実際に登場する用語を追補済み。
> 本人確認方法の**名称・記号・時期**（ホ／ヘ／カ／ル 等、施行日）は
> `references/method-map.md` と `skills/honnin-kakunin-houhou/SKILL.md` を唯一の典拠とし、
> 本ファイルでは断定しません（method-map.md の表現に合わせています）。
> 暗証番号の桁数・ロック回数・AID 等の精緻な値は各スキル
> （`pin-lock-handling` / `references/apdu-cheatsheet.md` 等）を参照してください。

| 用語 | 読み | 説明 | 関連スキル |
|---|---|---|---|
| 公的個人認証サービス | こうてきこじんにんしょうサービス | マイナンバーカードのICチップの電子証明書を用いた本人認証・改ざん検知の公的サービス。英語 JPKI。 | jpki-overview |
| 署名用電子証明書 | しょめいようでんししょうめいしょ | 文書に電子署名するための証明書。基本4情報を含む。暗証番号6〜16桁。 | jpki-ap-shomei, signature-verification |
| 利用者証明用電子証明書 | りようしゃしょうめいようでんししょうめいしょ | ログイン等の当人認証用。基本4情報を含まない。暗証番号4桁。 | jpki-ap-riyousha |
| 基本4情報 | きほんよんじょうほう | 氏名・住所・生年月日・性別。 | kihon-4-jouhou-doui |
| 券面入力補助AP | けんめんにゅうりょくほじょAP | 券面記載事項の入力補助用アプリ。生年月日+有効期限+セキュリティコードで解錠。 | kenmen-nyuryoku-hojo-ap |
| 券面事項確認AP | けんめんじこうかくにんAP | 券面画像・顔写真・個人番号を取得するアプリ。 | kenmen-jikou-kakunin-ap |
| 失効 | しっこう | 証明書が有効性を失うこと（有効期限切れ・引越し・改氏名・死亡等）。 | jlis-yukousei-kakunin |
| 主務大臣認定 | しゅむだいじんにんてい | 署名検証を自ら行う事業者が受ける必要のある認定。 | platform-jigyousha |
| プラットフォーム事業者 | プラットフォームじぎょうしゃ | 認定を受け、他事業者に有効性確認機能を提供する事業者。PF事業者。 | platform-jigyousha |
| サービスプロバイダ事業者 | サービスプロバイダじぎょうしゃ | 署名検証をPF事業者に委託して利用する事業者。SP事業者。 | platform-jigyousha |
| J-LIS | ジェイリス | 地方公共団体情報システム機構。証明書の発行者・トラストアンカー。 | jpki-overview, jlis-yukousei-kakunin |
| CRL | シーアールエル | 失効リスト。1日1回程度更新。オフライン照合可。 | jlis-yukousei-kakunin |
| OCSP | オーシーエスピー | 証明書の有効性を個別・リアルタイムに問い合わせるプロトコル。 | jlis-yukousei-kakunin |
| 犯収法 | はんしゅうほう | 犯罪による収益の移転防止に関する法律。 | honnin-kakunin-houhou |
| カ方式 | カほうしき | JPKI署名用電子証明書を用いた身元確認方法（現行の犯収法施行規則第6条第1項第1号カ、2027年4月以降は新ヌ）。特定事業者が署名検証者である場合に限る（但書）。※号記号・時期は `method-map.md` / `hourei-eKYC.md` を典拠とする。 | honnin-kakunin-houhou |
| ヘ方式 | ヘほうしき | 本人確認書類のIC読取＋容貌撮影。※号記号・時期は `method-map.md` を典拠とする。 | honnin-kakunin-houhou, kenmen-nyuryoku-hojo-ap |
| ル方式 | ルほうしき | カード代替電磁的記録（Apple Wallet 等）を用いた方法。※号記号・時期は `method-map.md` を典拠とする。 | honnin-kakunin-houhou |
| 転送不要郵便 | てんそうふようゆうびん | 転送を認めない郵便。住所実在確認に用いる。 | honnin-kakunin-houhou |
| APDU | エーピーディーユー | ICカードとの通信単位（ISO 7816）。 | ios-corenfc-apdu |
| AID | エーアイディー | アプリケーション識別子。SELECT で指定。 | ios-corenfc-apdu, apdu-cheatsheet |
| SW1SW2 | エスダブリューいちにー | APDU レスポンスのステータスワード。`90 00`=正常。 | pin-lock-handling |
| 同意情報 | どういじょうほう | 最新4情報提供に関する本人の同意の記録。有効期間10年。 | doui-jouhou-kanri |
| 有効期限 | ゆうこうきげん | マイナンバーカード本体・電子証明書の有効期限。券面入力補助APの解錠要素の一つ。カード本体と電子証明書で期限が異なり、電子証明書は基本4情報に変更がなくても期限到来で失効する。具体的な年数・起算は kenmen-nyuryoku-hojo-ap / jlis-yukousei-kakunin 参照。 | kenmen-nyuryoku-hojo-ap, jlis-yukousei-kakunin |
| セキュリティコード | セキュリティコード | 券面入力補助APの解錠に用いる、券面に記載された数字コード。桁数・記載位置の詳細は kenmen-nyuryoku-hojo-ap 参照。 | kenmen-nyuryoku-hojo-ap |
| 発行番号 | はっこうばんごう | 電子証明書ごとに付与される識別番号。J-LIS が CRL・OCSP で失効照合に用いる。 | jlis-yukousei-kakunin, signature-verification |
| 電子署名法第3条 | でんししょめいほうだいさんじょう | 電子署名及び認証業務に関する法律第3条（電磁的記録の真正な成立の推定）。本人による一定要件を満たす電子署名が行われた電磁的記録は、真正に成立したものと推定される。署名用電子証明書による電子署名はこの対象となり得る。 | signature-verification, jpki-ap-shomei |
| 外字 | がいじ | 氏名・住所に用いられる、標準文字コードで表現できない文字。券面事項確認AP・ヘ方式では外字を画像として取得する。 | kenmen-jikou-kakunin-ap |
| 旧氏 | きゅううじ | 婚姻等の前の氏。本人の申請によりマイナンバーカードに併記でき、券面・氏名表記の照合に影響する。 | kihon-4-jouhou-doui, kenmen-jikou-kakunin-ap |
| ふりがな | ふりがな | 氏名の読み仮名。戸籍法改正により戸籍・マイナンバーカードに記載されるようになった。照合時は表記揺れの正規化に注意。施行時期等の詳細は kihon-4-jouhou-doui 参照。 | kihon-4-jouhou-doui |
| 国外転出 | こくがいてんしゅつ | 国外への転出。制度改正により、国外転出者もマイナンバーカード・電子証明書を継続利用できるようになった。失効条件・利用可否の詳細は jlis-yukousei-kakunin 参照。 | jlis-yukousei-kakunin |
| 券面事項確認用暗証番号 | けんめんじこうかくにんようあんしょうばんごう | 券面事項確認APで券面記載事項（券面画像・顔写真等）を読み出す際に用いる暗証番号。桁数・ロック回数の詳細は pin-lock-handling / kenmen-jikou-kakunin-ap 参照。 | kenmen-jikou-kakunin-ap, pin-lock-handling |
| 個人番号用暗証番号 | こじんばんごうようあんしょうばんごう | 券面事項確認APで個人番号（マイナンバー）を読み出す際に用いる暗証番号。桁数・ロック回数の詳細は kenmen-jikou-kakunin-ap / pin-lock-handling 参照。 | kenmen-jikou-kakunin-ap, pin-lock-handling |
| デジタル認証アプリ | デジタルにんしょうアプリ | デジタル庁が提供する、マイナンバーカードの電子証明書を用いた認証・基本4情報取得のための公式アプリおよびAPI。 | ekyc-jp, jpki-overview |
| マイナアプリ | マイナアプリ | マイナポータル等にアクセスするためのスマートフォン向け公式アプリの通称。名称・機能の再編が進行しているため、正式名称は各時点の一次情報で確認する。 | ekyc-jp |
| App Clip | アップクリップ | iOSでアプリ本体をインストールせずに一部機能を起動できる仕組み。eKYCフローの軽量な導線に用いられることがある（NFC読取の可否など制約に注意）。 | ios-nfc-ux-errors, ekyc-session-orchestration |
| NFCTagReaderSession | エヌエフシータグリーダーセッション | iOS CoreNFCで ISO 7816 等のICカードと APDU 通信するための API クラス。マイナンバーカード読取に使用する。 | ios-corenfc-apdu, ios-nfc-ux-errors |
| PKCS#1 | ピーケーシーエスワンまたはピーケーシーエスいち | RSA 暗号の鍵・署名フォーマットに関する標準（RFC 8017）。JPKI の電子署名検証で用いられる。 | signature-verification, ios-security |
| 個人番号 | こじんばんごう | マイナンバー。12桁。JPKI の認証では利用しないが、券面事項確認APで取得できる。 | kenmen-jikou-kakunin-ap |
| 住基AP | じゅうきエーピー | マイナンバーカードの住民基本台帳アプリケーション。住民基本台帳ネットワーク関連の本人確認等に用いる。 | mynumber-card-ic |
| 電子署名 | でんししょめい | 電磁的記録に対して行う、作成者本人性と非改ざん性を確認できる措置。署名用電子証明書と対応する秘密鍵で生成する。 | jpki-ap-shomei, signature-verification |
| 表記揺れ | ひょうきゆれ | 同一の氏名・住所が複数の表記で現れる現象（旧字・新字、丁目・番地表記の差異等）。基本4情報の照合時に正規化が必要。 | kihon-4-jouhou-doui |
| トラストアンカー | トラストアンカー | 証明書チェーンにおける信頼の基点。JPKIでは電子証明書の発行者である J-LIS が該当する。 | jpki-overview, signature-verification |
| 有効性確認 | ゆうこうせいかくにん | 顧客から提供された電子証明書が失効していないことを J-LIS（CRL提供方式／OCSPレスポンダ方式）で確認すること。 | jlis-yukousei-kakunin, platform-jigyousha |
| 当人認証 | とうにんにんしょう | 認証を行っている者が、その電子証明書の正当な保持者本人であることの確認。主に利用者証明用電子証明書が担う。 | jpki-ap-riyousha, honnin-kakunin-houhou |
| 身元確認 | みもとかくにん | 実在する人物であり、かつ申込者がその人物本人であることの確認。犯収法の取引時確認等で求められる。 | honnin-kakunin-houhou |
| セルフィー | セルフィー | 本人の容貌をその場で撮影した画像。書類撮影方式では本人確認書類の顔写真と照合する。 | honnin-kakunin-houhou |
| ライブネス | ライブネス | 撮影対象が写真・動画・マスク等ではなく実在の生体であることの検知。なりすまし対策。 | honnin-kakunin-houhou, ekyc-session-orchestration |
| インジェクション攻撃 | インジェクションこうげき | カメラ入力や通信経路に偽の映像・データを注入するなりすまし攻撃。ライブネス・NFC読取の双方で対策が必要。 | ios-security, honnin-kakunin-houhou |
| スマホ用電子証明書 | スマホようでんししょうめいしょ | マイナンバーカードの電子証明書の機能をスマートフォンに搭載したもの。2023年5月11日開始（jpki-introduction.ja.md）。 | jpki-overview, ekyc-jp |
| マイナンバーカード対面確認アプリ | マイナンバーカードたいめんかくにんアプリ | デジタル庁が提供する、券面事項の真正性を対面で確認するためのアプリ。 | mynumber-card-ic |
| PIN | ピン | 暗証番号。マイナンバーカードには用途別に複数の暗証番号があり、一定回数連続で誤入力すると閉塞（ロック）する。回数・解除方法は pin-lock-handling 参照。 | pin-lock-handling |
| 閉塞 | へいそく | 暗証番号の連続誤入力によりAPが使用不能になった状態。解除・再設定には市区町村窓口等での手続きが必要。 | pin-lock-handling, ios-nfc-ux-errors |
| ISO/IEC 7816-4 | アイエスオーななはちいちろくのよん | APDU コマンド・レスポンスの構造を定める国際規格。 | ios-corenfc-apdu |
| ISO/IEC 14443 | アイエスオーいちよんよんよんさん | 近接型ICカードの無線通信規格（Type A / Type B）。マイナンバーカードは Type B（詳細は apdu-cheatsheet.md / ios-corenfc-apdu 参照）。 | ios-corenfc-apdu, ios-nfc-ux-errors |
| SELECT FILE | セレクトファイル | APDUで AP（AID指定）や EF を選択するコマンド。 | ios-corenfc-apdu |
| VERIFY | ベリファイ | APDUで暗証番号（PIN）を照合するコマンド。誤入力時は残り試行回数がステータスワードで返るとされる（例: `63 CX`。JPKI 固有の挙動は要検証。詳細は apdu-cheatsheet.md / ios-corenfc-apdu 参照）。 | pin-lock-handling, ios-corenfc-apdu |
| COMPUTE DIGITAL SIGNATURE | コンピュートデジタルシグネチャ | ICカード内の秘密鍵で署名値を生成させる APDU コマンド。 | jpki-ap-shomei, ios-corenfc-apdu |
| 最新の利用者情報（4情報）提供サービス | さいしんのりようしゃじょうほうよんじょうほうていきょうサービス | 本人同意に基づき、J-LIS が最新の基本4情報をオンラインで提供するサービス。2023年5月16日開始（jpki-introduction.ja.md）。 | doui-jouhou-kanri, kihon-4-jouhou-doui |
| 本人同意の取得支援サービス | ほんにんどういのしゅとくしえんサービス | マイナポータルを活用し、4情報提供サービスに必要な本人同意を取得するデジタル庁のサービス。2024年10月29日開始（jpki-introduction.ja.md）。 | doui-jouhou-kanri |
| 一次資料 | いちしりょう | 法令本文や官公庁が発行する原典（e-Gov・警察庁 JAFIC・総務省・金融庁・デジタル庁等）。ベンダー資料等の二次情報と区別し、実装・法務判断は一次資料で確認する。 | sources-refresh |
| Face ID / Touch ID | フェイスアイディー／タッチアイディー | iPhone の生体認証。スマートフォンに搭載したマイナンバーカードを用いる方法（ル方式）で当人認証に用いる。 | honnin-kakunin-houhou, ios-security |
| 照会番号 | しょうかいばんごう | 券面事項確認APで個人番号等を読み出す際に入力する番号（住民票の写し等に記載）。 | kenmen-jikou-kakunin-ap |
| 公開鍵暗号方式 | こうかいかぎあんごうほうしき | 暗号化と復号で異なる2つの鍵（秘密鍵・公開鍵）を用いる方式。JPKI の通信・署名の基盤。秘密鍵はマイナンバーカードのICチップ内に保持される。 | signature-verification, ios-security |
| 電子証明書検証手数料 | でんししょうめいしょけんしょうてすうりょう | PF事業者が J-LIS に支払う、有効性確認の件数に応じた従量課金の手数料（当面無料の措置あり）。 | platform-jigyousha, jlis-yukousei-kakunin |
| 照合番号A | しょうごうばんごうエー | 券面事項確認APで個人番号（マイナンバー）側を読み出す際に用いる、券面記載のマイナンバー12桁ベースの照合値。ロック回数は一次資料で未確認（詳細は apdu-cheatsheet.md 参照）。 | kenmen-jikou-kakunin-ap |
| 照合番号B | しょうごうばんごうビー | 券面事項確認APで表面情報を読み出す際に用いる、生年月日6＋有効期限（西暦4）＋セキュリティコード4の14桁ベースの照合値。桁整形・VERIFY 経路は未確認（詳細は apdu-cheatsheet.md 参照）。 | kenmen-jikou-kakunin-ap |
| リプレイ攻撃 | リプレイこうげき | 過去に正当だった署名・レスポンスを再送してなりすます攻撃。nonce の一回性・有効期限で防ぐ。 | ekyc-session-orchestration, jpki-ap-riyousha |
| 中継攻撃 | ちゅうけいこうげき | リレー攻撃。被害者のカード読取と署名を攻撃者が中継し、別セッションで悪用する攻撃。セッション束縛・時刻制約で対策する。 | ekyc-session-orchestration |
| nonce | ノンス | サーバーが発行する一回限りの乱数。チャレンジレスポンスや署名対象に含めてリプレイを防ぐ。 | ekyc-session-orchestration, jpki-ap-riyousha |
| チャレンジレスポンス | チャレンジレスポンス | サーバーが与えたチャレンジ（nonce）にカード内秘密鍵で署名させ、対応する証明書で検証する当人認証方式。 | jpki-ap-riyousha, ekyc-session-orchestration |
| 証明書チェーン | しょうめいしょチェーン | エンドエンティティ証明書からトラストアンカーまでの検証経路。JPKI では自己署名の単一階層 CA（詳細は signature-verification 参照）。 | signature-verification |
| 証明書ピンニング | しょうめいしょピンニング | 通信先・検証対象の証明書や公開鍵をアプリに埋め込み、想定外の証明書を拒否する対策。 | ios-security, signature-verification |
| Keychain | キーチェーン | iOS の資格情報保管領域。カード由来データや鍵の一時保管に用い、保護属性を適切に設定する。 | ios-security |
| Secure Enclave | セキュアエンクレーブ | Apple デバイスの分離されたセキュリティ用サブシステム。鍵の生成・保管に用いる。 | ios-security |
| READ BINARY | リードバイナリ | 選択中の EF の内容を読み出す APDU コマンド。長い証明書等はオフセットを進めて分割読み出しする。 | ios-corenfc-apdu, jpki-ap-shomei |
| TLV | ティーエルブイ | Tag-Length-Value。ICカード内データの構造化表現。券面系 AP のデータ解析で用いる。詳細タグは apdu-cheatsheet.md 参照。 | kenmen-nyuryoku-hojo-ap, kenmen-jikou-kakunin-ap |
| DigestInfo | ダイジェストインフォ | ハッシュ値に ASN.1 のアルゴリズム識別子を付与した DER 構造（RFC 8017）。COMPUTE DIGITAL SIGNATURE への入力形式として公開実装例で用いられる（要検証。詳細は apdu-cheatsheet.md 参照）。 | jpki-ap-shomei, signature-verification |
| keyref | キーレファレンス | VERIFY 等で対象の暗証番号・鍵を指定する参照値（P2 等）。JPKI-AP 以外の keyref は未確認（apdu-cheatsheet.md 参照）。 | ios-corenfc-apdu, pin-lock-handling |
| certificatePolicies | サーティフィケートポリシーズ | X.509 証明書の拡張。証明書の種別を示すポリシー OID を格納する。JPKI の具体的な OID 値は一次資料で未確認（signature-verification 参照）。 | signature-verification |
| 取引時確認 | とりひきじかくにん | 犯収法上、特定事業者が特定取引を行う際に必要な、本人特定事項等の確認。 | honnin-kakunin-houhou |
| 特定取引 | とくていとりひき | 犯収法で取引時確認が義務付けられる取引（預貯金口座開設、10万円超の現金振込等）。 | honnin-kakunin-houhou |
| 携帯法 | けいたいほう | 携帯電話不正利用防止法（正式名称は携帯音声通信事業者による契約者等の本人確認等…）。契約時等の本人確認方法を定める。改正施行規則は2026年4月1日施行済み（第3条第1項第1号イ〜ヌ、書類画像送信方式は消滅。`method-map.md` / `hourei-eKYC.md` 参照）。 | honnin-kakunin-houhou |
| 古物営業法 | こぶつえいぎょうほう | 古物商が古物の買受け等の際に相手方の住所・氏名・職業・年齢を確認する義務（本法第15条第1項）。確認方法（施行規則第15条第3項の各号）と犯収法方法との対応は method-map.md「古物営業法」を参照（一次条文は hourei-eKYC.md §5）。 | honnin-kakunin-houhou |
| 番号法 | ばんごうほう | マイナンバー法（行政手続における特定の個人を識別するための番号の利用等に関する法律）。個人番号の収集・利用・本人確認を規律する。 | kenmen-jikou-kakunin-ap, kihon-4-jouhou-doui |
| 通称 | つうしょう | 住民票に記載された、氏名以外の呼称（主に外国人住民）。券面・4情報の照合で表記の扱いに注意する。 | kenmen-jikou-kakunin-ap, kihon-4-jouhou-doui |
| JPEG2000 | ジェイペグにせん | 券面事項確認APの顔写真データに用いられるとされる画像圧縮形式（1ソースのみ・要検証。apdu-cheatsheet.md 参照）。 | kenmen-jikou-kakunin-ap |
| App Transport Security | アップトランスポートセキュリティ | iOS の HTTPS 通信を強制する仕組み（ATS）。eKYC のサーバー通信では例外を作らない。 | ios-security |
| 顔認証 | かおにんしょう | 券面事項確認APの利用時や書類撮影方式で、容貌画像と登録顔写真を照合する処理。連続失敗でカードがロックする経路もある（pin-lock-handling 参照）。 | kenmen-jikou-kakunin-ap, honnin-kakunin-houhou |

## 出典

本用語集は本プラグインの派生リファレンスであり、各用語の定義は下記に基づく。値・手続きの一次記録は各スキルおよび下記を参照する。

- `references/method-map.md`（本人確認方法の名称・記号・施行時期の唯一の典拠）
- `references/apdu-cheatsheet.md`（AID・APDU・SW1SW2・暗証番号の桁数／ロック回数と各値の確度）
- `references/jpki-introduction.ja.md`（JPKI の仕組み・電子証明書の種類・有効性確認・機能拡充。デジタル庁「公的個人認証サービス（JPKI）」）
- <https://www.jpki.go.jp/>（J-LIS「公的個人認証サービス ポータルサイト」— JPKI・電子証明書・暗証番号の一般的説明）
