# Identity Verification Method Correspondence Table (method map)

Last Verified: 2026-10-05 (Secondhand Articles Dealer Act section; other sections: 2026-09-11)

> This file and `skills/honnin-kakunin-houhou/SKILL.md` are the sole locations that define
> "method names and dates" under the Act on Prevention of Transfer of Criminal Proceeds, Mobile Phone Fraud Prevention Act,
> and Secondhand Articles Dealer Act. Other skills must refer to this file and must not assert names or dates on their own.
>
> Method designations (ho (ホ), he (ヘ), to (ト), chi (チ), etc.) and enforcement dates change frequently due to legal amendments. The primary source for method designations is
> `references/hourei-eKYC.md` (article excerpts + revision IDs retrieved from the e-Gov e-Laws API).
> Before implementation or legal judgment, always re-verify the text of the relevant revision on e-Gov e-Laws.
> Matters for which article-by-article matching has not been completed are explicitly noted in "## Unverified Items".

## Current (In Force) Methods for Individuals under the Act on Prevention of Transfer of Criminal Proceeds

Article 6, Paragraph 1, Item 1 of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds (verification methods for identity-specifying matters of individuals = natural persons).
The method designations are **15 items from i (イ) to yo (ヨ)**. Primary source: `references/hourei-eKYC.md` §1
(revision `420M60000F5A001_20260806_508M60000F5A006`). Details of acquired data and supported documents are also
supplemented by vendor materials (`references/pdfs/33_guide-liquid-ekyc.pdf` p9–12).

Main items (non-face-to-face / electromagnetic methods) that can be implementation targets in eKYC:

| Designation | Summary | Acquired Data | Supported AP / Documents | Notes |
|---|---|---|---|---|
| ho (ホ) | Receive transmission of a facial image taken with software provided by the specified business operator + an **image** of a photo identity verification document (image transmission + selfie) | Name, residence, date of birth, document image (side showing identity-specifying matters, features such as thickness, etc.), facial image | Photo documents such as driver's license, My Number Card, residence card, etc. | The so-called "Ho-method (ホ方式)". **Abolished in the April 2027 amendment** (see "## Enforced on April 1, 2027" below) |
| he (ヘ) | Receive transmission of a facial image + **IC chip recorded information** of a photo identity verification document (IC reading + facial image) | Name, date of birth, residence (and gender for My Number Card), **facial photo inside the IC chip**, facial image | For My Number Card: four basic attributes = **card-face input-assist application** (`kenmen-nyuryoku-hojo-ap`), facial photo in IC = **card-face verification application** (`kenmen-jikou-kakunin-ap`). For driver's license: PIN1/PIN2; residence card and special permanent resident certificate also accepted | Transitions to method designation **new ha (新ハ)** (IC reading + facial image) after the April 2027 amendment (below). Note that the facial photo in the IC is not in the card-face input-assist application and must be obtained via the card-face verification application |
| to (ト) | Receive transmission of an **image** or **IC chip recorded information** of an identity verification document + verification with another specified business operator or a small-amount bank transfer, etc. (bank API type) | Name, residence, date of birth, etc. | Photo identity verification documents | Image transmission type is abolished in the April 2027 amendment; IC reading type is retained (equivalent to new ni (新ニ)) |
| chi (チ) | Receive presentation or sending of an identity verification document + send transaction-related documents as non-forwardable mail, etc. | Name, residence, date of birth, etc. | Photo identity verification documents, (when sending originals) copy of the residence certificate, etc. | Method designation moves in the amendment (below) |
| ru (ル) | Receive transmission of **specified electromagnetic records** recorded in an **alternative electromagnetic record for a card** (My Number Card mounted on a smartphone) + confirmation that the record belongs to the customer | **Information on name, residence, date of birth, and photo** (definition of specified electromagnetic records in Article 6, Paragraph 1, Item 1, item (ru) (ル) of the Enforcement Ordinance. **Individual Number and gender are not included**) | My Number Card on iPhone (Face ID / Touch ID). Android version of My Number Card scheduled to be provided around autumn 2026 | Newly established on June 24, 2025 (Order of the Cabinet Office, etc. No. 2 of 2025). Transmission of a facial image is not required (authenticity and identity are verified via electronic signatures of J-LIS and the smartphone holder). Transmission uses a certified program under Article 18-3, Paragraph 1 of the My Number Use Act, and attribution confirmation uses a program under Article 18-4 of the same Act. In principle, for ages 15 and over. **Do not design to acquire or store the Individual Number** (requires a separate administrative basis under the My Number Act; `kenmen-jikou-kakunin-ap`). Method designation becomes **new to (新ト)** after the April 2027 amendment |
| wa (ワ) | Receive transmission of an electronic certificate issued by an **accredited certification business operator** under Article 4, Paragraph 1 of the Act on Electronic Signatures and Certification Business + electronic signature information | Name, residence, and date of birth stated in the electronic certificate | Electronic certificate of an accredited certification business operator | An independent method currently in force and separate from JPKI. Not a "former name of ka (カ)" |
| ka (カ) | **JPKI (Public Personal Authentication Service)** = Receive transmission of a **signing certificate** issued by the Japan Agency for Local Authority Information Systems (J-LIS) + information regarding specified transactions, etc. on which an electronic signature has been performed | Four basic attributes (name, residence, date of birth, gender) | Signing certificate of My Number Card (6–16 alphanumeric character password, locks after 5 attempts; `jpki-ap-shomei`) | **Subject to a proviso (below)**. Inquire to J-LIS for certificate validity verification (via a platform operator) and verify the electronic signature (`signature-verification` / `jlis-yukousei-kakunin`). Method designation becomes **new nu (新ヌ)** after the April 2027 amendment (proviso is also identical) |
| yo (ヨ) | Receive transmission of an electronic certificate issued by a person certified under Article 17, Paragraph 1, Item 5 of the Public Personal Authentication Act (**specified certification business**) + electronic signature information | Name, residence, and date of birth stated in the electronic certificate | Electronic certificate of a specified certification business | A method separate from JPKI |

