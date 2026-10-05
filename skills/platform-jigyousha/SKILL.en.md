---
name: platform-jigyousha
description: Used when considering introduction procedures and schedules, including role division between platform operators (PF operators) / service provider operators (SP operators), necessity of competent minister certification, delegation of certificate validity verification, selection of eKYC vendors (PF operators), and J-LIS examination. Covers why a certified operator is required even if the app directly reads the My Number Card using CoreNFC.
---

# Platform Operators (PF Operators) and Vendor Selection

A reference summarizing why eKYC / identity verification apps using My Number Cards still require a platform operator (PF operator) certified by the competent minister, even if the IC chip can be read directly via CoreNFC. Summarizes the differences between PF operators and SP operators, CRL method and OCSP method, a list of major operators, selection criteria, introduction procedures, and schedules.

See `jlis-yukousei-kakunin` for implementation procedures of certificate validity verification, `signature-verification` for signature verification, and `jpki-overview` for the overall picture. See `honnin-kakunin-houhou` and `references/method-map.md` for the names and timing of identity verification methods under laws and regulations; this skill does not make definitive statements about them.

## When to Use This Skill

- When deciding where to delegate validity verification after designing the app to directly read the IC chip via CoreNFC
- When deciding whether to become a PF operator or to delegate to a PF operator as an SP operator
- When comparing multiple eKYC vendors (PF operators) and making a selection
- When estimating the introduction schedule and wanting to grasp the period required for J-LIS examination/application
- When considering whether to receive validity verification via the CRL method or the OCSP method

## Why a Certified Operator is Required

**Technically, it is possible for an app to directly read the electronic certificate from the IC chip using either the He-method or the Ka-method** (for reading method designations, see `references/method-map.md`). However, regarding the "certificate validity verification" to confirm whether the read electronic certificate is **currently valid** (not revoked due to moving, name change, reissue, death, moving overseas, etc.), **only operators certified by the competent minister based on the Public Personal Authentication Act can inquire with J-LIS**.

| Category | Definition | Competent Minister Certification | Signature Verification Equipment | Validity Inquiry to J-LIS |
|---|---|---|---|---|
| Platform operator (PF operator) | A private operator that verifies the validity of electronic certificates with J-LIS itself. Can provide validity verification functions to other operators as a "platform" | **Required** (Article 17, Paragraph 1, Item 6 of the Act) | Maintained in-house (cloud type is also possible) | Inquires itself |
| Service provider operator (SP operator) | An operator that does not have signature verification equipment in-house and provides services by delegating the certificate validity verification to a PF operator | Not required | Not required | Delegates to a PF operator (does not inquire itself) |

- When delegating the entirety of the "system for reception and validity verification of electronic certificates" to a PF operator, the PF operator can handle the certification and notification to the agency on behalf of each private operator (PDF 04). This reduces the burden on each company (the so-called "split-the-bill effect").
- **Apps envisioned by this plugin are usually SP operators**. They delegate validity verification via the SDK / API of a PF operator. Therefore, **in-house maintenance of signature verification equipment is not required**, and the practical handling of the certification examination is also handled by the PF operator. The lead time on the app side will mainly consist of the contract with the PF operator and the J-LIS examination in the case of the IC reading method (about 1 to 2 months, described later).
- **The app or an uncertified in-house server must not inquire directly with J-LIS.** It must always go through a PF operator.

### Proviso when using the Act on Prevention of Transfer of Criminal Proceeds Ka-method (JPKI) for transaction verification

"Competent Minister Certification Not required" in the table above means that **in-house maintenance of signature verification equipment is not required**. However, **this does not apply when performing transaction verification under the Act on Prevention of Transfer of Criminal Proceeds using the Ka-method (Public Personal Authentication / JPKI; new Nu-method from April 2027 onwards)**. The proviso in Article 6, Paragraph 1, Item 1 Ka of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds states "limited to cases where the specified business operator is a signature verifier prescribed in Article 17, Paragraph 4 of the Public Personal Authentication Act", and the **specified business operator itself must be a "signature verifier"** (= a person who has received competent minister certification under Article 17, Paragraph 1, Item 6 of the Public Personal Authentication Act and then notified the agency) (`references/hourei-eKYC.md` §1・§4, `honnin-kakunin-houhou`).

