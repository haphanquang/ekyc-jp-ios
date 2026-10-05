---
name: honnin-kakunin-houhou
description: Used to determine 'which identity verification method can be used' in Japan's eKYC. Covers the Act on Prevention of Transfer of Criminal Proceeds (currently i to yo, ka = Public Personal Authentication/JPKI limited to signature verifiers, ru = smartphone-mounted My Number Card, etc.), Mobile Phone Fraud Prevention Act (already enforced on April 1, 2026, Article 3, Paragraph 1, Item 1 i to nu), Secondhand Articles Dealer Act, and the revision of the Act on Prevention of Transfer of Criminal Proceeds enforced on April 1, 2027 (abolition of image transmission methods, reorganization of method designations, JPKI = new nu). The sole defining source for method names and dates.
---

# Identity Verification Method Map (Act on Prevention of Transfer of Criminal Proceeds, Mobile Phone Fraud Prevention Act, Secondhand Articles Dealer Act)

A reference to determine "when and which identity verification method can be used for each applicable law" in Japan's non-face-to-face eKYC.

**This skill and `references/method-map.md` are the sole locations that define the method names (method designations like i to yo) and enforcement dates.** Other skills must refer to this skill / `method-map.md` and not assert names and dates on their own. The list of methods (designations, obtained data, supported documents) in `references/method-map.md` is the official record, and this skill layers the judgment of "when and which one to implement" on top of it.

- List, obtained data, supported documents → `references/method-map.md`
- Excerpts of primary articles of method designations (with e-Gov revision ID) → `references/hourei-eKYC.md`
- Article-by-article and old-new comparisons of enforcement ordinances → e-Gov e-Laws (`## Sources`)

## When to Use This Skill

- When identifying the legal basis of an eKYC / identity verification feature (Act on Prevention of Transfer of Criminal Proceeds / Mobile Phone Fraud Prevention Act / My Number Act / Secondhand Articles Dealer Act) and listing the available methods
- When determining whether the "ho method (document photographing + selfie)" can still be used and until when
- When checking how your company's flow will be affected by the revision of the Act on Prevention of Transfer of Criminal Proceeds in April 2027
- When confirming whether your company needs to be a "signature verifier" to use the Public Personal Authentication (JPKI) method
- When selecting one or more methods to implement (`## Recommendations in This App` and `## Purpose-Specific Method Selection Flow` in this skill)
- For fact-checking before writing things like "Method X will be abolished in year Y" in other skills or design documents

## Current Methods (Act on Prevention of Transfer of Criminal Proceeds)

Methods for individuals (natural persons) in non-face-to-face / electronic transactions under Article 6, Paragraph 1, Item 1 of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds. The method designations are **15 items from i (イ) to yo (ヨ)**. **For the list of designations, obtained data, and supported documents, see the table "Current (In Effect) Methods for Individuals under the Act on Prevention of Transfer of Criminal Proceeds" in `references/method-map.md`.** Primary article excerpts are in `references/hourei-eKYC.md` §1 (Revision `420M60000F5A001_20260806_508M60000F5A006`). Below is only a summary of the main items that can be implementation targets for eKYC.

| Designation | Summary | After April 2027 Revision |
|---|---|---|
| ho (ホ) | Transmission of an **image** of a photo identity verification document + facial photographing (the so-called "ho method") | **Abolished** |
| he (ヘ) | Transmission of the **IC chip record information** of a photo identity verification document + facial photographing | Transitions to designation **new ha (新ハ)** (IC reading + facial photo) |
| to (ト) | Transmission of an image or IC reading of a document + customer information inquiry to a bank, etc. (Bank API) | Image transmission type is abolished, IC reading type is retained (equivalent to new ni (新ニ)) |
| chi (チ) | Presentation/sending of a document + sending transaction-related documents as non-forwardable mail, etc. | Designation is moved |
| wa (ワ) | Electronic certificate of an **accredited certification business operator** under Article 4, Paragraph 1 of the Electronic Signatures Act + transmission of electronic signature information | Equivalent to designation **new ri (新リ)**. An independent method separate from JPKI (not the "old name of ka") |
| ka (カ) | **Public Personal Authentication (JPKI)** = Signing certificate issued by the agency + transmission of information regarding specified transactions on which an electronic signature was performed. Acquires four basic attributes (name, residence, date of birth, gender). **Proviso = Limited to cases where the specified business is a signature verifier** (see below) | Retained. Designation **new nu (新ヌ)** (Proviso is also the same) |
| yo (ヨ) | Electronic certificate of a certified person under Article 17, Paragraph 1, Item 5 of the Public Personal Authentication Act (**specified certification business**) + transmission of electronic signature information | Equivalent to designation **new ru (新ル)**. Separate from JPKI |
| ru (ル) | Transmission of **specified electronic records** of an **alternative electronic record for a card** (My Number Card mounted on a smartphone) + attribution confirmation. Newly established on June 24, 2025. Transmission of facial images is not required | Retained. Designation **new to (新ト)** |