### Proviso to the Ka-method (カ方式) (JPKI) — The Specified Business Operator Must Be a "Signature Verifier"

At the end of the text of Article 6, Paragraph 1, Item 1, item (ka) (カ) (verbatim in `references/hourei-eKYC.md` §1):

> …limited to cases where the specified business operator is a signature verifier prescribed in Article 17, Paragraph 4 of the Public Personal Authentication Act.

- "Signature verifier" = A person who has **submitted a notification** under Article 17, Paragraph 1 of the Public Personal Authentication Act (for private business operators, a person who has received **competent minister certification under Item 6** of the same paragraph and then submitted a notification) + the Agency (J-LIS) (Article 17, Paragraph 4 of the same Act).
- In other words, to perform **verification at the time of transaction** using the JPKI method, **the specified business operator itself must be a signature verifier**.
  The general statement that "since the platform operator holds certification, the SP business operator does not need certification" means that validity check facilities and
  inquiries can be entrusted to the platform operator; **a specified business operator using the Ka-method (カ方式) for verification at the time of transaction must be a
  signature verifier**. A platform operator can carry out certification, notification to the Agency, and preparation of signature verification facilities on behalf of the
  specified business operator (`platform-jigyousha`), but the title/registration belongs to the specified business operator.
- Before signing a contract, confirm with your legal department and the platform operator the scope that the platform operator can handle as proxy and whether your company needs to become a signature verifier
  (onboarding checklist in `platform-jigyousha`).

### Attaching Electromagnetic Records to Verification Records (Article 19, Paragraph 1, Item 2, item (ri) (リ))

When verification of identity-specifying matters is performed using **wa (ワ) to yo (ヨ)** (wa (ワ), ka (カ), yo (ヨ); including ka (カ) = JPKI) of Article 6, Paragraph 1, Item 1,
"an electromagnetic record sufficient to prove that the identity-specifying matters were verified by that method" (in practice, the
electronic signature and signing certificate) must be attached to the verification record and retained for **7 years** from the contract termination date, etc. pursuant to Article 6, Paragraph 2 of the Act on Prevention of Transfer of Criminal Proceeds.
In the He-method (ヘ方式) (IC reading + facial image), "identity verification image information + information on name, residence,
date of birth, and photo recorded on the IC chip" is attached to the verification record (Article 19, Paragraph 1, Item 2).
→ The principle of "not retaining the signing certificate when obtaining consent for the latest four attributes provision service" is a **separate system from this
evidence attachment obligation under the Act on Prevention of Transfer of Criminal Proceeds**. Design the two in separate stores (`signature-verification` / `doui-jouhou-kanri`).

## Enforced on April 1, 2027 (Version Not Yet in Force)

Primary source: `references/hourei-eKYC.md` §2 (revision
`420M60000F5A001_20270401_508M60000F5A005`. Amending order: Order of the Cabinet Office, etc. **No. 5** of 2026 (Reiwa 8), promulgated on
June 26, 2026, enforced on April 1, 2027, e-Gov status = not yet in force).

> **Provisions prior to enforcement may be further amended before the enforcement date.** The NPA JAFIC Q&A (`260306qa.pdf`) provides explanations based on
> "Order No. 1" of the 2026 (Reiwa 8) amendment, and its relationship with Order No. 5 shown by e-Gov as the amending order for the 2027-04-01 revision
> (whether a series of amendments or overlapping amendments) needs verification against the old-and-new comparison text. Re-fetch the
> `?asof=2027-04-01` revision during `sources-refresh`.

### Article 6, Paragraph 1, Item 1 (From April 1, 2027 Onward)

The method designations are **14 items from i (イ) to ka (カ)** (final designation = ka (カ)). Summary (e-Gov API excerpt; article-by-article matching not yet completed):

| New Designation | Summary | Current Equivalent |
|---|---|---|
| i (イ) | Presentation of an identity verification document with a specified semiconductor integrated circuit + IC reading and display on a screen (face-to-face) / presentation of a valid passport, etc. + IC reading | Newly established |
| ro (ロ) | Certain acts + sending transaction-related documents as non-forwardable mail, etc. / IC reading + display of chip information, etc. | Equivalent to current ro (ロ) |
| **ha (ハ)** | **Using software provided by the specified business operator, receive transmission of a facial image + IC chip recorded information of a photo identity verification document (non-face-to-face IC reading + facial image)** | **Current he (ヘ)** |
| ni (ニ) | Using software provided by the specified business operator, have IC chip recorded information read + verification with another specified business operator / small-amount bank transfer, etc. (image transmission type is eliminated) | Current to (ト) (IC type only) |
| ho (ホ) | Sending a copy of an identity verification document / transmission of IC chip recorded information + sending non-forwardable mail, etc. (image transmission type is eliminated) | Equivalent to current chi (チ) |
| he (ヘ) | For specified transactions, sending a copy + sending non-forwardable mail, etc. | Equivalent to current nu (ヌ) |
| **to (ト)** | **Receive transmission of specified electromagnetic records recorded in an alternative electromagnetic record for a card + attribution confirmation (certified program under the My Number Use Act)** (smartphone-mounted My Number Card) | **Current ru (ル)** |
| chi (チ) | Restricted delivery mail, etc. communicating specified matters (postal operator performs IC reading as proxy) + receipt of transaction-related documents | Equivalent to current wo (ヲ) + IC reading |
| ri (リ) | Electronic certificate issued by an accredited certification business operator under Article 4, Paragraph 1 of the Act on Electronic Signatures and Certification Business + transmission of electronic signature information | Current wa (ワ) |
| **nu (ヌ)** | **JPKI (Public Personal Authentication Service) = Receive transmission of a signing certificate issued by the Agency (J-LIS) + information regarding specified transactions, etc. on which an electronic signature has been performed** (**same proviso as current ka (カ) = limited to signature verifiers**) | **Current ka (カ)** |
| ru (ル) | Specified certification business certificate of a person certified under Article 17, Paragraph 1, Item 5 of the Public Personal Authentication Act + transmission of electronic signature information | Current yo (ヨ) |
| wo (ヲ) | Face-to-face presentation for persons not subject to the Basic Resident Register Act, etc. | Newly established |
| wa (ワ) | Sending a copy / image transmission + non-forwardable mail for persons not subject to the Basic Resident Register Act or who have moved overseas | Newly established |
| ka (カ) | Sending two copies of documents stating the current address, or a copy + supplementary document + sending non-forwardable mail, etc. (new wa (ワ) and new ka (カ) are limited to persons not subject to the Basic Resident Register Act or who have moved overseas; 2027 version Article 6, Paragraph 1, Item 1, item (wa) (ワ) opening clause "the same applies in wa (ワ) and ka (カ) below", revision `420M60000F5A001_20270401_508M60000F5A005`, retrieved 2026-10-05) | Equivalent to current ri (リ) (limited target persons) |

