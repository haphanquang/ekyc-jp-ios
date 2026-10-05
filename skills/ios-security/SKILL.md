---
name: ios-security
description: iOS eKYC セキュリティ の実装リファレンス。マイナンバーカードから読み取ったデータ（基本4情報・顔写真・個人番号・署名値・暗証番号）の端末内での取り扱いを扱う。秘密鍵は IC チップから出ない／読み取りデータはメモリ上のみで保持しサーバー送信後に消去／TLS 1.2+ と App Transport Security／eKYC サーバーへの証明書ピンニング・公開鍵ピンニング／暗証番号・チャレンジハッシュ・署名値・個人番号・顔写真をログに残さない（PIN のログ禁止・分析／クラッシュレポート含む）／Keychain 保存の可否／個人番号の保護（保存時暗号化・目的終了後の削除）／PIN 入力画面とカードデータ表示画面のスクリーンショット・画面収録対策／端末の健全性チェック（任意）／NFC・カメラの権限文言。サーバー側のなりすまし・カメラインジェクション・リプレイ対策は ekyc-session-orchestration。
---

# iOS 端末でのカードデータとセキュリティの取り扱い

マイナンバーカードの eKYC を iOS アプリで実装するときに、**端末側で守るべきセキュリティ規則**のリファレンス。APDU の送受信は `ios-corenfc-apdu`、署名生成の手順は `jpki-ap-shomei`、当人認証は `jpki-ap-riyousha`、個人番号の番号法（マイナンバー法）上の扱いは `kenmen-jikou-kakunin-ap`、暗証番号ロックの UX は `pin-lock-handling` を参照。

端末側で電子署名の検証・J-LIS への照会はしない（サーバー／プラットフォーム事業者の責務）。サーバー側の不正検知（なりすまし・カメラインジェクション・リプレイ）は `ekyc-session-orchestration` に委ねる。犯収法上の方法名・号記号・施行時期はここで断定しない（`honnin-kakunin-houhou` / `references/method-map.md`）。

## このスキルを使う場面

- カードから読み取った基本4情報・顔写真・個人番号・署名値や暗証番号入力を、端末内でどう扱う／扱わないかを決めるとき
- eKYC サーバーとの通信に TLS・証明書／公開鍵ピンニング・App Transport Security を設定するとき
- ログ・分析・クラッシュレポートに出してよい項目とダメな項目を切り分けるとき
- 一時データを Keychain / Secure Enclave に置く条件と、置いてはいけない保存先を確認するとき
- PIN 入力・カードデータ表示画面のスクリーンショット／画面収録対策を実装するとき
- 脱獄検知や NFC・カメラ権限の扱いを決めるとき

## 原則

### 秘密鍵は IC チップから出ない

- マイナンバーカードの利用者証明用・署名用の秘密鍵は IC チップ内で生成・保管され、チップ外へエクスポートする API は存在しない。アプリが行うのは「チップに署名・認証を計算させる」ことだけ（`jpki-ap-shomei` / `jpki-ap-riyousha`）。
- 鍵を「取り出す」「複製する」実装を試みない。設計レビューでそうした要求が出たら誤解として正す。

### カードデータは揮発

- **暗証番号はカードへの VERIFY APDU にだけ渡す。** サーバー・分析 SDK・ログ・ペーストボードへ一切送らない。Keychain（生体認証で保護した「暗証番号を記憶する」機能を含む）・UserDefaults・ファイルに保存しない。入力欄は `isSecureTextEntry`、VERIFY の応答を受けたら即破棄する。暗証番号をサーバーへ送る設計・保存する設計が出たら誤りとして正す。
- カードから読み取る基本4情報・顔写真画像・個人番号・チャレンジ／署名対象データ・署名値は、**サーバーへ送るための一時データ**（暗証番号は上記のとおり送らない）。`Data` / `String` で保持し、サーバー送信（またはセッション終了）直後に破棄する。
- 保持は 1 リクエストの範囲に限定する。リトライ時は再度カードから読み直す。
- 可能なら固定長バッファ（`[UInt8]`）で受け、使用後にゼロ埋めしてから解放する。ただし Swift の `String` / `Data` はコピーが分散しうるため、ゼロ化は完全な保証にならない。最優先は「そもそも保存しない・ログに出さない」。

