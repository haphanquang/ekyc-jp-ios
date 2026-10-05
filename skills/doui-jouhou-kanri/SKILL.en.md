---
name: doui-jouhou-kanri
description: Use when storing and managing user consent acquired via the "Latest User Information (4 Attributes) Provision Service" on the server side. Covers management of consent information (server), items to save for the latest 4 attributes consent, 10-year validity period of consent and withdrawal (revocation), response to disclosure requests, transmission to J-LIS via platform operators, and non-retention of signing certificates. For consent screen UI and wording of the 15 consent items, see `kihon-4-jouhou-doui`; for identity verification methods and record preservation under the Act on Prevention of Transfer of Criminal Proceeds, see `honnin-kakunin-houhou`.
---

# Server-Side Management of Consent Information (Latest User Information (4 Attributes) Provision Service)

Procedures and checklists for how to save, manage the lifecycle of, and transmit to J-LIS the user consent acquired via the "Latest User Information (4 Basic Attributes) Provision Service" on the server side.

- The requirements for the consent screen and the **actual wording** of the 15 items in the "Details and Supplementary Explanations of Consent Matters" are in `kihon-4-jouhou-doui`. This skill treats the 15 items only as a **compliance checklist** (e.g., "is ~ implemented?") and does not reproduce the full text.
- Selection of identity verification methods, designations under the Act on Prevention of Transfer of Criminal Proceeds / Mobile Phone Fraud Prevention Act, and application dates are in `honnin-kakunin-houhou` / `references/method-map.md`. **The obligation to preserve verification records under the Act (7 years from contract end date, etc.) is in "Creation and Preservation of Verification Records" of `honnin-kakunin-houhou`.** Both are separate systems with different source articles, starting dates, and targets from the "10-year validity period of consent" handled in this skill, and this skill does not assert them.
- For cryptographic processing of signature verification, see `signature-verification`; for validity verification, `jlis-yukousei-kakunin`; for session state transitions and audit logs, `ekyc-session-orchestration`.
- "Head office (Honsha)" = Service Provider Operator (SP Operator) / Signature Verifier, "PF Operator" = Platform Operator, "Agency (Kikou)" = Japan Agency for Local Authority Information Systems (J-LIS).

## When to Use This Skill

- When deciding what to save (and what not to save) in the server's consent information database after receiving consent for the latest 4-info provision service.
- When designing the state management for the consent's validity period (10 years), renewal notices, and withdrawal (revocation).
- When designing the contact point and procedures for responding to disclosure requests from users (disclosure of acquisition date/time and acquired information).
- When designing the flow to transmit acquired consent information to the Agency via a PF operator.
- When deciding how long to retain the signing certificate and electronic signature received during signing.

## Items to Save / Items Not to Save

Consent information is saved and managed by building an in-house database, etc. (PDF 09 Detailed Explanation 5, PDF 05 §5(3)①). Each operator and the Agency independently store and manage consent information.

### Items to Save

- [ ] **Date and time of consent:** The date the fact of consent was reflected in the Agency's system (= "Date of consent". PDF 09 Detailed Explanation 8). Record the reception time as well.
- [ ] **Target items consented to:** Which among address, name, date of birth, and gender the user consented to (the Agency provides only the consented items. PDF 05 §5(3)).
- [ ] **Unit of consent (service):** Consent is per SP operator service. If acquired in bulk, the list of target services (PDF 09 Detailed Explanations 6, 7).
- [ ] **Version/text of displayed consent wording:** The version of the consent screen and "Details/Supplementary Explanations" shown to the user (so it can be disclosed/explained later).
- [ ] **Consent ID / Acquisition route:** Whether it was acquired via your own consent screen or via Mynaportal's "Personal Consent Acquisition Support Service" (PDF 11). An identifier used for matching with the Agency/PF operator.
- [ ] **Validity period / State:** Starting date, scheduled expiration date, current state (Valid / Renewal notified / Revocation received / Revocation reflected / Expired).
- [ ] **Transmission result to the Agency:** Date and time of transmission via PF operator, acceptance result, errors (For auditing. Align with audit logs in `ekyc-session-orchestration`).