### Direction of the Amendment (Confirmed — NPA JAFIC / FSA)

- Enforcement date = **April 1, 2027 (Reiwa 9)** (JAFIC `260306qa.pdf` Q2; Financial Services Agency announcement on June 26, 2026 (Reiwa 8)).
- Methods with a high risk of spoofing are **abolished by specifying their item designations**: (a) the method of receiving transmission of an **image** taken of a photo identity verification document from a customer, etc. (the so-called "Ho-method (ホ方式)"), and (b) among methods of receiving the **sending of a copy** of an identity verification document, the image transmission type and the non-photo document type. **The category of sending a copy + non-forwardable mail is retained under separate item designations** (it is not a "total abolition of sending copies"). However, new he (ヘ) is limited in target transactions (certain transactions with employees of a corporation, etc.), and new wa (ワ) and new ka (カ) are limited to persons not subject to the Basic Resident Register Act or who have moved overseas (2027 version Article 6, Paragraph 1, Item 1, item (wa) (ワ) opening clause "the same applies in wa (ワ) and ka (カ) below", revision `420M60000F5A001_20270401_508M60000F5A005`, retrieved 2026-10-05).
- Non-face-to-face verification shifts to IC chip reading + card-face matching. Reading apps are not limited to those provided by government ministries; private-sector apps are also permitted.
- As a supplementary measure for persons who do not hold IC chip-equipped documents, sending the original of an identity verification document with anti-counterfeiting measures (such as a copy of the residence certificate) + non-forwardable mail is retained.
- Verification at the time of transaction lawfully completed before enforcement remains valid ("already-verified status (済み確認)"; no need to redo).

## Mobile Phone Fraud Prevention Act (Amendment Already in Force — April 1, 2026)

Official name: Ordinance for Enforcement of the Act on Identification, etc. by Mobile Voice Communications Carriers of Their Subscribers, etc. and for Prevention of Improper Use of Mobile Voice Communications Services.
Primary source: `references/hourei-eKYC.md` §3 (revision
`417M60000008167_20260806_508M60000008099`).

**The amendment entered into force on April 1, 2026** (**transitional measures** for certain methods under the former ordinance lasted **until September 30, 2026**). Previously,
this file stated "scheduled for amendment in April 2026 / unverified", which was an error; these provisions are already in force.

Target provision: Article 3, Paragraph 1, Item 1 (at contract conclusion / natural persons). The method designations are **10 items from i (イ) to nu (ヌ)**.
**No method of transmitting an image of a document remains** (ha (ハ) and ni (ニ) are transmission of IC chip recorded information).

| Designation | Summary | Relationship to eKYC Implementation |
|---|---|---|
| i (イ) | Presentation of certain documents (face-to-face) | ― |
| ro (ロ) | Presentation of certain documents + sending terminal equipment, etc. as registered mail, etc. / non-forwardable mail, etc. | ― |
| **ha (ハ)** | **Receive transmission of a facial image + IC chip recorded information of a photo identity verification document (IC reading + facial image)** | My Number Card: four basic attributes = card-face input-assist application, facial photo in IC = card-face verification application |
| ni (ニ) | Transmission of IC chip recorded information (documents without an affixed photo) + sending terminal equipment, etc. as registered mail, etc. / non-forwardable mail, etc. | ― |
| ho (ホ) | Sending of certain documents + sending terminal equipment, etc. as registered mail, etc. / non-forwardable mail, etc. | ― |
| he (ヘ) | Sending terminal equipment, etc. via restricted delivery mail, etc. communicating specified matters | ― |
| to (ト) | Transmission of information with an electronic signature + receiving an electronic certificate pertaining to the electronic signature | Electronic signature type (can include JPKI signing certificate; `jpki-ap-shomei`) |
| **chi (チ)** | **Transmission of specified electromagnetic records (certified program under Article 18-3, Paragraph 1 of the My Number Use Act) + attribution confirmation** (smartphone-mounted My Number Card) | Transmission of smartphone-mounted My Number Card. One of the routes closest to the main subject of iOS implementation |
| ri (リ) | For persons not subject to the Basic Resident Register Act or who have moved overseas. Sending of documents, etc. + sending terminal equipment, etc. as registered mail, etc. / non-forwardable mail, etc. | ― |
| nu (ヌ) | Sending of a **copy** of a document + sending terminal equipment, etc. as registered mail, etc. / non-forwardable mail, etc. | ― |