- **The specified electronic records of the ru method include only "name, residence, date of birth, photo", and do not include the personal number or gender** (Definition in Article 6, Paragraph 1, Item 1, ru of the Enforcement Ordinance). Do not design to acquire or save the personal number (a separate administrative basis under the My Number Act is required. See `kenmen-jikou-kakunin-ap`).
- The ru method can be used for both face-to-face and non-face-to-face specified transactions. Generally for ages 15 and over. The Android version of the My Number Card is scheduled to be provided around autumn 2026.

### To use the ka method (JPKI), the company must be a "signature verifier"

There is a proviso at the end of the text for Article 6, Paragraph 1, Item 1, ka of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds (new nu from April 2027) (verbatim in `references/hourei-eKYC.md` §1):

> ...limited to cases where the specified business is a signature verifier prescribed in Article 17, Paragraph 4 of the Public Personal Authentication Act.

- "Signature verifier" = A person who has submitted a **notification** under Article 17, Paragraph 1 of the Public Personal Authentication Act (for private businesses, a person who has received **competent minister certification under Item 6** of the same paragraph and then submitted a notification) + the Agency (Article 17, Paragraph 4 of the same Act).
- To perform **transaction verification** using the JPKI method, **the specified business itself must be a signature verifier**. The general statement "Since the PF operator has certification, the SP operator does not need certification" means that the facilities and inquiries for certificate validity verification can be outsourced to the PF operator, but a specified business that uses the ka method (new nu) for transaction verification must be a signature verifier.
- A PF operator can perform competent minister certification, notification to the agency, and development of signature verification facilities on behalf of the specified business (see `platform-jigyousha`), but the name belongs to the specified business.
- **Blocking item before design/contracting**: Confirm with legal affairs and the PF operator the necessity of the company becoming a signature verifier, the scope that the PF operator can act as a proxy for, and the required period (refer to the onboarding in `platform-jigyousha`).

## Revision of the Act on Prevention of Transfer of Criminal Proceeds Enforced on April 1, 2027

Primary article excerpt: `references/hourei-eKYC.md` §2 (Revision `420M60000F5A001_20270401_508M60000F5A005`. Revision Order No. **5** of Cabinet Office, etc. Order of Reiwa 8, promulgated on June 26, 2026, enforced on April 1, 2027, e-Gov status = unenforced).

### Confirmed Facts

- **The enforcement date is April 1, Reiwa 9 (2027).** Stated explicitly in both Q2 of the NPA JAFIC "Q&A regarding... the Reiwa 8 Revision (promulgated on March 6, Reiwa 8)" and the Financial Services Agency's promulgation material (June 26, Reiwa 8).
- **The method designations are reorganized into 14 items from i (イ) to ka (カ).** For a summary of each item acquired from e-Gov `?asof=2027-04-01`, see the table "## Enforced on April 1, 2027" in `references/method-map.md`. Main correspondences: **current he → new ha** (non-face-to-face IC reading + facial photo), **current ru → new to** (smartphone-mounted My Number Card), **current ka → new nu** (JPKI, proviso is identical), current wa → new ri, current yo → new ru.
- **Methods with a high risk of spoofing are specifically abolished.** (a) Methods involving the transmission of **images** photographing photo identity verification documents (the so-called "ho method"), (b) Methods involving the **sending of copies** of identity verification documents, specifically the image transmission type and the type without photo documents. **Types involving the sending of copies + non-forwardable mail are retained under separate designations** (not an "all-out abolition of sending copies") (however, new he is limited to specific transactions, and new wa and new ka are limited to persons not subject to the Basic Resident Register Act or who have moved overseas. 2027 version, Article 6, Paragraph 1, Item 1, wa, opening clause: "the same applies in wa and ka below"; revision `420M60000F5A001_20270401_508M60000F5A005`, acquired 2026-10-05).
- **Non-face-to-face shifts to "IC chip information reading + verification against card-face information".** Not limited to apps provided by ministries but private apps are also acceptable.
- **Supplementary measures are retained.** For those who do not have IC chip-equipped documents, sending originals of identity verification documents with anti-forgery measures (copy of resident register, etc.) + non-forwardable mail.
- **Transaction verifications legally completed before enforcement remain valid** ("completed verifications". No need to redo).

