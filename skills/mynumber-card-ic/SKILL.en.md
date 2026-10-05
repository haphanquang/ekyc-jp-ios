---
name: mynumber-card-ic
description: Used to grasp the structure of the My Number Card IC chip and the roles, obtainable data, required PINs, and lock counts of the installed applications (AP)—JPKI-AP (signing/user-authentication), card-face input-assist AP, card-face verification AP, and Juki AP. Refer to apdu-cheatsheet for details on the byte sequences, AIDs, and EF identifiers of each AP.
---

# My Number Card IC Chip and Installed APs

An orientation reference that lists what information can be obtained from which application (AP) and which PIN is required. The details of APDU byte sequences, AIDs, EF identifiers, and SW1SW2 are not included in this skill, but are placed in `references/apdu-cheatsheet.md` and each AP skill (`jpki-ap-shomei`, etc.). Refer to `ios-corenfc-apdu` for implementation procedures for reading from iOS.

## When to Use This Skill

- When understanding "what information can / cannot be obtained" from the My Number Card before designing
- When deciding which AP to use for a purpose (electronic signature, person authentication, reading the four basic attributes, acquiring card-face images)
- When checking the type, number of digits, and lock counts of the PINs for each AP
- When you want an overview before looking up the specific values of APDUs (go to `apdu-cheatsheet` for specific values)

## Overview of the IC Chip

- The My Number Card is an ISO/IEC 14443 Type-B contactless IC card. Communication is performed via APDUs compliant with ISO/IEC 7816-4 (details in `ios-corenfc-apdu` / `apdu-cheatsheet`).
- The IC chip is divided into multiple **APs** according to purpose. Each AP is selected with a SELECT FILE specifying the AID, and EFs (electronic certificates, private keys, PINs, data files) within the AP are accessed.
- The private key never leaves the storage area of the IC chip. The mechanism destroys the IC chip if forcibly read (PDF 07). Design so that private keys and PINs are not retained on the device side (`ios-security`).
- Each PIN becomes blocked (locked) if entered incorrectly for a specified number of consecutive times, requiring initialization at a municipal counter, etc. (`pin-lock-handling`).

## Application (AP) List

| AP | Obtainable Data | Required PIN | Lock Count | Related Skill |
|---|---|---|---|---|
| JPKI-AP (Public Personal Authentication AP) / Signing | Signing certificate (includes four basic attributes), electronic signature value by private key | Signing PIN (6-16 alphanumeric characters) | 5 (Verified: J-LIS `jpki.go.jp`) | jpki-ap-shomei, signature-verification |
| JPKI-AP (Public Personal Authentication AP) / User-authentication | User-authentication certificate (no four basic attributes, includes issue number), signature value by private key | User-authentication PIN (4 digits) | 3 (Verified: J-LIS `jpki.go.jp`) | jpki-ap-riyousha |
| Card-face input-assist AP | Four basic attributes (name, address, date of birth, gender), personal number (all text) | Card-face input-assist PIN (4 digits. Unlocked by date of birth 6 digits + expiration date 4 digits + security code 4 digits) | 3 (Verified: My Number Card general site `kojinbango-card.go.jp`, Mynaportal FAQ, Digital Agency `services.digital.go.jp`) | kenmen-nyuryoku-hojo-ap |
| Card-face verification AP | Card-face images (front, back), facial photo image, personal number (reading also requires input of an inquiry number) | Card-face verification (verification number B, 14 digits = date of birth 6 + expiration date 4 + security code 4) / Personal number (verification number A, My Number 12 digits) | Verification number B 10 (Verified: Digital Agency, municipalities, multiple vendor materials match) / Verification number A unverified | kenmen-jikou-kakunin-ap |
| Juki AP | Basic Resident Register network related data (details unverified) | Unverified | Unverified | This skill (no dedicated skill) |