> The article-by-article text of the supplementary provisions regarding the enforcement date and transitional measures deadline (2026-09-30) was not fully captured in this retrieval,
> though it was confirmed on e-Gov during the review on September 10, 2026 (verbatim excerpts of the supplementary provisions text are not included).
> Confirm and finalize the supplementary provisions during `sources-refresh`.

## Secondhand Articles Dealer Act

Primary source: `references/hourei-eKYC.md` §5 (Ordinance for Enforcement of the Secondhand Articles Dealer Act, LawId `407M50400000010`, revision
`407M50400000010_20260812_508M60400000017`, retrieved 2026-10-05; Main Act `324AC0000000108_20250601_504AC0000000068`).

- The core verification obligation is **Article 15, Paragraph 1 of the Secondhand Articles Dealer Act (Main Act)**: when purchasing secondhand articles, etc., take **any** of the measures in
  Items 1 to 4 to verify the identity of the counterparty. Item 1 = verification of address, name, occupation, and age (Article 15, Paragraph 1 of the Enforcement Ordinance:
  presentation of an identification card, etc. or inquiry to a person sufficient to corroborate identity), Item 2 = delivery of a signed document,
  Item 3 = provision of an electromagnetic record with an electronic signature certified by a person accredited under Article 4, Paragraph 1 or Article 15, Paragraph 1 of the Act on Electronic Signatures,
  Item 4 = measures prescribed by the Enforcement Ordinance (= **Article 15, Paragraph 3, Items 1 (一) to 13 (十三) of the Enforcement Ordinance**).
- Item numbers use kanji numerals (一 to 十三), a separate system from the i (イ), ro (ロ)... designations of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds. Paragraph 3 is not a provision limited to "non-face-to-face" transactions
  (Item 10 (十) is electronic handwriting **in the presence** of the secondhand articles dealer, etc.).
- The matters to be verified are not "name, residence, and date of birth" as under the Act on Prevention of Transfer of Criminal Proceeds, but **address, name, occupation, and age** (Article 15, Paragraph 1 of the Main Act).
  Many items include "receiving a declaration of address, name, occupation, and age" as a requirement.
- Exemptions: transactions where the total consideration is **less than 10,000 yen** (Article 15, Paragraph 2, Item 1 of the Main Act; Article 16, Paragraph 1 of the Enforcement Ordinance), etc. However,
  secondhand articles under Article 16, Paragraph 2 of the Enforcement Ordinance (motorcycles and motorized bicycles [including parts], outdoor units of air conditioners and heat pumps of electric water heaters,
  home video game software, optical discs, etc. [sound and video], electric wires, metal gratings, and books) require
  verification regardless of the amount (verbatim in §5).
- The signature on a signed document delivered under Article 15, Paragraph 1, Item 2 of the Main Act must be clearly written with a fountain pen, ballpoint pen, etc. **in the presence** of the secondhand articles dealer or their agent, etc.
  (Article 15, Paragraph 2 of the Enforcement Ordinance). It is not a non-face-to-face method.

### Correspondence Between Article 15, Paragraph 3 Items of the Enforcement Ordinance and Article 6, Paragraph 1, Item 1 of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds

"≈" = similar in structure, but with differences in requirements (differences noted in Notes). "－" = no directly corresponding item. Current designations of the Act on Prevention of Transfer of Criminal Proceeds are from
§1 (`420M60000F5A001_20260806_508M60000F5A006`), and 2027 new designations are from §2
(`420M60000F5A001_20270401_508M60000F5A005`, not yet in force). Both revisions' texts were
re-fetched via e-Gov API v2 and cross-checked on 2026-10-05.