```swift
final class SensitivePayload {
    private(set) var bytes: [UInt8]
    init(_ bytes: [UInt8]) { self.bytes = bytes }

    /// サーバー送信後に必ず呼ぶ
    func wipe() {
        bytes.withUnsafeMutableBytes { buf in
            guard let base = buf.baseAddress else { return }
            memset_s(base, buf.count, 0, buf.count)   // C11 Annex K。最適化で消えない
        }
        bytes.removeAll(keepingCapacity: false)
    }
    deinit { wipe() }
}
```

## 通信（TLS とピンニング）

- **App Transport Security を弱めない。** eKYC サーバー向けに `NSAllowsArbitraryLoads` / `NSExceptionAllowsInsecureHTTPLoads` / `NSExceptionMinimumTLSVersion` を下げる設定を入れない。ATS は既定で TLS 1.2 以上・Perfect Forward Secrecy（ECDHE）・SHA-256 以上・RSA 2048bit / ECC 256bit 以上を要求する。
- eKYC サーバーには**証明書ピンニングまたは公開鍵（SPKI）ピンニング**を行う。公開鍵ピンニングのほうが証明書の定期更新に強い。緊急ローテーション用のバックアップ鍵も併せてピンする。
- **宣言的ピンニング（iOS 14+）**: `Info.plist` の `NSAppTransportSecurity > NSPinnedDomains > <ドメイン> > NSPinnedCAIdentities`（または `NSPinnedLeafIdentities`）に `SPKI-SHA256-BASE64` を列挙する。`NSIncludesSubdomains` も指定可。宣言的ピンニングは ATS の他要件を置き換えない。
- **コードでのピンニング**: `URLSessionDelegate` の `urlSession(_:didReceive:completionHandler:)` で、標準のチェーン検証（`SecTrustEvaluateWithError`）を通したうえでサーバー証明書／公開鍵が固定値と一致するか検証する。不一致なら接続を拒否する（緩いフォールバックを作らない）。

```swift
import CryptoKit   // SHA256
import Security     // SecTrust*, SecCertificate*

func urlSession(_ session: URLSession,
                didReceive challenge: URLAuthenticationChallenge,
                completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
          let trust = challenge.protectionSpace.serverTrust else {
        completionHandler(.cancelAuthenticationChallenge, nil); return
    }
    var error: CFError?
    guard SecTrustEvaluateWithError(trust, &error) else {                 // 標準のチェーン検証
        completionHandler(.cancelAuthenticationChallenge, nil); return
    }
    guard let chain = SecTrustCopyCertificateChain(trust) as? [SecCertificate],  // iOS 15+
          let leaf = chain.first else {
        completionHandler(.cancelAuthenticationChallenge, nil); return
    }
    let der = SecCertificateCopyData(leaf) as Data
    guard Self.pinnedLeafSHA256.contains(Data(SHA256.hash(data: der))) else {
        completionHandler(.cancelAuthenticationChallenge, nil); return       // ピン不一致は即拒否
    }
    completionHandler(.useCredential, URLCredential(trust: trust))
}
```

## ログに残してはいけない項目

アプリログ・`os_log` / `Logger`・分析イベント・クラッシュレポーター（Crashlytics 等）のブレッドクラム／カスタムキーに、次を**平文で出さない**。