**To be confirmed (undecided whether to include in saved items): The issuance number (serial number) of the signing certificate.** It is provided as a linkage key from the Agency to the PF operator, but PDF 05 §5(3) states that the issuance number is "not included in the contents provided to the service provider operator and is not subject to consent." Check the latest PF operator specifications regarding the scope the SP operator receives and saves, and do not make it a default save item until finalized. -> `## Unverified Items` (Same as unverified items in `kihon-4-jouhou-doui`)

### Items Not to Save

> **Scope:** This "non-retention" rule governs the signing certificate and electronic signature submitted by the user during the **acquisition of consent for the latest 4-info provision service** (PDF 09 Detailed Explanation 6). **Transaction verification under the Act on Prevention of Transfer of Criminal Proceeds via Method Ka (JPKI / New Nu) is separate**, requiring "electromagnetic records sufficient to prove that verification was performed" (in practice, the electronic signature and signing certificate) to be attached to the verification record and saved for 7 years under Article 19, Paragraph 1, Item 2 of the Ordinance for Enforcement of the Act (`references/hourei-eKYC.md` §1, `honnin-kakunin-houhou` "Creation and Preservation of Verification Records", `signature-verification` "What to retain/not retain after verification"). **Design the consent info store (non-retention, 10 years) and the Act's evidence store (signature + certificate, 7 years) separately.**

- [ ] **The signing certificate itself submitted by the user** is not retained (for the purpose of the consent service). PDF 09 Detailed Explanation 6: "The head office will not retain the signing certificate submitted by the customer." Do not leave certificate DERs beyond the scope necessary for matching/verification (issuance number [retention TBC, see above], verification result, consented items).
- [ ] **The raw electronic signature after consent registration** is not retained (for the purpose of the consent service). The signature is used to show the person's intent, and once provided to the Agency via the SP and PF operators, leave only the evidence needed for verification results and auditing (success/failure of signature verification, timestamps, identifiers). Do not leave raw values, private keys, or PINs (align with "Do Not Save" items in `signature-verification` / `ekyc-session-orchestration`).
- [ ] **Consent information that is no longer necessary to save** must be deleted promptly (PDF 09 Detailed Explanation 5, based on the Public Personal Authentication Act, Personal Information Protection Act, and other laws).
- [ ] The handling of the **latest 4 basic attributes** acquired from the Agency constitutes the result data of this service, not consent information. For deletion upon service suspension/certification revocation, see PDF 05 §5(6) A. PF operators do not store the 4 attributes and destroy them after provision (PDF 05 §5(1)).

## Validity Period and Withdrawal (Revocation)

### Validity Period (PDF 09 Detailed Explanation 8)

- The validity period of the acquired consent is, **in principle, 10 years starting from the day after the date of consent**.
- **The "date of consent" is the date the fact of consent was reflected in the Agency's system.**
- **Even if the signing certificate is revoked multiple times** within the validity period, the consent remains valid (reissuance/revocation does not require re-doing the consent).
- Users can apply to revoke consent **at any time** during the validity period.
- Before and after the 10 years elapse, the signature verifier must **prompt the user to renew their consent** (PDF 05 §5(3)⑤). Also, send a reminder to reconfirm/modify consent items at least once a year (PDF 05 §5(6) A ④).
- The starting reference date differs between documents: PDF 09 says the day after "the day it was reflected in the Agency's system", while PDF 05 §5(3)⑤ says the day after "the SP operator received it" (e.g.: Received 2023-05-18 10:00:00 -> Starts 2023-05-19 00:00:00 -> Expires 2033-05-18 23:59:59). -> `## Unverified Items`

### Withdrawal (Revocation)