| Secondhand Item | Summary (One-Line Summary of Provision) | Act on Prevention of Transfer of Criminal Proceeds (Current) | Act on Prevention of Transfer of Criminal Proceeds (2027 New Designation) | Notes (Differences) |
|---|---|---|---|---|
| 1 (一) | Declaration + receive sending of a seal registration certificate and a document stamped with that seal | － | － | No category of seal registration certificate + stamped document exists under the Act on Prevention of Transfer of Criminal Proceeds |
| 2 (二) | Declaration + send restricted delivery mail, etc. and confirm delivery | － | － | Reference: Shares only the use of restricted delivery mail with wo (ヲ) / new chi (新チ). In wo (ヲ) / new chi (新チ), a measure whereby the postal operator receives presentation of a photo identity verification document (IC reading in new chi (新チ), or verification of specified electromagnetic records) is required, whereas Item 2 (二) has no document verification |
| 3 (三) | Declaration + promise to pay the purchase price by sending restricted delivery mail, etc. containing money or articles | － | － | Category unique to secondhand articles combined with the payment method for the purchase price |
| 4 (四) | Declaration + sending of a copy of the residence certificate, etc., or transmission of **IC chip recorded information** or an **image** (taken with software provided by the secondhand articles dealer) of an identification card, etc. + send non-forwardable recorded delivery mail, etc. addressed to the address and confirm delivery | ≈ chi (チ) | ≈ ho (ホ) (IC type and sending of copy of residence certificate, etc. type only) | Under the Act on Prevention of Transfer of Criminal Proceeds, chi (チ) also covers sending of identity verification documents (originals), whereas sending under Secondhand Item 4 (四) is limited to a copy of the residence certificate, etc. (almost overlaps with documents sent under new ho (新ホ) = Article 7, Item 1, item (ni) (ニ) of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds [seal registration certificate, copy of family register attachment, copy of residence certificate, certificate of items stated in residence certificate, etc.]). **In the 2027 version, the image transmission type remains only in new wa (新ワ) (limited to persons not subject to the Basic Resident Register Act or who have moved overseas)** (new ho (新ホ) = sending of Article 7, Item 1, item (ni) (ニ) documents or IC transmission). The image transmission type of Secondhand Item 4 (四) is limited to cases where the image is retained together with the books, etc. |
| 5 (五) | Declaration + sending of **copies** of any two of identification cards, etc. / copy of residence certificate, etc., or a copy + supplementary document (within 6 months) + sending and delivery confirmation of non-forwardable recorded delivery mail, etc. | ≈ ri (リ) | ≈ ka (カ) (limited target persons) | Similar in structure. Scope and wording of supplementary documents differ. Limited to cases where copies, etc. are retained together with the books, etc. Since 2027 new ka (新カ) is limited to persons not subject to the Basic Resident Register Act or who have moved overseas (new wa (新ワ) opening clause "the same applies in wa (ワ) and ka (カ) below"), there is no corresponding item for general customers in the 2027 version |
| 6 (六) | Declaration + sending of a copy of the residence certificate, etc. + promise to pay the purchase price by bank transfer / remittance to a deposit or savings account in that person's name | － | － | To (ト)(2) / new ni (新ニ)(2) under the Act on Prevention of Transfer of Criminal Proceeds also uses bank account transfer, but has a different structure requiring IC (and image in current to (ト)) transmission, an account with completed verification at the time of transaction, and sending of a copy of a passbook, etc. |
| 7 (七) | Declaration + sending of a **copy** of an identification card, etc. + sending and delivery confirmation of non-forwardable recorded delivery mail, etc. + promise to pay the purchase price by bank transfer, etc. to an account in that person's name | － | － | The part involving 1 copy + non-forwardable mail is close to nu (ヌ) / new he (新ヘ) (limited target transactions) under the Act on Prevention of Transfer of Criminal Proceeds, but this is a category unique to secondhand articles that additionally requires bank account transfer. Retention of the copy is a condition |
| 8 (八) | Declaration + receive transmission of an **image of a photo identification card, etc.** and **facial appearance** taken with software provided by the secondhand articles dealer (document image + selfie) | ≈ ho (ホ) | None (no equivalent designation in the 2027 version) | Structure is almost identical. Limited to cases where identity verification image information (excluding facial appearance) is retained together with the books, etc. **Remains in force on the Ordinance for Enforcement of the Secondhand Articles Dealer Act side as of 2026-10-05** (see "Status in 2027" below) |
| 9 (九) | Declaration + receive transmission of a **facial image** taken with software provided by the secondhand articles dealer + **IC chip recorded information** (address, name, age or date of birth, and photo) of a photo identification card, etc. (IC reading + facial image) | ≈ he (ヘ) | ≈ ha (ハ) | Structure is almost identical. Wording of matters recorded on the IC is "address, name, age or date of birth, and photo" (under the Act on Prevention of Transfer of Criminal Proceeds: "name, residence, date of birth, and photo") |
| 10 (十) | Declaration + have the person write their name using an instrument **in the presence** of the secondhand articles dealer, etc. and display it on a computer screen (face-to-face electronic handwriting) | － | － | Face-to-face category unique to secondhand articles. If there is doubt as to authenticity, verify using a method under Paragraph 1 |
| 11 (十一) | **JPKI (Public Personal Authentication Service)**: Signing certificate issued by the Agency (J-LIS) + receive provision of an electromagnetic record of the counterparty's **address, name, occupation, and age** with an electronic signature. **Limited to cases where the secondhand articles dealer is a signature verifier** | ≈ ka (カ) | ≈ nu (ヌ) | Scope of certificates (Article 3, Paragraph 6 of the Public Personal Authentication Act = for Individual Number Card; Article 16-2, Paragraph 6 = for mobile terminal equipment) and the signature verifier proviso have the same purport as ka (カ) / new nu (新ヌ) under the Act on Prevention of Transfer of Criminal Proceeds (the subject is "the secondhand articles dealer" [vs. "the specified business operator" under the Act on Prevention of Transfer of Criminal Proceeds]; Item 11 (十一) lacks the phrase "confirmed by the signing certificate"). The difference is the target of the signature (Act on Prevention of Transfer of Criminal Proceeds = "information regarding specified transactions, etc.") |
| 12 (十二) | Electronic certificate of a **specified certification business** issued by a person who has received certification under Article 17, Paragraph 1, Item 5 of the Public Personal Authentication Act and is a signature verifier + receive provision of an electronically signed record of address, name, occupation, and age | ≈ yo (ヨ) | ≈ ru (ル) | Difference in the target of the signature is the same as Item 11 (十一). The limitation to authenticity verification by the methods in each item of Article 5, Paragraph 1 of the Ordinance for Enforcement of the Act on Electronic Signatures is the same as current yo (ヨ) under the Act on Prevention of Transfer of Criminal Proceeds (this limiting phrase is not found in the text of 2027 new ru (新ル) retrieved on 2026-10-05) |
| 13 (十三) | Identify a person for whom measures under Article 15, Paragraph 1, Items 1 to 3 of the Act or Items 1 (一) to 12 (十二) of this paragraph have already been taken using an **identification code** (ID, password, etc.), etc., and confirm by a method resistant to spoofing that the measures have already been taken | － | － | For second and subsequent transactions. There is no corresponding item in Article 6, Paragraph 1, Item 1 of the Act on Prevention of Transfer of Criminal Proceeds. A similar provision outside the item designations is Article 16 of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds ("method of confirming that verification at the time of transaction has already been performed" under Article 13, Paragraph 2 of the Cabinet Order = confirming identity with the customer, etc. in the verification record via presentation/sending of a deposit/savings passbook, etc. or declaration of matters known only to the customer, etc., recording matters pertaining to the transaction, and retaining for 7 years; confirmed on 2026-10-05 in §1 revision) |

Supplementary notes:

- A method close to **wa (ワ) (current) / new ri (新リ) under the Act on Prevention of Transfer of Criminal Proceeds** (electronic certificate of an accredited certification business operator under Article 4, Paragraph 1 of the Act on Electronic Signatures) is located not in
  Article 15, Paragraph 3 of the Enforcement Ordinance, but in **Article 15, Paragraph 1, Item 3 of the Main Act** (electromagnetic record of address, name, occupation, and age with an electronic signature certified by
  a person accredited under Article 4, Paragraph 1 or Article 15, Paragraph 1 of the Act on Electronic Signatures).
- There is no item equivalent to **to (ト)(1) (verification with another specified business operator) / new ni (新ニ)(1) under the Act on Prevention of Transfer of Criminal Proceeds**.

### Key Points of JPKI (Item 11 (第十一号))

- **The signature verifier proviso applies.** At the end of the provision: "(limited to cases where the secondhand articles dealer is a signature verifier prescribed in Article 17, Paragraph 4 of the Public Personal Authentication Act.)"
  (verbatim in §5). Just as with ka (カ) / new nu (新ヌ) under the Act on Prevention of Transfer of Criminal Proceeds, **the secondhand articles dealer itself must be a signature verifier**
  to use Item 11 (第十一号) (definition of signature verifier is in §4).
- **The electronically signed record must include "address, name, occupation, and age"** (wording of the provision).
  Because what is recorded in the signing certificate is the four basic attributes (address, name, date of birth, and gender; `references/jpki-introduction.ja.md`)
  and occupation is not included, the design must obtain the counterparty's electronic signature on the record itself that includes occupation (inference from the provision text;
  confirm specific implementation with legal counsel and the jurisdictional police). Another difference from the Act on Prevention of Transfer of Criminal Proceeds is that the provision specifies "age" rather than date of birth.
- Target certificates also include a **signing certificate for mobile terminal equipment** (Article 16-2, Paragraph 6 of the Public Personal Authentication Act; the so-called smartphone
  electronic certificate).

### Smartphone-Mounted My Number Card (Ru (ル) Type under the Act on Prevention of Transfer of Criminal Proceeds)

- In Article 15, Paragraph 3 of the Enforcement Ordinance, **a method of receiving transmission of specified electromagnetic records of an alternative electromagnetic record for a card (current ru (ル) / new to (新ト) type under the Act on Prevention of Transfer of Criminal Proceeds)
  does not exist**. In the full text of the Enforcement Ordinance (revision `407M50400000010_20260812_508M60400000017`),
  the terms "alternative electromagnetic record for a card (カード代替電磁的記録)" and "specified electromagnetic records (特定電磁的記録)" do not appear (confirmed 2026-10-05).
- On the other hand, **JPKI signing using a smartphone's signing certificate for mobile terminal equipment** is covered by Item 11 (第十一号) (above).
  Even when using a "My Number Card on a smartphone", under the Secondhand Articles Dealer Act it must be designed as a JPKI signature (Item 11 (第十一号)).

### Status in 2027 (As Displayed on e-Gov; No Predictions Made)

- Confirmed via e-Gov API v2 on 2026-10-05: all 39 revisions of `law_revisions/407M50400000010` are already in force, and
  **there is no revision not yet in force**. `?asof=2027-04-01` also returns the current revision `…_20260812_508M60400000017`.
- In other words, on e-Gov as of 2026-10-05, no amendment to the Ordinance for Enforcement of the Secondhand Articles Dealer Act corresponding to the April 1, 2027 amendment of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds
  (abolition of image transmission types, etc.) **is registered**. Item 8 (第八号) (document image + facial appearance) and the image
  transmission type of Item 4 (第四号) are displayed on e-Gov as remaining in force even as of 2027-04-01. Whether they will be amended in the future is **unverified**
  (continue checking with `refresh.sh` in `sources-refresh`).

Reference (secondary material): `references/pdfs/33_guide-liquid-ekyc.pdf` p7 describes the correspondence with the Secondhand Articles Dealer Act as "Item 8 ≒ ho (ホ), Item 9 ≒ he (ヘ),
Item 4 ≒ to (ト) / chi (チ), Item 11 ≒ ka (カ), Ru-method (ル方式) not yet established". Difference from primary materials: Item 4 (第四号) is the **chi (チ) type (non-forwardable mail) and
not the to (ト) type (bank inquiry / small-amount transfer)**. Other than that, Items 8 (八), 9 (九), and 11 (十一) and the absence of the ru (ル) type match the primary materials.

## Purpose-Specific Quick Reference