- [ ] 暗証番号（利用者証明用 4桁・署名用 6〜16桁英数字・券面系の照会番号）
- [ ] サーバーから受け取ったチャレンジ／署名対象ハッシュ
- [ ] 生成した電子署名値
- [ ] 個人番号（マイナンバー 12桁）
- [ ] 顔写真画像・券面イメージ・カメラで撮影した容貌画像
- [ ] 基本4情報（氏名・住所・生年月日・性別）の平文
- [ ] 上記を含む APDU の生バイト列・HTTP リクエスト／レスポンスボディ

そのうえで:

- `os_log` / `Logger`: 動的文字列・オブジェクトは既定で `<private>` に伏せられ、整数・浮動小数点・真偽値は伏せられない。上記の値に**絶対に `privacy: .public`（旧 API の `%{public}`）を付けない**。相関だけ取りたいときは `privacy: .private(mask: .hash)`。
- `print` / `NSLog` はリリースビルドで無効化する。ネットワークデバッグプロキシの出力もオフにする。

```swift
logger.info("JPKI 署名を送信: session=\(sessionID, privacy: .public) len=\(sig.count, privacy: .public)")
// 署名値そのもの・暗証番号・ハッシュ・個人番号・顔写真は出さない
```

## ローカル保存

**原則、端末に残さない**（即時送信できるなら保存しない）。どうしても一時保持が必要な場合のみ、下表に従う。

| 保存先 | 可否 | 条件・備考 |
|---|---|---|
| Keychain（Data Protection Keychain） | 可（最小限。**暗証番号は不可**） | 暗証番号は生体認証付きでも保存しない。`kSecUseDataProtectionKeychain = true`。`kSecAttrAccessible` は `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` 以上（`kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly` はより強い）。`...ThisDeviceOnly` でバックアップ・他デバイス同期から除外される |
| Secure Enclave | 可（**アプリ自身が生成する鍵のみ**） | `SecKeyCreateRandomKey` に `kSecAttrTokenID: kSecAttrTokenIDSecureEnclave`、`SecAccessControlCreateWithFlags(_, _, [.privateKeyUsage], _)`。カードの秘密鍵は入れられない（そもそも取り出せない） |
| 暗号化ファイル（Data Protection 有効） | 限定的 | 個人番号・顔写真を置くなら保存時暗号化必須。鍵は Keychain / Secure Enclave に置く。`FileProtectionType.completeUnlessOpen` 等を設定 |
| `UserDefaults` / plist / 平文ファイル | 不可 | 暗証番号・ハッシュ・署名値・個人番号・顔写真・基本4情報を置かない |
| iCloud・バックアップに含まれる場所 | 不可 | 上記データを同期・バックアップ対象にしない |

- 個人番号を保持する場合は「保存時暗号化 ＋ アクセス最小化 ＋ 目的終了後の遅滞ない削除（復元不可能な方法）＋ 保存期間の明示」。番号法上の保管・削除・ログ禁止の義務は `kenmen-jikou-kakunin-ap` を参照。
- 「削除」は参照を外すことではない。暗号化しているなら鍵を破棄し、ファイルなら削除する。

## 画面の保護

- PIN 入力欄は `UITextField.isSecureTextEntry = true`（SwiftUI は `SecureField`）。オートフィル・キーボードキャッシュを避けるため `textContentType` を安易に付けない。
- PIN 入力画面・カードデータ（個人番号・顔写真・基本4情報）を表示する画面では、アプリ切り替え時のスナップショットを隠す。`sceneWillResignActive` でオーバーレイを被せ、`sceneDidBecomeActive` で外す。
- 画面収録・ミラーリングの検知: `UIScreen.isCaptured` を確認し、`UIScreen.capturedDidChangeNotification` を購読。収録中は機微コンテンツをぼかす／非表示にする。
- スクリーンショットの検知: `UIApplication.userDidTakeScreenshotNotification`（撮影自体は防げないが記録・警告はできる）。
- これらは**抑止であって完全防止ではない**（脱獄端末・外部カメラ）。サーバー側の対策と併用する。