- A PF operator can **act on behalf of a specified business operator** to obtain competent minister certification, notify the agency, and maintain signature verification equipment (PDF 04), but the certification and notification are issued in the name of the specified business operator.
- If only methods that do not involve a signature, such as the He-method (IC reading + facial image), are used, this proviso is irrelevant (there is no need to become a signature verifier, and delegating validity verification is sufficient).
- **Blocking check before contracting**: Determine the item designation of the Act on Prevention of Transfer of Criminal Proceeds that your company uses (whether it includes Ka / new Nu), and if it does, check with legal affairs and the PF operator whether "the company needs to become a signature verifier," "to what extent the PF operator will act as an agent for acquiring certification/notification," and "the required period" (see onboarding below).

## CRL Method and OCSP Method

There are two types of validity verification methods: "CRL provision method" and "OCSP responder method" (jpki-introduction §5.1.2).

| Item | CRL provision method | OCSP responder method |
|---|---|---|
| Mechanism | Periodically provides a list of revoked electronic certificates (CRL. ※5 writes it as Certification Revocation List. Generally, Certificate Revocation List). The operator downloads it locally and checks it against the user's issuer number | A response server "OCSP responder" responds to the validity of a specific electronic certificate individually |
| Update frequency | Updated on a daily basis (once a day, etc.) | Updated on a 15-minute basis |
| Immediacy | Maximum time lag of about 1 day due to periodic updates | Real-time |
| Offline | **Can be verified even offline** | Cannot be verified offline (communication to the responder is required) |
| Fee handling | CRL method is permanently free | OCSP responder method is free for the time being for 3 years (from January 2023) |

- The electronic certificate verification fee to J-LIS is a pay-as-you-go system (20 yen/item for signing, 2 yen/item for user-authentication), but it is free for the time being from January 2023 (jpki-introduction §3.3).
- In the case of SP operators, a service usage fee set by the PF operator will be incurred separately from this (varies by operator).
- Which method can be provided depends on the PF operator. The OCSP method (real-time) is often suitable for applications where you want to check the latest status at the time of application, such as eKYC. For implementation of result processing, see `jlis-yukousei-kakunin`.

## List of Major Operators

In jpki-introduction §7.2.5 "Inquiries regarding services provided by platform operators, etc.", **25 operators** for which consent to publish was obtained are listed along with their contact information (see the original text for the full list and contact details). Below is a mapping of representative operators and service introduction materials in `references/pdfs/`. **Since there is no cross-sectional description in §7.2.5 or guide materials regarding which reading method/service each company supports, the "Supported methods/Fees/SDK/API" in the table below is, in principle, "Requires confirmation with each company".**

| Operator | Department in charge (Listed in §7.2.5) | Service introduction material (`references/pdfs/`) |
|---|---|---|
| Liquid, Inc. | Customer Success Dept. eKYC charge | `33_guide-liquid-ekyc.pdf` (LIQUID eKYC) |
| TRUSTDOCK Inc. | (Not listed) | `29_guide-trustdock-jpki.pdf` (TRUSTDOCK Public Personal Authentication) |
| PocketSign Inc. | (Not listed) | `23_guide-pocketsign-platform.pdf` (POCKETSIGN Platform) |
| GMO GlobalSign K.K. | GMO Online Identity Verification Service Inquiry Window | `15_guide-identity-verification.pdf` (GMO Online Identity Verification Service) |
| Double Standard Inc. | Data Management Group / Data Management Dept. | None in `references/pdfs/` (See the link "eKYC solution using public personal authentication" in §7.2.5) |
| NEC Corporation | Social Public Integration Management Div. New Business Creation Group | `16_guide-my-number-card-certification-service.pdf` (My Number Card Certification Service) |
| Cybertrust Japan Co., Ltd. | Trust Service Management Dept. | `18_guide-itrust-identity-verification.pdf` (iTrust Identity Verification Service) |
| NTT DATA Corporation | Social Infrastructure Solution Sector Digital Community Div. | `14_guide-bizpico.pdf` (BizPICO) |
| Cyber Links Co., Ltd. | Public Cloud Div. Public Sales Dept. Planning and Sales Sec. | `17_guide-maina-sign.pdf` (Myna Sign) |
| ACSiON, Ltd. | Sales Dept. | `27_guide-acsion-jpki.pdf` (ACSiON Public Personal Authentication Service) |
| NTT Communications Corporation | Business Solution Div. Social Innovation Dept. | `26_guide-smartlita.pdf` (SmartLiTA) |
| Primagest, Inc. | New Business Promotion Dept. | `32_guide-pridest-trust-services.pdf` (Primagest Trust Services) |