| Applicable Law / Scenario | Main Available Methods | Methods to Implement in the App |
|---|---|---|
| Act on Prevention of Transfer of Criminal Proceeds / identity verification for account opening, etc. (Current) | JPKI (Public Personal Authentication Service) (ka (カ), **limited to signature verifiers**), IC reading + facial image (he (ヘ)), transmission of smartphone-mounted My Number Card (ru (ル)), IC reading + bank inquiry (IC type of to (ト)), image of photo document + facial image (ho (ホ) — abolished in April 2027) | Center on JPKI (Public Personal Authentication Service), combined with IC chip reading + facial photographing (he (ヘ)) as a drop-off rate countermeasure. In the He-method (ヘ方式), facial photo in IC = card-face verification application, four basic attributes = card-face input-assist application |
| Act on Prevention of Transfer of Criminal Proceeds / identity verification for account opening, etc. (From April 2027~) | Face-to-face IC reading (new i (新イ)), non-face-to-face IC reading + facial image (**new ha (新ハ)**), JPKI (Public Personal Authentication Service) (**new nu (新ヌ)**, limited to signature verifiers), transmission of smartphone-mounted My Number Card (**new to (新ト)**), sending a copy + non-forwardable mail (new he (新ヘ) = limited target transactions; new wa (新ワ) and new ka (新カ) = limited to persons not subject to the Basic Resident Register Act or who have moved overseas) | Center on JPKI (Public Personal Authentication Service) (new nu (新ヌ)), combined with new ha (新ハ) (IC reading + facial image) |
| Mobile Phone Fraud Prevention Act (In force 2026-04-01) | IC reading + facial image (**current ha (現ハ)**), IC chip record + non-forwardable mail (current ni (現ニ)), restricted delivery mail (current he (現ヘ)), electronic signature (current to (現ト)), transmission of smartphone-mounted My Number Card (**current chi (現チ)**) | IC chip reading + facial photographing (ha (ハ)), JPKI (Public Personal Authentication Service) (to (ト)), or transmission of smartphone-mounted My Number Card (chi (チ)) |
| My Number Act / identity verification when collecting Individual Numbers | Presentation / IC reading of Individual Number Card, or JPKI (Public Personal Authentication Service), etc. (based on the Ordinance for Enforcement of the My Number Use Act; details unverified) | IC chip reading of Individual Number Card (card-face verification application + card-face input-assist application) or JPKI (Public Personal Authentication Service). **Identity verification in eKYC itself does not constitute a legal basis for collecting the Individual Number** (`kenmen-jikou-kakunin-ap`) |
| Secondhand Articles Dealer Act (Article 15, Paragraph 3 of the Enforcement Ordinance; no 2027 amendment registered as of 2026-10-05) | JPKI (Public Personal Authentication Service) (**Item 11 (第十一号)**, limited to signature verifiers, signature target includes address, name, occupation, and age), IC reading + facial image (**Item 9 (第九号)**), document image + facial image (Item 8 (第八号); in force as of 2026-10-05), IC / image transmission or sending of copy of residence certificate, etc. + non-forwardable mail (Item 4 (第四号)), etc. Specified electromagnetic record transmission type for smartphone-mounted My Number Card: **none** | To standardize with the Act on Prevention of Transfer of Criminal Proceeds: JPKI (Item 11 (第十一号)) + IC reading + facial image (Item 9 (第九号)). In JPKI, a signature on a record that includes occupation is required |

## Sources

- **`references/hourei-eKYC.md`** — Primary provision excerpts retrieved from the e-Gov e-Laws API. Article 6, Paragraph 1, Item 1 of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds
  (current `420M60000F5A001_20260806_508M60000F5A006` / April 2027 version
  `420M60000F5A001_20270401_508M60000F5A005`), Article 19 of the same, Article 3 of the Ordinance for Enforcement of the Mobile Phone Fraud Prevention Act
  (`417M60000008167_20260806_508M60000008099`), and Article 17 of the Public Personal Authentication Act
  (`414AC0000000153_20260614_506AC0000000059`). Primary source for method designations and provisos. Retrieved 2026-09-10.
  Article 15 of the Ordinance for Enforcement of the Secondhand Articles Dealer Act (`407M50400000010_20260812_508M60400000017`) and Articles 15, 16, and
  18 of the Secondhand Articles Dealer Act (`324AC0000000108_20250601_504AC0000000068`) are in §5, retrieved 2026-10-05.
- e-Gov e-Laws: <https://laws.e-gov.go.jp/law/420M60000F5A001> (Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds; version not yet in force is
  `?asof=2027-04-01`), <https://laws.e-gov.go.jp/law/417M60000008167> (Ordinance for Enforcement of the Mobile Phone Fraud Prevention Act),
  <https://laws.e-gov.go.jp/law/414AC0000000153> (Public Personal Authentication Act),
  <https://laws.e-gov.go.jp/law/407M50400000010> (Ordinance for Enforcement of the Secondhand Articles Dealer Act),
  <https://laws.e-gov.go.jp/law/324AC0000000108> (Secondhand Articles Dealer Act).
- National Police Agency (NPA) JAFIC "Q&A on the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds Amended in 2026 (Reiwa 8) (Promulgated March 6, 2026)"
  (`260306qa.pdf`) <https://www.npa.go.jp/sosikihanzai/jafic/hourei/data/260306qa.pdf> —
  Enforcement date "April 1, 2027 (Reiwa 9)" (Q2), IC chip reading / card-face matching, JPKI (Public Personal Authentication Service), non-resident foreign nationals, etc.,
  already-verified status (済み確認). *Explanation based on Order No. 1.
- National Police Agency (NPA) JAFIC "Q&A on the 2025 (Reiwa 7) Amendment... (Abolition, etc. of Verification Methods for Identity-Specifying Matters with High Risk of Spoofing, etc.)
  (Promulgated June 24, 2025)" <https://www.npa.go.jp/sosikihanzai/jafic/hourei/data/25062402qa.pdf>
  — Abolition of the image transmission method for photo identity verification documents (ho (ホ)) and the copy sending method, retention of sending originals such as a copy of the residence certificate.
- National Police Agency (NPA) JAFIC "Q&A on the 2025 (Reiwa 7) Amendment... (Establishment, etc. of Verification Methods for Identity-Specifying Matters Using New Technologies) (Promulgated
  June 24, 2025)" <https://www.npa.go.jp/sosikihanzai/jafic/hourei/data/25062401qa.pdf>
  — Establishment of the method using an alternative electromagnetic record for a card (smartphone-mounted My Number Card) (current ru (ル)), Order of the Cabinet Office, etc. No. 2 of 2025 (Reiwa 7),
  transmission of facial image not required, in principle for ages 15 and over.
- National Police Agency (NPA) JAFIC "Explanation of the Act on Prevention of Transfer of Criminal Proceeds and Public Comments" (list of amending orders)
  <https://www.npa.go.jp/sosikihanzai/jafic/hourei/law_com_24.htm>
- Financial Services Agency "Promulgation, etc. of the 'Order Partially Amending the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds' and
  Results, etc. of Public Comments" (June 26, 2026 (Reiwa 8))
  <https://www.fsa.go.jp/news/r7/sonota/20260626/20260626.html> — Enforcement date "April 1, 2027 (Reiwa 9)".