```swift
NotificationCenter.default.addObserver(
    forName: UIScreen.capturedDidChangeNotification, object: nil, queue: .main
) { [weak self] _ in
    self?.sensitiveContentHidden = self?.view.window?.screen.isCaptured ?? false
}
```

## 端末の健全性（任意）

- 脱獄・改ざん・デバッガ接続・エミュレータの検知は、**リスクシグナルとしてサーバーへ報告**する（例: セッション開始メタデータ）。アプリ側でハードに弾く単独ゲートにはしない（誤検知・正規ユーザーの締め出し・回避容易性）。
- 承認可否の最終判断はサーバー側の不正検知に委ねる（`ekyc-session-orchestration`）。
- 検知手法自体（既知ファイルの存在確認・sandbox 外への書き込み可否・`fork` 可否等）はイタチごっこ。実装しても過信しない。

## 権限（NFC・カメラ）

- `Info.plist` の `NFCReaderUsageDescription` / `NSCameraUsageDescription` は用途を正直かつ最小限に書く（実際の利用目的を、ユーザーに分かる言葉で）。
- `com.apple.developer.nfc.readersession.iso7816.select-identifiers` に列挙する AID は、実際に SELECT するものだけにする（`ios-corenfc-apdu`）。
- カメラは容貌撮影が必要なフローでだけ要求する。バックグラウンドや不要画面で起動しない。
- サーバー側の容貌真贋・カメラインジェクション・リプレイ・なりすまし対策はここで再説明しない → `ekyc-session-orchestration`。

## チェックリスト

- [ ] カードの秘密鍵を取り出す実装がない（署名・認証はチップに計算させるだけ）
- [ ] 読み取ったデータはメモリ保持のみ。サーバー送信／セッション終了直後に破棄し、リトライは再読み取り
- [ ] ATS を弱める設定（`NSAllowsArbitraryLoads` 等）が eKYC サーバー向けに無い
- [ ] eKYC サーバーへ証明書／公開鍵ピンニング。ピン不一致で接続拒否、フォールバック無し、バックアップ鍵も登録
- [ ] 暗証番号・チャレンジ／ハッシュ・署名値・個人番号・顔写真・券面イメージ・基本4情報平文を、ログ・分析・クラッシュレポート・APDU ダンプに出していない
- [ ] `os_log` / `Logger` の当該値に `.public` / `%{public}` を使っていない
- [ ] 一時保存は Keychain（`kSecAttrAccessibleWhenUnlockedThisDeviceOnly` 以上・Data Protection Keychain）またはアプリ生成鍵の Secure Enclave のみ。`UserDefaults` / plist / 平文ファイル不使用
- [ ] 個人番号を保持する場合、保存時暗号化・アクセス最小化・目的終了後の削除・保存期間を定義（番号法: `kenmen-jikou-kakunin-ap`）
- [ ] PIN 欄は `isSecureTextEntry`。機微画面はアプリ切り替え時にオーバーレイし、`UIScreen.isCaptured` を監視
- [ ] 脱獄／改ざん検知はサーバーへのリスクシグナルで、アプリ単独のハードゲートにしていない
- [ ] `NFCReaderUsageDescription` / `NSCameraUsageDescription` が正直・最小。`select-identifiers` の AID が最小
- [ ] 端末側で電子署名検証・J-LIS 照会をしていない

## 出典

`references/pdfs/` の PDF は第三者の著作物のためリポジトリに含めない。手元に無ければ `bash references/refresh.sh` で取得する（URL・SHA256 は `references/sources.md`）。