- Revocation can be done **per service**, ending/stopping provision only for that service (PDF 09 Detailed Explanation 10).
- When the fact of revocation is **reflected in the Agency's system**, the validity period is deemed to have ended, and the provision of the latest 4 attributes from the Agency to the head office stops (PDF 09 Detailed Explanation 10). The Agency can stop it immediately upon receiving the revocation application (PDF 05 §5(4)).
- **Identity verification for revocation uses the signing certificate** (since it involves sending an electronic document for consent revocation). **Identity verification for inquiries uses the user-authentication certificate, etc.** (PDF 09 Detailed Explanation 12, PDF 05 §5(5)①②).
- The receiving party is in principle the SP operator (head office My Page / contact point). Outside business hours, for bulk revocation across multiple operators, or in emergencies, users can inquire/revoke themselves using the Agency-provided app "User Client Software (JPKI Mobile; Windows/Android/Mac/iOS versions)" (PDF 09 Detailed Explanation 13, PDF 05 §5(5)).
- **The Agency does not automatically notify of consent revocations.** For revocations via the User Client Software, the PF operator acquires revocation info from the Agency using IDs assigned per SP operator, and the SP operator grasps the revocation status by querying via the PF operator (PDF 05 §5(5)③). Design periodic fetching of revocation status.
- **Re-consenting after revoking via the User Client Software is not possible via the User Client Software.** It must be done by re-consenting on the head office My Page or contacting the contact point (PDF 09 Detailed Explanation 14, PDF 05 §5(5)④). Clearly state this path in the help/consent items.

## Handling Disclosure Requests

PDF 09 Detailed Explanation 4, PDF 05 §5(6) A ②.

- [ ] Prepare procedures to disclose the **date and time the latest 4 basic attributes were acquired** and the **acquired information**, etc., upon user request.
- [ ] **Verify that the requester is the principal**. In practice, verify identity for inquiries using the user-authentication certificate, etc. (PDF 09 Detailed Explanation 12).
- [ ] Conduct the procedure after they fill out a **prescribed format**, and reply at a later date.
- [ ] Establish a **prescribed fee**.
- [ ] Pre-announce the contact point and procedures for disclosure requests in the privacy policy, terms of use, etc., making them clear before acquiring consent (PDF 05 §5(6) A ②).

## Transmission Flow to the Agency (Via Platform Operator)

- [ ] Acquire consent **only electronically (no paper)**. Acquire it via **electronic signature using the signing certificate** on the My Number Card (or installed on a smartphone) (PDF 09 Detailed Explanation 6, PDF 05 §5(3)②).
- [ ] Send the acquired consent information and electronic signature electronically through the route **SP Operator -> PF Operator -> Agency** (PDF 09 Detailed Explanation 5, PDF 05 §5(3)①). Provided to the Agency along with the validity verification of the signing certificate (PDF 09 Detailed Explanation 6).
- [ ] **Do not query/send directly to the Agency (J-LIS) from in-house servers/apps. Always route through a PF operator** (see `jpki-overview` / `jlis-yukousei-kakunin`).
- [ ] After transmission, **the consent information is saved and managed respectively by the SP Operator, PF Operator, and Agency** (PDF 05 §5(3)①). Ensure your in-house saved contents can be checked against the state on the Agency's side (within validity, not revoked, consented items) (the Agency checks this when providing the latest 4 attributes. PDF 05 §5(2)⑥⑦).
- [ ] Leave transmissions, acceptances, and errors in the audit log (`ekyc-session-orchestration`). Do not leave raw signatures or certificate DERs even in audit logs.
- [ ] Upon service suspension/termination, coordinate the service stop date in advance to the Agency via the PF operator to stop provision from the Agency (PDF 05 §5(6) B ①).

## 15-Item Compliance Checklist

Verify that the 15 items of PDF 09 "II Details and Supplementary Explanations of Consent Matters" are reflected on the consent screen and in your operations. **For the wording of each item and whether it is [Required] / [Optional], `kihon-4-jouhou-doui` "15 items described in 'Details and Supplementary Explanations of Consent Matters'" is the source of truth.** Here, only the implementation verification perspectives are listed.