- Ministry of Internal Affairs and Communications, Telecommunications Bureau, Telecommunications Consumer Policy Division "Direction of Review of Identity Verification Methods Under the Mobile Phone Fraud Prevention Act"
  (Document 3-2, April 2024 (Reiwa 6)) <https://www.soumu.go.jp/main_content/000942596.pdf>
  — Direction of review (background material; provisions confirmed on e-Gov above).
- `references/pdfs/33_guide-liquid-ekyc.pdf` p7–12 (Guide to LIQUID eKYC: IC Chip Method Edition v2.11,
  2026-04-13 edition) — Acquired data and supported documents. Correspondence with the Secondhand Articles Dealer Act (p7) is referenced only as secondary material (primary material is
  `references/hourei-eKYC.md` §5; there is a discrepancy in the correspondence for Item 4 (第四号)). *Vendor material. Method designations and dates
  need verification against primary materials. The "List of Method Name Changes" on p8 of the same document is based on the method designations of the 2025 (Reiwa 7) amending order (Order No. 3)
  and does not reflect subsequent reorganizations (see "## Unverified Items" below).
- `references/pdfs/05_private-sector-guidelines-v1.8.pdf` (Guidelines for Private-Sector Business Operators, Version 1.8,
  2026-04-13) — Four basic attributes and fees for JPKI. Does not contain method designations under the Act on Prevention of Transfer of Criminal Proceeds / Mobile Phone Fraud Prevention Act.
- `references/jpki-introduction.ja.md` (Digital Agency JPKI Introduction Page, retrieved 2026-09-07) —
  Four basic attributes recorded in the signing certificate, smartphone-mounted electronic certificates.
- Digital Agency "Revamping into 'My Number Card on Android' Around Autumn 2026"
  <https://services.digital.go.jp/mynumbercard-android/news/0cfe138d7fb5927e4dc6d/>

## Unverified Items

- **Article-by-article matching of each item in the April 2027 version of Article 6, Paragraph 1, Item 1**. The new designation table in this file is a summary based on excerpts from
  e-Gov API v2, and article-by-article verification against the old-and-new comparison text (e-Gov `?asof=2027-04-01`, NPA JAFIC "Summary of Amendments")
  has not yet been completed. In particular, sub-items of i (イ), ro (ロ), ni (ニ), and ho (ホ), and requirements for he (ヘ) and wa (ワ).
- ~~Whether the 2027 new designation for JPKI is "nu (ヌ)"~~ → **Resolved (2026-10-05)**. Extracted the text of revision
  `420M60000F5A001_20270401_508M60000F5A005` directly from e-Gov API v2 and confirmed verbatim that new nu (新ヌ) = JPKI
  (with signature verifier proviso) and new ru (新ル) = specified certification business (`references/hourei-eKYC.md` §2).
  Because provisions not yet in force may be amended again before enforcement, continue checking via `sources-refresh`.
- **Relationship between "Order No. 1" and "Order No. 5" of the 2026 (Reiwa 8) amendment**. NPA JAFIC explains based on Order No. 1, whereas
  e-Gov indicates Order No. 5 (promulgated June 26, 2026) as the amending order for the 2027-04-01 revision.
  Whether this is a series of amendments or overlapping partial amendments needs verification against the old-and-new comparison text.
- **Article-by-article text of the supplementary provisions (enforcement date and transitional measures) of the Ordinance for Enforcement of the Mobile Phone Fraud Prevention Act**. Enforcement on April 1, 2026 and transitional measures until
  September 30, 2026 were confirmed on e-Gov during the review on September 10, 2026 (excerpts of the supplementary provisions text are not included).
  Finalize the article-by-article text of the supplementary provisions on e-Gov during `sources-refresh`.
- **Positioning of the method designation system in LIQUID material v2.11**. "he (ヘ) → ho (ホ) / to (ト) → he (ヘ) / wa (ワ), ka (カ) → wo (ヲ) / ru (ル) → ri (リ)" corresponds to the method designations in the 2025 (Reiwa 7)
  amending order (Order No. 3), which were subsequently reorganized in the 2026 (Reiwa 8) amendment. That document appears not to have been updated to the latest
  method designations.
- **Future amendments to the Ordinance for Enforcement of the Secondhand Articles Dealer Act**. The wording of each item of Article 15, Paragraph 3 and its correspondence with the Act on Prevention of Transfer of Criminal Proceeds were confirmed against e-Gov
  primary provisions on 2026-10-05 (`references/hourei-eKYC.md` §5; "## Secondhand Articles Dealer Act" above). An amendment to the Ordinance for Enforcement of the Secondhand Articles Dealer Act linked to the April 2027 amendment of the Act on Prevention of Transfer of Criminal Proceeds
  is not registered on e-Gov (as of 2026-10-05; no revision not yet in force), but
  whether it will be amended in the future is unverified. Continue checking via `sources-refresh`.
- **Detailed rules on records under the Secondhand Articles Dealer Act**. Matters to be stated in books, etc. (Article 16 of the Main Act) and 3-year retention (Article 18, Paragraph 1 of the Main Act) are
  confirmed. The exemption amount (10,000 yen) and target secondhand articles (Article 16 of the Enforcement Ordinance) are also confirmed (`references/hourei-eKYC.md` §5).
  Formats and entry methods for books, etc. on the Enforcement Ordinance side are unverified.
- **Method designations and provisions for identity verification methods when acquiring Individual Numbers under the Ordinance for Enforcement of the My Number Use Act**. Only an outline is provided in
  this file.
- **Detailed acquired data for the current To-method (ト方式) and Chi-method (チ方式)** (summarized in this file). Needs verification in the relevant provisions of the Enforcement Ordinance.