- <https://developer.apple.com/documentation/security/storing-keys-in-the-keychain>（`SecItemAdd(_:_:)` / `SecItemCopyMatching(_:_:)` / `SecItemDelete(_:)`、`kSecClassKey`、`kSecAttrApplicationTag`、`kSecAttrKeyType`、Data Protection Keychain（`kSecUseDataProtectionKeychain`）、Secure Enclave 生成鍵。取得日 2026-09-08）
- <https://developer.apple.com/documentation/security/ksecattraccessible>（`kSecAttrAccessibleWhenUnlocked` / `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` / `kSecAttrAccessibleAfterFirstUnlock` / `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` / `kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly`、`ThisDeviceOnly` は他デバイスへ同期不可。取得日 2026-09-08）
- <https://developer.apple.com/documentation/security/preventing-insecure-network-connections>（App Transport Security、`NSAppTransportSecurity` / `NSAllowsArbitraryLoads` / `NSExceptionDomains` / `NSExceptionMinimumTLSVersion`、既定で TLS 1.2+・PFS・RSA2048/ECC256・SHA-256+、`URLSession` の server trust 評価はタイト化してピンニング可。取得日 2026-09-08）
- <https://developer.apple.com/news/?id=g9ejcf8y>（Identity Pinning: `NSAppTransportSecurity > NSPinnedDomains > <domain> > NSPinnedCAIdentities` / `NSPinnedLeafIdentities` / `SPKI-SHA256-BASE64` / `NSIncludesSubdomains`、iOS 14+、ピンニングは必須ではなく慎重に導入。取得日 2026-09-08）
- <https://developer.apple.com/documentation/os/generating-log-messages-from-your-code>（`Logger` 補間の `privacy:`、動的文字列・オブジェクトは既定で伏せられ数値は伏せられない、`%{public}` / `%{private}`、`privacy: .private(mask: .hash)`。取得日 2026-09-08）
- <https://mas.owasp.org/MASVS/>（OWASP MASVS。MASVS-STORAGE（機微データは Keychain または封筒暗号化で保存、平文の永続化を避ける）、MASVS-NETWORK（TLS・サーバー認証）。取得日 2026-09-08）
- <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0052/>（iOS ローカルデータ保存テスト。`UserDefaults` / plist / Core Data 平文に機微データを置かない、Keychain の `kSecAttrAccessible` は最小権限。取得日 2026-09-08）
- `ekyc-jp/references/pdfs/33_guide-liquid-ekyc.pdf`（p.10「JPKI+（容貌）概要」、p.19「高度な不正検知判定機能」、p.20「Liquid PAD / ISO/IEC 30107」— 容貌真贋判定（ディスプレイ攻撃・写真攻撃の PAD）、カメラインジェクション攻撃判定（カメラ制御をハッキングし仮想映像に差し替える攻撃）、顔／本人特定事項の使いまわし・警告リスト判定。いずれもサーバー側機能で端末アプリの責務ではない）

## 最終確認日: 2026-09-08

## 未確認事項

- 公開鍵（SPKI）ピンニングで比較するハッシュの作り方。`SecKeyCopyExternalRepresentation` は生の鍵ビットを返すため、SPKI（DER の SubjectPublicKeyInfo）の SHA-256 を得るにはアルゴリズム識別子ヘッダの付与が要る。宣言的ピンニング（`SPKI-SHA256-BASE64`）または検証済みライブラリの利用を推奨。証明書 DER ピンニング（`SecCertificateCopyData` の SHA-256、上記コード）は曖昧さが少ない代わりに更新運用の負担が増える。
- `SecTrustCopyCertificateChain` は iOS 15+。より古い OS を対象にする場合の代替。
- カードから読み取る顔写真・個人番号を端末に一時保存する必要が実際に生じるか（多くのフローは即時送信で保存不要）。保存が必要な場合の Data Protection クラスと暗号化方式の確定。
- 脱獄・改ざん検知をサーバーへ報告する際のシグナル項目とスコアリングは `ekyc-session-orchestration` 側の設計に依存（未定）。
- メモリ上の機微データのゼロ化が Swift の `String` / `Data` のコピーに対してどこまで有効か。`memset_s` を使っても中間コピーは残りうる。
- 犯収法上、eKYC アプリに求められる具体的なセキュリティ要件（該当する方法・条項はここで断定しない。`honnin-kakunin-houhou` / `references/method-map.md`）。