- [ ] **1 Provision Agency -> Head Office [Required]:** Does it state that it will request via a PF operator from the Agency, and that consented info + issuance number will be provided? Does it include that it won't be provided while the certificate is revoked?
- [ ] **2 Provision PF Operator -> Head Office [Optional]:** If applicable, is it stated?
- [ ] **3 Purpose of Use [Required]:** Is the purpose of using the latest 4 info acquired from the Agency specifically defined and published on a website, etc.? Is there a procedure to notify/publish changes?
- [ ] **4 Disclosure Request Procedure [Required]:** Are the procedures in `## Handling Disclosure Requests` (identity verification, prescribed format, fee, later reply) prepared and guided in the consent matters?
- [ ] **5 Saving and Management of Consent Info [Required]:** Is it appropriately saved as per `## Items to Save / Items Not to Save`, with a lifecycle to promptly delete when unneeded? Does it state that it is also managed by the PF operator and Agency?
- [ ] **6 Consent Acquisition Method [Required]:** Is paper excluded and is it **electronic acquisition only**? Is it acquired via **electronic signature using the signing certificate**, and is the **submitted signing certificate not retained**? Is the unit of acquisition **per service**?
- [ ] **7 Bulk Acquisition of Consent [Optional]:** If acquiring in bulk, are the target services specifically and comprehensively specified, and is explicit consent acquired for each service?
- [ ] **8 Validity Period of Consent, etc. [Required]:** Is it managed as per `## Validity Period and Withdrawal` (starts day after consent, consent day = Agency system reflection day, **10 years**, consent remains valid even if certificate is revoked, revocable at any time)? Is there a renewal notice flow?
- [ ] **9 Ensuring Voluntariness [Required]:** Does it state they will not suffer disadvantage if they do not consent, and does operation match this?
- [ ] **10 Provision Stop by Revocation [Required]:** Is there a process to deem the validity period ended when the revocation is reflected in the Agency system, and stop provision for that service only?
- [ ] **11 Provision Stop due to Service Suspension, etc. [Optional]:** If applicable, is provision stop from the day after the service stop date coordinated with the Agency?
- [ ] **12 Contact for Inquiries/Revocation and ID Verification [Required]:** Is there a route to head office My Page / contact point, and is identity verified via **user-authentication for inquiries** and **signing for revocation**?
- [ ] **13 Inquiries/Revocation via User Client Software [Required]:** Does it state that the user can inquire/revoke themselves via JPKI Mobile, with the Agency's download URL? Is there a flow to fetch revocation info (via PF operator)?
- [ ] **14 Re-consent after Revocation via User Client Software [Optional]:** Does it state that re-consenting via JPKI Mobile is not possible, and must be done at the head office My Page / contact point?
- [ ] **15 Contact Point [Required]:** Are company name, address, and TEL listed?
- [ ] **Structure of Consent Screen:** Does it meet the "Requirements for the Consent Screen" in `kihon-4-jouhou-doui` (independent title, summary, Agree/Disagree, link to detailed explanation)?
- [ ] Did you consider using Mynaportal's "Personal Consent Acquisition Support Service" to acquire consent from existing customers? (PDF 11, `kihon-4-jouhou-doui`).

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/pdfs/09_latest-user-info-obtaining-consent.pdf` — "Regarding the Acquisition of Consent for the Latest User Information (4 Basic Attributes) Provision Service based on the Public Personal Authentication Act" (MIC / Digital Agency). II Details and Supplementary Explanations of Consent Matters 15 items. Especially detailed explanations **4** (Disclosure requests: disclosure of acquired date/time/info, ID verification, prescribed format, fee, later reply), **5** (Appropriate saving/management of consent info, prompt deletion when unneeded, send to Agency via PF operator, also managed by PF operator/Agency), **6** (No paper/electronic only, electronic signature via signing certificate, submitted to head office and PF operator and provided to Agency along with validity check, per service, **"The head office will not retain the signing certificate submitted by the customer"**), **8** (**"The validity period of the consent acquired from the customer is, in principle, 10 years starting from the day after the date of consent. The date of consent is the date the fact of consent was reflected in the Agency's system. Even if the signing certificate is revoked multiple times within the validity period, the consent remains valid. Customers can apply to revoke consent at any time during the validity period."**), **10** (Deemed expired when revocation reflects in Agency system, provision stops, per service), **12** (Inquiry = user-authentication certificate, Revocation = signing certificate, head office My Page or contact point), **13** (User inquiry/revocation via User Client Software (JPKI Mobile)), **14** (No re-consent via User Client Software, re-consent at head office My Page, etc.).
- `references/pdfs/10_platform-operators-4-info-list.pdf` — "List of Platform Operators Supporting the Latest User Information (4 Attributes) Provision Service" (As of June 10, 2026). Consent info/4 info passes through PF operators.
- `references/pdfs/11_personal-consent-support-mynaportal.pdf` — "'Personal Consent Acquisition Support Service' of the '4 Basic Attributes Provision Service' leveraging Mynaportal". Consent flow via QR/links, linked info (consent info, certificate info, PPID, customer identifier, etc.), J-LIS/PF operators hold consent info/certificate info.
- `references/pdfs/05_private-sector-guidelines-v1.8.pdf` (§5 "Overview of Latest User Info (4 Basic Attributes) Provision Service based on Personal Consent", pp 43-50, v1.8, April 13, 2026). §5(1) (4 info stored/managed by Agency, verifier, SP operator; PF operator destroys after provision), §5(3)① (Consent sent SP -> PF -> Agency, each builds DB and saves/manages), §5(3)② (Electronic only, signing certificate, smartphone OK), §5(3)⑤ (Start date = day after SP received, 10 years, prompt renewal, expiration example 2023-05-18 receive -> 2033-05-18 expire), §5(4) (Revocation stops immediately, signing certificate), §5(5) (Inquiry/revocation via User Client Software (Win/Android/Mac/iOS), ①Inquiry=user-auth, ②Revoke=signing, ③Agency does not auto-notify, PF operator fetches revocation info via SP ID, ④Re-consent at SP), §5(6) A ② (Prep for disclosure requests, ID verify, prescribed format, advance notice), §5(6) A ④ (Reminder roughly once a year), §5(6) B ① (Stop provision by advancing service stop date).
- `references/jpki-introduction.ja.md` (§6.1 "Latest User Info (4 Attributes) Provision Service" started May 16, 2023, §6.1.1 "Personal Consent Acquisition Support Service" started Oct 29, 2024. Digital Agency, retrieved 2026-09-07).
- Live URL: <https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction> (Digital Agency "Public Personal Authentication Service (JPKI)". §6.1 has overview of this service, consent notes docs, link to PF operator list. Retrieved 2026-09-07)

## Last Verified

2026-09-11

## Unverified Items

- **The reference starting date for the 10-year validity period.** PDF 09 Detailed Explanation 8 says the day after "the day the fact of consent was reflected in the Agency's system", while PDF 05 §5(3)⑤ says the day after "the day the SP operator received consent from the user". The text does not match. This skill mainly adopts PDF 09's wording; verify the practical reference date against PF operator/Agency specifications.
- **Whether the consent info saved/received by the SP operator includes the "issuance number (serial number) of the signing certificate".** PDF 09 Detailed Explanation 1 lists the issuance number as a provision item from Agency -> PF operator, but PDF 05 §5(3) excludes it from SP operator provision and consent targets. Confirmation of saved items depends on the latest PF operator specifications (same as unverified items in `kihon-4-jouhou-doui`).
- **Specific judgment criteria and deletion deadlines for "when it is no longer necessary to save".** PDF 09 Detailed Explanation 5 merely states "promptly delete". How long and to what extent consent info can be retained (including for litigation/audits) after expiration/revocation is unverified in primary sources. Confirm retention requirements under the Personal Information Protection Act and Public Personal Authentication Act with legal/PF operators.
- **Relationship with the obligation to preserve verification records under the Act on Prevention of Transfer of Criminal Proceeds.** Record preservation under the Act (Verification records: 7 years from contract end date, etc. [Article 6], Transaction records: 7 years from transaction date [Article 7]) is a separate system from the consent validity period (10 years) handled in this skill. For periods, start dates, and legal basis, refer to "Creation and Preservation of Verification Records" in `honnin-kakunin-houhou`; this skill does not assert them.
- **Details of message formats, items, and APIs for transmitting consent info to the Agency/PF operator.** Primary sources (PDF 09/05) only state "transmit electronically" and "via PF operator". Specific interfaces must be confirmed via technical specifications disclosed by the PF operator (`platform-jigyousha`).