The lock count column is based on the "Number of Digits and Lock Counts for PINs" table in `references/apdu-cheatsheet.md` (that table is the primary record of values, sources, and certainties). Signing 5 times / User-authentication 3 times (J-LIS `jpki.go.jp`), the 4-digit PIN for card-face input-assist 3 times (`kojinbango-card.go.jp`, Digital Agency), and verification number B (14 digits) for the card-face verification AP 10 times (Digital Agency, municipalities, multiple vendors) have been verified through primary/official sites. The lock count for verification number A (My Number 12 digits), as well as AIDs and EF identifiers, are also marked as `未確認` (unverified) or `（1ソースのみ・要検証）` (single source, needs verification) in the same file.

## Purpose-Specific: Which AP to Use

| Purpose | AP to Use | Remarks |
|---|---|---|
| Generation of electronic signatures and authenticity confirmation (identity verification accompanying the four basic attributes, contracts) | JPKI-AP / Signing | `jpki-ap-shomei`. Refer to `honnin-kakunin-houhou` for its positioning in identity verification methods |
| Person authentication such as login (four basic attributes not required) | JPKI-AP / User-authentication | `jpki-ap-riyousha`. Identifies the logged-in person by issue number |
| Reading the four basic attributes and personal number as text (method combining card-face photographing and facial photographing) | Card-face input-assist AP | `kenmen-nyuryoku-hojo-ap`. Refer to `honnin-kakunin-houhou` for details on methods. Read-only without signature function |
| Reading card-face images, facial photo images, and personal numbers (face-to-face confirmation, IC reading of identity verification documents) | Card-face verification AP | `kenmen-jikou-kakunin-ap`. Handling personal numbers requires a basis under the My Number Act |
| Processing related to the Basic Resident Register network | Juki AP | Detailed scope is outside this plugin |

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/apdu-cheatsheet.md` (AIDs, EF identifiers, APDUs, SW1SW2, PIN digit counts/lock counts, and the certainty of each value)
- `references/pdfs/07_types-of-electronic-certificate.pdf` (Properties of signing / user-authentication certificates, presence of four basic attributes, public key cryptography, mechanism where private keys do not leave the IC chip)
- `references/yougoshuu.md` (Term definitions for each AP)
- Live URL: <https://zenn.dev/trustdock/articles/66a228895294bc> (TrustDock "Introduction to Public Personal Authentication (JPKI)" — IC chip AP structure, NFC Type-B, ISO 7816 APDU, PIN lock counts, standard processing flow. Acquired 2026-09-07)
- Live URL: <https://www.jpki.go.jp/procedure/password.html> (J-LIS — Signing locks after 5 consecutive incorrect entries, user-authentication after 3. Acquired 2026-09-08)
- Live URL: <https://www.kojinbango-card.go.jp/faq_pin2/> (My Number Card General Site FAQ — The PIN for the card-face items input-assist app is 4 digits, locks after 3 incorrect entries. Acquired 2026-09-08)
- Live URL: <https://services.digital.go.jp/mynumbercard/info-passcode/> (Digital Agency — Card-face input-assist PIN is 4 digits/locks after 3 times, 14-digit inquiry number for card-face AP reading locks after 10 times. Acquired 2026-09-08)

## Last Verified

2026-09-09

## Unverified Items

- The actual AID values of each AP. Only JPKI-AP matches across multiple sources. Card-face input-assist AP has only 1 public source and requires verification, card-face verification AP and Juki AP could not be verified with public sources. Refer to `references/apdu-cheatsheet.md` for actual values (must be verified before implementation).
- The EF layout of each AP (comprehensive list of identifiers for electronic certificates, private keys, PINs, and data files).
- Unverified lock counts are for verification number A (My Number 12 digits - for personal numbers) and Juki. Signing 5 times / user-authentication 3 times (J-LIS `jpki.go.jp`), the 4-digit PIN for card-face input-assist 3 times (`kojinbango-card.go.jp`, Digital Agency), and verification number B (14 digits) 10 times (Digital Agency, municipalities, multiple vendors) are verified (`references/apdu-cheatsheet.md`). The lock count, AID, and EF identifiers for verification number A are not in public sources and require confirmation via J-LIS technical specifications (NDA).
- The structure and byte order of the unlock parameters for the card-face input-assist PIN (date of birth 6 digits + expiration date 4 digits + security code 4 digits).
- Details and uses of data items that can be obtained from the Juki AP.
