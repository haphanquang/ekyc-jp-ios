---
name: ios-security
description: iOS eKYC security implementation reference. Covers handling of data read from My Number Card (basic 4 information, face photo, individual number, signature values, PINs) on the device. Private keys never leave the IC chip / read data kept in memory only and wiped after server transmission / TLS 1.2+ and App Transport Security / certificate pinning and public key pinning for eKYC server / never log PINs, challenge hashes, signature values, individual numbers, or face photos (PIN logging prohibition including analytics/crash reports) / Keychain storage eligibility / individual number protection (encryption at rest, deletion after purpose fulfilled) / screenshot and screen recording prevention for PIN entry and card data display screens / device integrity checks (optional) / NFC and camera permission wording. Server-side spoofing, camera injection, and replay countermeasures are in ekyc-session-orchestration.
---

# Handling Card Data and Security on iOS Devices

A reference for **device-side security rules to follow** when implementing My Number Card eKYC in an iOS app. For APDU communication, see `ios-corenfc-apdu`; for signature generation procedures, see `jpki-ap-shomei`; for person authentication, see `jpki-ap-riyousha`; for individual number handling under the Number Use Act, see `kenmen-jikou-kakunin-ap`; for PIN lock UX, see `pin-lock-handling`.

The device side does not verify digital signatures or query J-LIS (server / platform operator responsibility). Server-side fraud detection (spoofing, camera injection, replay) is delegated to `ekyc-session-orchestration`. Method names, designations, and enforcement dates under the Act on Prevention of Transfer of Criminal Proceeds are not asserted here (`honnin-kakunin-houhou` / `references/method-map.md`).

## When to Use This Skill

- When deciding how to handle / not handle basic 4 information, face photos, individual numbers, signature values, and PIN inputs read from the card on the device
- When configuring TLS, certificate/public key pinning, and App Transport Security for eKYC server communication
- When separating items that can vs. cannot appear in logs, analytics, and crash reports
- When checking conditions for storing temporary data in Keychain / Secure Enclave, and storage locations that must not be used
- When implementing screenshot/screen recording prevention for PIN entry and card data display screens
- When deciding on jailbreak detection and NFC/camera permission handling

## Principles

### Private Keys Never Leave the IC Chip

- The user authentication and signature private keys of the My Number Card are generated and stored within the IC chip, and no API exists to export them outside the chip. The app only "has the chip compute signatures/authentication" (`jpki-ap-shomei` / `jpki-ap-riyousha`).
- Do not attempt to "extract" or "copy" keys. If such a requirement comes up in design review, correct it as a misunderstanding.

### Card Data is Volatile

- **Pass the PIN only to the VERIFY APDU sent to the card.** Never send it to servers, analytics SDKs, logs, or the pasteboard. Do not save it in Keychain (including a biometrically protected "remember PIN" feature), UserDefaults, or files. Use `isSecureTextEntry` for the input field and discard the PIN as soon as the VERIFY response arrives. If a design sends the PIN to a server or stores it, correct it as an error.
- Basic 4 information, face photo images, individual numbers, challenge/to-be-signed data, and signature values read from the card are **temporary data for sending to the server** (the PIN is not sent, as stated above). Hold as `Data` / `String` and discard immediately after server transmission (or session termination).
- Limit retention to the scope of one request. On retry, re-read from the card.
- If possible, receive in a fixed-length buffer (`[UInt8]`), zero-fill after use, then release. However, since Swift's `String` / `Data` copies can be distributed, zeroing is not a complete guarantee. The top priority is "don't store it in the first place / don't log it."

```swift
final class SensitivePayload {
    private(set) var bytes: [UInt8]
    init(_ bytes: [UInt8]) { self.bytes = bytes }

    /// Must be called after server transmission
    func wipe() {
        bytes.withUnsafeMutableBytes { buf in
            guard let base = buf.baseAddress else { return }
            memset_s(base, buf.count, 0, buf.count)   // C11 Annex K. Won't be optimized away
        }
        bytes.removeAll(keepingCapacity: false)
    }
    deinit { wipe() }
}
```

## Communication (TLS and Pinning)