- Other operators listed in §7.2.5 (partial): ICT Town Development Common Platform Promotion Organization (myTAP), TOPPAN Inc., Nomura Research Institute, Ltd., Workthy Inc., TISI Inc., Flight Solutions Inc. (myVerifist), Bengo4.com, Inc. (CloudSign), milabo Inc. (mila-e Authentication), MRSO Inc., CrowdShip Co., Ltd. (CrowdShipTrust), MynaWallet Inc., JMDC Inc., AIFUL CORPORATION.
- Note: Some PF operators do not provide validity verification functions as a platform for SP operators (end of §7.2.5). First, confirm whether the candidate for delegation has a "provision for SP operators".

## Selection Criteria for Operators

Check each item for each candidate PF operator (most will only become clear from detailed materials after concluding an NDA. Unclear items should be left as "Requires confirmation with each company").

- [ ] **Does it provide validity verification functions for SP operators?** (Some PF operators do not provide them. End of §7.2.5)
- [ ] **Can it be combined with the app's CoreNFC direct reading?** (Is it possible to have a configuration where IC chip reading and electronic signature generation are performed within the in-house app, and the signature target data and signature are passed to the PF operator? TRUSTDOCK offers both SDK / provided app methods, GMO provides an API, etc., and the form depends on the operator)
- [ ] **Provision format: SDK or API?** (Native app SDK integration / Server-to-server API / Transition to operator-provided app. Does it match the app's UX requirements?)
- [ ] **Does it support IC reading methods (He-method / Ka-method)?** (The definitions and method designations change due to revisions, so refer to `references/method-map.md` / `honnin-kakunin-houhou`)
- [ ] **Validity verification method** (Can you choose between CRL method / OCSP responder method? OCSP if real-time capability is required)
- [ ] **Does it support the latest user information (4 attributes) provision service?** (If supported, consent information management is required. See `kihon-4-jouhou-doui` / `doui-jouhou-kanri`)
- [ ] **Support for multiple identity verification methods** (IC reading + facial image capture, card-face capture, etc. See `honnin-kakunin-houhou` / `references/method-map.md` for names and timing of legal methods)
- [ ] **Fraud detection functions** (Camera injection determination, facial authenticity determination, multi-account prevention, etc. LIQUID document p18-19)
- [ ] **Notation fluctuation absorption** (External characters / old character forms, normalization of address notation. See `signature-verification` for details)
- [ ] **Fee structure** (Initial cost / monthly / pay-as-you-go, necessity and cost of security check sheet response, etc. Requires confirmation with each company)
- [ ] **NDA** (Can the in-house template be used, or the counterparty's template? Conclusion may be required 2-3 weeks before the verification environment is constructed)
- [ ] **Japanese / English support, iOS / Android support**
- [ ] **Estimated introduction schedule** (Additional period for J-LIS examination in the case of the IC reading method. Described later)

## Procedure and Schedule

### When becoming a PF operator (usually not chosen for this app)

1. Exchange a pledge regarding confidentiality with J-LIS and apply for disclosure of technical specifications, etc. (jpki-introduction §3.2.1).
2. Respond to the requirements of the certification criteria and create certification documents. Apply for certification examination to the Digital Agency and the Ministry of Internal Affairs and Communications (§3.2.2, inquiries are §7.2.3).
3. After acquiring certification, confirm operation in the test environment → notify J-LIS, etc. → confirm operation in the production environment → start using the service (§3.2.3).

**Estimated period: About 6 months to 1 year from obtaining technical specifications, etc. to acquiring competent minister certification** (jpki-introduction §3.2). See pages 39-41 "C. Certification Procedure" of the Guidelines for Private Operators (Version 1.8) for an overview of the procedures.

### When becoming an SP operator (envisioned for this app)

Contract with a PF operator and delegate validity verification via its SDK / API. The following is an example based on LIQUID's introduction flow (PDF 33 p21, example of a custom plan). **Procedures, formats, and periods vary by PF operator.**

1. Confirm service overview.
2. **Conclude NDA** (To confirm detailed specifications. Must be concluded by 2 to 3 weeks before building the verification environment).
3. Confirm details with specification documents, etc. → Determine whether introduction is possible.
4. Agreement on price and schedule (Agreement on the production start date is required before creating the contract).
5. Confirm contract-related materials (Terms of Use, Specifications, Application for Use and Notification, etc.) → Conclude contract.
6. **Application procedure for IC reading method (He-method, Ka-method, etc.)**: Submit "Application documents for AID disclosure" and "Application documents for using the Public Personal Authentication Service". **Since J-LIS examination, etc. takes about 1 to 2 months**, early application is recommended, and submission is required 2 to 3 weeks before building the verification environment (PDF 33 p21 footnote).
7. In-house system development (SDK integration / SaaS linkage).
8. Build and provide verification environment → Confirm connection between both companies.
9. Build and provide production environment → Confirm connection between both companies → Start service.

**Estimated period (LIQUID example, PDF 33 p21 footnote):**

| Case | Maximum time from the month the verification environment is provided to the production environment provision |
|---|---|
| Normal | Maximum 6 months |
| IC reading method (He-method, Ka-method, etc.) | Since J-LIS examination, etc. takes about 1 to 2 months, **+2 months → Maximum 8 months** |

- Including the periods for overview confirmation, NDA, contracting, and system development preceding this, expect several months to half a year or more from initiation to production operation.
- "About 1 to 2 months J-LIS examination" is described in the PF operator's (LIQUID) document and is unique to the IC reading method. It is considered unnecessary if only general validity verification such as CRL / OCSP is used without IC reading.
- The above figures are an example for LIQUID. Since procedure names, formats, and required periods differ for other PF operators, be sure to check for each candidate.

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/jpki-introduction.ja.md` (§3 Methods of introducing the service [§3.1 Method of becoming an SP operator/PF operator, §3.2 Procedure for becoming a PF operator, §3.3 Usage fees], §5.1.2 Methods of validity verification of electronic certificates, §7.2.5 Contact information regarding services provided by platform operators, etc.)
- Live URL: <https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction> (Retrieved on 2026-09-07)
- `references/pdfs/04_jpki-platform-operator-system.pdf` (Platform operator system, delegation of competent minister certification/notification to the agency, split-the-bill effect)
- `references/pdfs/15_guide-identity-verification.pdf` (GMO Online Identity Verification Service, API usage, PF operator certification, account opening use case)
- `references/pdfs/29_guide-trustdock-jpki.pdf` (TRUSTDOCK, 2 formats: SDK / provided app, configuration diagram as an SP operator, support for multiple identity verification methods)
- `references/pdfs/33_guide-liquid-ekyc.pdf` (LIQUID eKYC. p18-19 Fraud detection/notation fluctuation, p21 "Flow to introduction" = NDA, AID disclosure application, Public Personal Authentication Service usage application, J-LIS examination about 1-2 months, schedule upper limit)
- `references/method-map.md` (Definitions of He-method/Ka-method. The legal names and timing are uniquely defined in this file and `honnin-kakunin-houhou`)

## Last Verified

2026-09-11

## Unverified Items

- Specific time of CRL updates ("every day at XX:XX", etc.): Primary sources only state "updated on a daily basis (once a day, etc.)", and the specific time is unverified.
- Cross-sectional comparison of each PF operator's support status: Support for IC reading of He-method/Ka-method, whether CRL / OCSP can be selected, support for the latest 4 attributes provision service, SDK / API provision format, fee structure, handling of NDA templates. Since there is no cross-sectional list for each company in §7.2.5 or the guide materials read, all of them "require confirmation with each company".
- Total lead time for SP operators: "Maximum 6 months from the month the verification environment is provided (IC reading method is +2 months, maximum 8 months)" and "J-LIS examination about 1 to 2 months" are both based on LIQUID (PDF 33 p21). Since procedure names, formats, and required periods differ for other PF operators, it cannot be generalized as is.
- Exact formats and submission destinations of "Application documents for AID disclosure" and "Application documents for using the Public Personal Authentication Service", and to what extent the PF operator acts as an agent/substitute for the application (whether the SP operator submits it themselves or via the PF operator): LIQUID materials only state "submit". Needs confirmation.
- Relationship between the Digital Authentication App / My Number Card Face-to-Face Verification App / MynaPortal Linkage, etc., and the "CoreNFC direct reading by app + delegation to PF operator" configuration assumed by this skill: Out of scope of this skill. If it affects the design, confirm with primary sources.