### Unverified (Do not assert)

- **The article-by-article requirements and branch numbers for each item of the 2027 version** remain at the level of summaries extracted from the e-Gov API, and article-by-article matching against the old-new comparison text has not been completed (`references/method-map.md` "## Unverified Items"). Pre-enforcement provisions may be subject to further revisions.
- **The relationship between "Order No. 1" and "Order No. 5" of the Reiwa 8 revision**. The NPA JAFIC Q&A is based on Order No. 1, while the e-Gov 2027-04-01 revision is based on Order No. 5. Requires confirmation via old-new comparison text.
- The method designation system in the LIQUID materials (`references/pdfs/33_guide-liquid-ekyc.pdf` p8) is based on the Reiwa 7 revision order (Order No. 3) and does not reflect subsequent reorganizations. Do not finalize method designations based solely on vendor slides.

## Mobile Phone Fraud Prevention Act / Secondhand Articles Dealer Act

### Mobile Phone Fraud Prevention Act (Revision already enforced — April 1, 2026)

Official name: Ordinance for Enforcement of the Act on Identification, etc. by Mobile Voice Communications Carriers of their Subscribers, etc. and for Prevention of Improper Use of Mobile Voice Communications Services. Primary article excerpt: `references/hourei-eKYC.md` §3 (Revision `417M60000008167_20260806_508M60000008099`).

- **The revision has already been enforced on April 1, 2026** (the **transitional measures** for some methods under the old rules last **until September 30, 2026**). The previous version of this skill stated "scheduled for revision in April 2026 / unverified", but this was incorrect; it is already an effective provision.
- Applicable article: Article 3, Paragraph 1, Item 1 (At the time of concluding a contract / natural persons). The method designations are **10 items from i (イ) to nu (ヌ)**. Different designations apply at the time of transfer (Article 11) and lending (Article 19).
- **Methods of transmitting images of documents no longer remain** (ha and ni are transmissions of IC chip record information).
- Main designations: **ha (ハ)** = transmission of a facial image + IC chip record information of a photo identity verification document (IC reading + facial photo), **chi (チ)** = transmission of specified electronic records (certified programs under Article 18-3, Paragraph 1 of the My Number Use Act) = smartphone-mounted My Number Card, **to (ト)** = transmission of electronic signature information + reception of electronic certificates. For a list of each item, see the table "Mobile Phone Fraud Prevention Act" in `references/method-map.md`.
- **The article-by-article breakdown of the supplementary provisions for the enforcement date and transitional measure deadline (2026-09-30)** was verified on e-Gov during the review on September 10, 2026 (the excerpt of the supplementary provision text is not included). This must be finalized with the e-Gov supplementary provisions during `sources-refresh`.

### Secondhand Articles Dealer Act

Primary article excerpts: `references/hourei-eKYC.md` §5 (Ordinance for Enforcement of the Secondhand Articles Dealer Act, revision `407M50400000010_20260812_508M60400000017`; Secondhand Articles Dealer Act, `324AC0000000108_20250601_504AC0000000068`; acquired 2026-10-05). For the item-by-item correspondence table with the Act on Prevention of Transfer of Criminal Proceeds, see "## 古物営業法" in `references/method-map.md`.