- **Do not weaken App Transport Security.** Do not add `NSAllowsArbitraryLoads` / `NSExceptionAllowsInsecureHTTPLoads` / `NSExceptionMinimumTLSVersion` lowering configurations for the eKYC server. ATS requires TLS 1.2+, Perfect Forward Secrecy (ECDHE), SHA-256+, RSA 2048bit / ECC 256bit+ by default.
- Perform **certificate pinning or public key (SPKI) pinning** for the eKYC server. Public key pinning is more resilient to regular certificate renewal. Also pin backup keys for emergency rotation.
- **Declarative pinning (iOS 14+)**: List `SPKI-SHA256-BASE64` in `Info.plist` under `NSAppTransportSecurity > NSPinnedDomains > <domain> > NSPinnedCAIdentities` (or `NSPinnedLeafIdentities`). `NSIncludesSubdomains` can also be specified. Declarative pinning does not replace other ATS requirements.
- **Code-based pinning**: In `URLSessionDelegate`'s `urlSession(_:didReceive:completionHandler:)`, after standard chain validation (`SecTrustEvaluateWithError`), verify that the server certificate/public key matches the pinned value. Reject the connection on mismatch (do not create a lenient fallback).

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
    guard SecTrustEvaluateWithError(trust, &error) else {                 // Standard chain validation
        completionHandler(.cancelAuthenticationChallenge, nil); return
    }
    guard let chain = SecTrustCopyCertificateChain(trust) as? [SecCertificate],  // iOS 15+
          let leaf = chain.first else {
        completionHandler(.cancelAuthenticationChallenge, nil); return
    }
    let der = SecCertificateCopyData(leaf) as Data
    guard Self.pinnedLeafSHA256.contains(Data(SHA256.hash(data: der))) else {
        completionHandler(.cancelAuthenticationChallenge, nil); return       // Pin mismatch = immediate rejection
    }
    completionHandler(.useCredential, URLCredential(trust: trust))
}
```

## Items That Must Not Be Logged

In app logs, `os_log` / `Logger`, analytics events, and crash reporter (Crashlytics, etc.) breadcrumbs/custom keys, do **NOT output the following in plaintext**.

- [ ] PINs (user authentication 4-digit, signature 6-16 alphanumeric, card surface inquiry numbers)
- [ ] Challenge / signature target hash received from server
- [ ] Generated digital signature values
- [ ] Individual number (My Number, 12 digits)
- [ ] Face photo images, card surface images, camera-captured facial images
- [ ] Basic 4 information (name, address, date of birth, sex) in plaintext
- [ ] Raw APDU byte sequences / HTTP request/response bodies containing the above

Additionally:

- `os_log` / `Logger`: Dynamic strings and objects are redacted as `<private>` by default; integers, floats, and booleans are not redacted. **Never apply `privacy: .public` (legacy API's `%{public}`) to the above values.** When you only need correlation, use `privacy: .private(mask: .hash)`.
- Disable `print` / `NSLog` in release builds. Also turn off network debug proxy output.

```swift
logger.info("Sending JPKI signature: session=\(sessionID, privacy: .public) len=\(sig.count, privacy: .public)")
// Do NOT output the signature value itself, PINs, hashes, individual numbers, or face photos
```

## Local Storage

**In principle, do not store on the device** (don't store if immediate transmission is possible). Only when temporary retention is absolutely necessary, follow the table below.

| Storage Location | Allowed | Conditions / Notes |
|---|---|---|
| Keychain (Data Protection Keychain) | Yes (minimal; **never the PIN**) | Do not store the PIN, even with biometric protection. `kSecUseDataProtectionKeychain = true`. `kSecAttrAccessible` should be `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` or stronger (`kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly` is stronger). `...ThisDeviceOnly` excludes from backup and cross-device sync |
| Secure Enclave | Yes (**only for keys generated by the app itself**) | `SecKeyCreateRandomKey` with `kSecAttrTokenID: kSecAttrTokenIDSecureEnclave`, `SecAccessControlCreateWithFlags(_, _, [.privateKeyUsage], _)`. Card's private keys cannot be placed here (cannot be extracted in the first place) |
| Encrypted file (Data Protection enabled) | Limited | If storing individual numbers or face photos, encryption at rest is mandatory. Keys go in Keychain / Secure Enclave. Set `FileProtectionType.completeUnlessOpen`, etc. |
| `UserDefaults` / plist / plaintext file | Not allowed | Do not store PINs, hashes, signature values, individual numbers, face photos, or basic 4 information |
| iCloud or backup-included locations | Not allowed | Do not sync or back up the above data |

- When retaining individual numbers: "encryption at rest + access minimization + prompt deletion by irrecoverable means after purpose fulfilled + explicit retention period." For Number Use Act obligations regarding storage, deletion, and logging prohibition, see `kenmen-jikou-kakunin-ap`.
- "Deletion" does not mean removing the reference. If encrypted, destroy the key; if a file, delete it.

## Screen Protection

- Set PIN input fields to `UITextField.isSecureTextEntry = true` (SwiftUI uses `SecureField`). Do not casually set `textContentType` to avoid autofill and keyboard caching.
- On PIN entry screens and screens displaying card data (individual number, face photo, basic 4 information), hide app-switching snapshots. Apply an overlay on `sceneWillResignActive`, remove on `sceneDidBecomeActive`.
- Screen recording/mirroring detection: Check `UIScreen.isCaptured` and subscribe to `UIScreen.capturedDidChangeNotification`. Blur/hide sensitive content during recording.
- Screenshot detection: `UIApplication.userDidTakeScreenshotNotification` (cannot prevent the screenshot itself, but can log/warn).
- These are **deterrents, not complete prevention** (jailbroken devices, external cameras). Use in conjunction with server-side countermeasures.

```swift
NotificationCenter.default.addObserver(
    forName: UIScreen.capturedDidChangeNotification, object: nil, queue: .main
) { [weak self] _ in
    self?.sensitiveContentHidden = self?.view.window?.screen.isCaptured ?? false
}
```

## Device Integrity (Optional)

- Jailbreak, tampering, debugger attachment, and emulator detection should be **reported to the server as a risk signal** (e.g., in session start metadata). Do not make it a standalone hard gate on the app side (false positives, locking out legitimate users, ease of circumvention).
- Delegate final approval/rejection to server-side fraud detection (`ekyc-session-orchestration`).
- Detection methods themselves (checking for known files, sandbox write ability, `fork` success, etc.) are a cat-and-mouse game. Don't over-rely on them even if implemented.

## Permissions (NFC, Camera)

- Write `NFCReaderUsageDescription` / `NSCameraUsageDescription` in `Info.plist` honestly and minimally (describe the actual purpose of use in user-understandable language).
- List only AIDs you actually SELECT in `com.apple.developer.nfc.readersession.iso7816.select-identifiers` (`ios-corenfc-apdu`).
- Request camera only in flows that require facial capture. Do not activate in the background or on unnecessary screens.
- Server-side facial presentation attack detection, camera injection countermeasures, replay and spoofing countermeasures are not re-explained here → `ekyc-session-orchestration`.

## Checklist

- [ ] No implementation that extracts the card's private keys (signing/authentication only has the chip compute)
- [ ] Read data is memory-only. Discarded immediately after server transmission / session termination; retries re-read
- [ ] No ATS-weakening settings (`NSAllowsArbitraryLoads`, etc.) for the eKYC server
- [ ] Certificate/public key pinning for eKYC server. Connection rejected on pin mismatch, no fallback, backup key also registered
- [ ] PINs, challenge/hash, signature values, individual numbers, face photos, card surface images, and basic 4 information plaintext do NOT appear in logs, analytics, crash reports, or APDU dumps
- [ ] `.public` / `%{public}` is NOT used on these values in `os_log` / `Logger`
- [ ] Temporary storage is Keychain (`kSecAttrAccessibleWhenUnlockedThisDeviceOnly` or stronger, Data Protection Keychain) or app-generated keys in Secure Enclave only. No `UserDefaults` / plist / plaintext files
- [ ] When retaining individual numbers: encryption at rest, access minimization, post-purpose deletion, and retention period defined (Number Use Act: `kenmen-jikou-kakunin-ap`)
- [ ] PIN fields use `isSecureTextEntry`. Sensitive screens overlaid on app switch, `UIScreen.isCaptured` monitored
- [ ] Jailbreak/tampering detection serves as risk signal to server, not a hard app-only gate
- [ ] `NFCReaderUsageDescription` / `NSCameraUsageDescription` are honest and minimal. `select-identifiers` AIDs are minimal
- [ ] Device does NOT perform digital signature verification or J-LIS queries

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- <https://developer.apple.com/documentation/security/storing-keys-in-the-keychain> (`SecItemAdd(_:_:)` / `SecItemCopyMatching(_:_:)` / `SecItemDelete(_:)`, `kSecClassKey`, `kSecAttrApplicationTag`, `kSecAttrKeyType`, Data Protection Keychain (`kSecUseDataProtectionKeychain`), Secure Enclave generated keys. Retrieved 2026-09-08)
- <https://developer.apple.com/documentation/security/ksecattraccessible> (`kSecAttrAccessibleWhenUnlocked` / `...WhenUnlockedThisDeviceOnly` / `...AfterFirstUnlock` / `...AfterFirstUnlockThisDeviceOnly` / `...WhenPasscodeSetThisDeviceOnly`, `ThisDeviceOnly` prevents sync to other devices. Retrieved 2026-09-08)
- <https://developer.apple.com/documentation/security/preventing-insecure-network-connections> (App Transport Security, `NSAppTransportSecurity` / `NSAllowsArbitraryLoads` / `NSExceptionDomains` / `NSExceptionMinimumTLSVersion`, default TLS 1.2+ / PFS / RSA2048/ECC256 / SHA-256+, `URLSession` server trust evaluation can be tightened for pinning. Retrieved 2026-09-08)
- <https://developer.apple.com/news/?id=g9ejcf8y> (Identity Pinning: `NSAppTransportSecurity > NSPinnedDomains > <domain> > NSPinnedCAIdentities` / `NSPinnedLeafIdentities` / `SPKI-SHA256-BASE64` / `NSIncludesSubdomains`, iOS 14+, pinning is not mandatory and should be introduced carefully. Retrieved 2026-09-08)
- <https://developer.apple.com/documentation/os/generating-log-messages-from-your-code> (`Logger` interpolation `privacy:`, dynamic strings/objects are redacted by default while numbers are not, `%{public}` / `%{private}`, `privacy: .private(mask: .hash)`. Retrieved 2026-09-08)
- <https://mas.owasp.org/MASVS/> (OWASP MASVS. MASVS-STORAGE (sensitive data stored in Keychain or envelope encryption, avoid plaintext persistence), MASVS-NETWORK (TLS, server authentication). Retrieved 2026-09-08)
- <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0052/> (iOS local data storage test. Don't put sensitive data in `UserDefaults` / plist / Core Data plaintext, Keychain `kSecAttrAccessible` should be least privilege. Retrieved 2026-09-08)
- `ekyc-jp/references/pdfs/33_guide-liquid-ekyc.pdf` (p.10 "JPKI+ (facial) overview," p.19 "Advanced fraud detection functions," p.20 "Liquid PAD / ISO/IEC 30107" — all server-side functions, not device app responsibilities)

## Last Verified: 2026-09-08

## Unverified Items

- How to construct the hash for public key (SPKI) pinning comparison. `SecKeyCopyExternalRepresentation` returns raw key bits, so obtaining SHA-256 of SPKI (DER SubjectPublicKeyInfo) requires prepending the algorithm identifier header. Recommend declarative pinning (`SPKI-SHA256-BASE64`) or verified libraries. Certificate DER pinning (SHA-256 of `SecCertificateCopyData`, code above) has less ambiguity but more operational burden for updates.
- `SecTrustCopyCertificateChain` is iOS 15+. Alternative for targeting older OS versions.
- Whether the need actually arises to temporarily store face photos or individual numbers read from the card on the device (most flows can do immediate transmission without storage). Data Protection class and encryption method for when storage is needed.
- Signal items and scoring for reporting jailbreak/tampering detection to the server depend on `ekyc-session-orchestration` side design (undefined).
- How effective zeroing of sensitive data in memory is against Swift `String` / `Data` copies. Even with `memset_s`, intermediate copies may remain.
- Specific security requirements for eKYC apps under the Act on Prevention of Transfer of Criminal Proceeds (applicable methods and articles are not asserted here. `honnin-kakunin-houhou` / `references/method-map.md`).