- The verification duty is Article 15, Paragraph 1 of the Secondhand Articles Dealer Act (any of Items 1–4). **Article 15, Paragraph 3 of the Enforcement Ordinance, delegated by Item 4, has 13 items, 一 to 十三** (kanji numerals; a separate system from the i, ro… designations of the Act on Prevention of Transfer of Criminal Proceeds). The matters to verify are **address, name, occupation and age**.
- Main correspondences: **Item 11 ≈ ka (new nu) = JPKI**, **Item 9 ≈ he (new ha) = IC reading + face image**, Item 8 ≈ ho (document image + face image), Item 4 ≈ chi (new ho) = IC / image transmission or sending a copy of the residence certificate, etc. + non-forwardable mail (not the to type), Item 5 ≈ ri (new ka is limited to persons not subject to the Basic Resident Register Act or who have moved overseas), Item 12 ≈ yo (new ru).
- **Item 11 (JPKI) also carries the signature-verifier proviso** ("limited to cases where the secondhand dealer is a signature verifier as prescribed in Article 17, Paragraph 4 of the Public Personal Authentication Act"). The electronically signed record must contain the counterparty's **address, name, occupation and age** (the basic 4 information in the signing certificate does not include occupation). The signing certificate for mobile terminal equipment (Article 16-2, Paragraph 6 of the Public Personal Authentication Act) is also covered.
- **There is no method that transmits the specified electromagnetic record of a smartphone-embedded My Number Card (the ru / new to type of the Act on Prevention of Transfer of Criminal Proceeds).**
- **2027**: As of 2026-10-05, e-Gov shows no unenforced revision of the Ordinance for Enforcement of the Secondhand Articles Dealer Act, and `?asof=2027-04-01` returns the current revision (Item 8, the document-image type, also remains in force on e-Gov). Whether it will be amended in the future is unverified.
- Records: entries in the books, etc. (Article 16 of the Act: the counterparty's address, name, occupation and age, and the category of measure taken) and 3-year retention (Article 18, Paragraph 1 of the Act). This is separate from the verification records (7 years) of the Act on Prevention of Transfer of Criminal Proceeds.

## Creation and Preservation of Verification Records

Under the Act on Prevention of Transfer of Criminal Proceeds, **a specified business must immediately create a verification record after performing a transaction verification and preserve it for a certain period**. In implementing eKYC, this recording obligation must be woven into the design with the same weight as method selection.

- **Verification records** (Article 6, Paragraph 2 of the Act on Prevention of Transfer of Criminal Proceeds): Created immediately when a transaction verification is performed and preserved for **7 years from the date the contract pertaining to the specified transaction, etc. ends, or another date specified by an ordinance of the competent ministry** (Article 21 of the Enforcement Ordinance stipulates "the date the transaction ends, or the date the transaction pertaining to the completed transaction verification ends, **whichever comes later**").
- **Transaction records, etc.** (Article 7, Paragraph 3 of the Act on Prevention of Transfer of Criminal Proceeds): Created when a transaction, etc. pertaining to specified business is performed and preserved for **7 years from the date the transaction, etc. was performed**.
- **Obligation to attach electronic records** (Article 19, Paragraph 1, Item 2 of the Enforcement Ordinance): When verification is performed using the methods from **wa to yo** (wa, ka, yo. Includes ka = JPKI. Equivalent to ri to ru after 2027) of Article 6, Paragraph 1, Item 1, "electronic records sufficient to prove that the matters for verifying the identity were verified by that method" (in practice, the electronic signature and signing certificate) must be attached to the verification record. In the **he method (IC reading + facial photo)**, "the image information for identity verification + the information on name, residence, date of birth, and photo recorded on the IC chip" is attached.
  - → **The principle of "not retaining the signing certificate when acquiring consent for the latest 4 attributes provision service" (`doui-jouhou-kanri`) is a separate system from this evidence attachment obligation of the Act on Prevention of Transfer of Criminal Proceeds.** When performing transaction verification using the ka method (new nu), the evidence store for the Act on Prevention of Transfer of Criminal Proceeds (electronic signature + signing certificate, 7 years) and the consent information store (10 years, non-retention) must be **designed separately** (`signature-verification` "What to retain / not retain after verification").
- **Note on the starting date**: Verification records are preserved for 7 years from "the date the contract ended, etc.", not "when the transaction started". For continuous contractual relationships, the preservation period is effectively extended.
- eKYC session audit logs (`ekyc-session-orchestration`) and evidence of certificate validity verification (`jlis-yukousei-kakunin`) can be part of or back up these verification/transaction records. Align the server-side preservation design with these skills.
- **The 10-year validity period for consent information (`doui-jouhou-kanri`) is a separate system** (user consent for the latest user information (4 attributes) provision service). Do not confuse it with the 7-year record preservation under the Act on Prevention of Transfer of Criminal Proceeds, as the legal basis, starting dates, and targets are different.
- Check Article 20 (31 items) of the Enforcement Ordinance for details on matters to be stated in verification records, and Article 19 for creation methods and attached documents. The Secondhand Articles Dealer Act uses books, etc. rather than verification records (Articles 16 and 18 of the Act, 3-year retention; `references/hourei-eKYC.md` §5). The details of recording obligations under the Mobile Phone Fraud Prevention Act are noted in `## Unverified Items`.

## Purpose-Specific Method Selection Flow

Identify the applicable law and select a method to implement from the available ones. See the table "Purpose-Specific Quick Reference" in `references/method-map.md` for a detailed quick reference.

- [ ] Identify one or more legal bases for eKYC (Act on Prevention of Transfer of Criminal Proceeds - account opening, etc. / Mobile Phone Fraud Prevention Act / My Number Act - My Number collection / Secondhand Articles Dealer Act).
- [ ] If the Act on Prevention of Transfer of Criminal Proceeds is the basis: Design on the premise of April 1, 2027, onwards. Assume methods involving only image photographing (current ho, photographing types of current to/current chi) will be unusable under the Act on Prevention of Transfer of Criminal Proceeds, and lean toward IC reading systems / Public Personal Authentication systems.
- [ ] Choose a method to use under the Act on Prevention of Transfer of Criminal Proceeds: Public Personal Authentication (JPKI = current ka / new nu, **verify signature verifier requirements**) / IC reading + facial photographing (current he / new ha) / face-to-face IC reading + card-face matching (new i) / transmission of smartphone-mounted My Number Card (current ru / new to) / IC reading + bank inquiry / sending originals of copy of resident register, etc. + non-forwardable mail (for those without IC).
- [ ] If the Mobile Phone Fraud Prevention Act is the basis: **The revision is already enforced (2026-04-01)**. Choose from IC reading + facial photo (current ha), IC chip record + non-forwardable mail (current ni), restricted delivery mail (current he), electronic signature (current to), transmission of smartphone-mounted My Number Card (current chi).
- [ ] If the My Number Act / My Number collection is the basis: Presentation/IC reading of Individual Number Card (card-face verification AP + card-face input-assist AP), or Public Personal Authentication (details must be confirmed in the Ordinance for Enforcement of the My Number Use Act, refer to `mynumber-card-ic` / `kenmen-jikou-kakunin-ap`).
- [ ] If the Secondhand Articles Dealer Act is the basis: Choose from Article 15, Paragraph 3 of the Enforcement Ordinance (JPKI = Item 11, **limited to signature verifiers**, occupation included in the signed data / IC reading + face image = Item 9, etc.; "## 古物営業法" in `references/method-map.md`). There is no type that transmits the smartphone-embedded card's specified electromagnetic record. Note that no 2027 amendment is registered on e-Gov (as of 2026-10-05).
- [ ] For each selected method, conduct a final verification of the enforcement date and method designation with `references/method-map.md` and e-Gov primary articles, and transcribe unverified items into the design documents.
- [ ] Evaluate the trade-off between implementation cost and drop-off rate (`## Recommendations in This App`).

## Recommendations in This App

**The ka method (Public Personal Authentication / JPKI = current ka, new nu from 2027 onwards) should be fundamentally placed at the center.**

- The four basic attributes (name, residence, date of birth, gender) can be obtained with a signing certificate, and it will be retained after the April 2027 revision (new nu). Inquire to J-LIS about validity (via a PF operator) and verify the electronic signature (`jpki-overview` / `jlis-yukousei-kakunin`).
- The Act on Prevention of Transfer of Criminal Proceeds, the Mobile Phone Fraud Prevention Act (current to) and the Secondhand Articles Dealer Act (Enforcement Ordinance Article 15, Paragraph 3, Item 11) all have a JPKI method, making it easy to maintain a single flow across laws. However, under the Secondhand Articles Dealer Act the electronic signature must cover a record of address, name, occupation and age ("## 古物営業法" in `references/method-map.md`).
- **However, note the proviso**: To use it for transaction verification, the company must be a signature verifier (see "## To use the ka method (JPKI)..." above).

**As a drop-off rate countermeasure, prepare the he method (IC chip reading + facial photographing = current he, new ha from 2027 onwards) as a fallback in conjunction.**

- A safety net for users who cannot complete JPKI due to the signing certificate password (6-16 alphanumeric characters, locks after 5 attempts), expiration, or non-issuance.
- Because it is an IC reading method, it will be retained as new ha (IC reading + facial photo) even after the April 2027 revision.
- **The facial photo in the IC is not in the card-face input-assist AP**. Combine the four basic attributes = card-face input-assist AP (`kenmen-nyuryoku-hojo-ap`) and the facial photo in the IC = card-face verification AP (`kenmen-jikou-kakunin-ap`).
- LIQUID materials also state that "introducing the he method is key to maintaining a drop-off rate close to that of identity verification by image photographing (ho method, etc.)" (vendor view).

**Do not make methods involving only image photographing (ho method, etc.) the main route for the Act on Prevention of Transfer of Criminal Proceeds.** They will become unusable under the Act on Prevention of Transfer of Criminal Proceeds on April 1, 2027. Consider them only for applications other than the Act on Prevention of Transfer of Criminal Proceeds.

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- **`references/hourei-eKYC.md`** — Primary article excerpts obtained from the e-Gov e-Laws search API (Article 6, Paragraph 1, Item 1 of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds: current `420M60000F5A001_20260806_508M60000F5A006` / April 2027 version `420M60000F5A001_20270401_508M60000F5A005`, Article 19 of the same, Article 3 of the Ordinance for Enforcement of the Mobile Phone Fraud Prevention Act `417M60000008167_20260806_508M60000008099`, Article 17 of the Public Personal Authentication Act `414AC0000000153_20260614_506AC0000000059`). Primary source for method designations and provisos. Acquired 2026-09-10. Article 15 of the Ordinance for Enforcement of the Secondhand Articles Dealer Act `407M50400000010_20260812_508M60400000017` and Articles 15, 16 and 18 of the Secondhand Articles Dealer Act `324AC0000000108_20250601_504AC0000000068` are in §5 (acquired 2026-10-05).
- `references/method-map.md` (Identity Verification Method Correspondence Table) — The official record of designation lists, obtained data, supported documents, enforcement dates, and unverified items for the Act on Prevention of Transfer of Criminal Proceeds, Mobile Phone Fraud Prevention Act, and Secondhand Articles Dealer Act.
- e-Gov e-Laws search: <https://laws.e-gov.go.jp/law/420M60000F5A001> (Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds. Unenforced version is `?asof=2027-04-01`), <https://laws.e-gov.go.jp/law/417M60000008167> (Ordinance for Enforcement of the Mobile Phone Fraud Prevention Act), <https://laws.e-gov.go.jp/law/414AC0000000153> (Public Personal Authentication Act), <https://laws.e-gov.go.jp/law/419AC0000000022> (Main Act of the Act on Prevention of Transfer of Criminal Proceeds. Article 6 = creation/7-year preservation of verification records, Article 7 = creation/7-year preservation of transaction records), <https://laws.e-gov.go.jp/law/407M50400000010> (Ordinance for Enforcement of the Secondhand Articles Dealer Act), <https://laws.e-gov.go.jp/law/324AC0000000108> (Secondhand Articles Dealer Act).
- NPA JAFIC "Q&A regarding the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds Revised in Reiwa 8 (promulgated on March 6, Reiwa 8)" (`260306qa.pdf`) <https://www.npa.go.jp/sosikihanzai/jafic/hourei/data/260306qa.pdf> — Enforcement date "April 1, Reiwa 9" (Q2), IC chip reading/card-face matching, Public Personal Authentication, completed verifications.
- NPA JAFIC "Q&A regarding... the Reiwa 7 Revision (Abolition of methods for verifying identity matters with a high risk of spoofing, etc.) (promulgated on June 24, Reiwa 7)" <https://www.npa.go.jp/sosikihanzai/jafic/hourei/data/25062402qa.pdf>
- NPA JAFIC "Q&A regarding... the Reiwa 7 Revision (New establishment of methods for verifying identity matters using new technologies, etc.) (promulgated on June 24, Reiwa 7)" <https://www.npa.go.jp/sosikihanzai/jafic/hourei/data/25062401qa.pdf> — New establishment of the ru method, transmission of facial images not required, generally for ages 15 and over.
- Financial Services Agency "Promulgation, etc. of the 'Order to Partially Amend the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds'..." (June 26, Reiwa 8) <https://www.fsa.go.jp/news/r7/sonota/20260626/20260626.html> — Enforcement date "April 1, Reiwa 9".
- Ministry of Internal Affairs and Communications "Direction of Reviewing Identity Verification Methods Based on the Mobile Phone Fraud Prevention Act" (Document 3-2, April Reiwa 6) <https://www.soumu.go.jp/main_content/000942596.pdf> — Background of the review (provisions confirmed on e-Gov above).
- `references/pdfs/33_guide-liquid-ekyc.pdf` p7–12 (Guide to LIQUID eKYC v2.11, 2026-04-13 version) — Obtained data, supported documents, views on drop-off rates. *Vendor material. Method designations and dates require confirmation in primary materials (for the Secondhand Articles Dealer Act item correspondence, primary source §5 prevails).
- `references/pdfs/05_private-sector-guidelines-v1.8.pdf` (Guidelines for Private Business Operators Version 1.8, 2026-04-13) — Four basic attributes and fees for JPKI.
- `references/jpki-introduction.ja.md` (§6 Functional Enhancements. Digital Agency, acquired 2026-09-07) — Latest 4 attributes provision service, smartphone-mounted electronic certificates.

## Last Verified

2026-10-05

(The Secondhand Articles Dealer Act section was verified against the e-Gov primary text. Other sections remain as verified on 2026-09-11.)

## Unverified Items

See also `references/method-map.md` "## Unverified Items" (treating that file as the primary source).

- **Article-by-article requirements and branch numbers of each item in Article 6, Paragraph 1, Item 1 of the 2027 version of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds.** The new designation table in this skill / `method-map.md` is based on excerpt summaries from the e-Gov API v2, and article-by-article matching against the old-new comparison text has not been completed. Especially branch numbers for i, ro, ni, ho, and requirements for he, wa.
- ~~Whether the 2027 new designation for JPKI is "nu"~~ → **Resolved (2026-10-05).** The verbatim text of Article 6, Paragraph 1, Item 1, nu in revision `420M60000F5A001_20270401_508M60000F5A005` confirms new nu = JPKI (with the signature-verifier proviso) and new ru = specified certification business (`references/hourei-eKYC.md` §2). Provisions not yet in force may be amended again.
- **The relationship between "Order No. 1" and "Order No. 5" of the Reiwa 8 revision.** The NPA JAFIC is based on Order No. 1, while the e-Gov 2027-04-01 revision is based on Order No. 5 (promulgated on June 26, 2026). Whether this is a series of revisions or an overlap needs confirmation via old-new comparison text.
- **The article-by-article breakdown of the supplementary provisions of the Ordinance for Enforcement of the Mobile Phone Fraud Prevention Act (enforcement date and transitional measures).** The enforcement on April 1, 2026, and transitional measures until September 30, 2026, were verified on e-Gov during the review on September 10, 2026 (the excerpt of the supplementary provision text is not included). The article-by-article breakdown of the supplementary provision text itself needs to be finalized.
- **Future amendments to the Ordinance for Enforcement of the Secondhand Articles Dealer Act.** The correspondence between each item of Article 15, Paragraph 3 and the methods under the Act on Prevention of Transfer of Criminal Proceeds was verified against the e-Gov primary text on 2026-10-05 (`references/hourei-eKYC.md` §5). No amendment linked to the 2027 revision of the Act on Prevention of Transfer of Criminal Proceeds is registered on e-Gov (as of 2026-10-05), but whether there will be one is unverified. The format of the books, etc. (Enforcement Ordinance side) is also unverified (the 10,000-yen exemption amount and the excepted articles were verified in Article 16 of the Enforcement Ordinance).
- **The method designations and provisions for identity verification methods when acquiring My Numbers based on the Ordinance for Enforcement of the My Number Use Act.** Only an outline is provided in this skill.
- **Items to be stated in verification records (Article 20 of the Enforcement Ordinance), breakdown of "dates specified by an ordinance of the competent ministry", and methods of attaching copies of identity verification documents.** The 7-year preservation period and starting date (Article 21 "whichever comes later") have been verified. The details of recording obligations under the Mobile Phone Fraud Prevention Act are also unverified (the books, etc. under the Secondhand Articles Dealer Act = Articles 16 and 18 of the Act, 3-year retention, have been verified).
