# Primary Legal Text Excerpts for eKYC-Related Laws and Ordinances (e-Gov Law Search)

Last Verified: 2026-09-11 (§5 Enforcement Rules of the Secondhand Articles Dealer Act is 2026-10-05)

This file contains excerpts retrieved from the primary source (e-Gov Law Search API) used by `method-map.md` and `skills/honnin-kakunin-houhou/SKILL.md` to establish method designations and effective dates. **Method designations shift with legal amendments.**
Before implementation or legal determination, always re-verify the text of the relevant revision on e-Gov Law Search below.
The `sources-refresh` skill targets the revision IDs recorded in this file for re-retrieval.

Retrieval method: e-Gov Law Search API v2 `https://laws.e-gov.go.jp/api/2/law_data/<LawId>` (for versions not yet in force, append `?asof=YYYY-MM-DD`). Browser view is `https://laws.e-gov.go.jp/law/<LawId>`.

---

## 1. Enforcement Rules of the Act on Prevention of Transfer of Criminal Proceeds (Current / In Force)

- LawId: `420M60000F5A001`
- Retrieved Revision: `420M60000F5A001_20260806_508M60000F5A006` (reflects amendments in force up to August 6, 2026 [Reiwa 8])
- e-Gov: <https://laws.e-gov.go.jp/law/420M60000F5A001>

### Article 6, Paragraph 1, Item 1 (Methods for Verifying Identifying Matters of Individuals / Natural Persons)

The current method designations are **15 sub-items from (i) (イ) to (yo) (ヨ)** (final designation = (yo) (ヨ)). Gist of each sub-item (a single-line summary faithful to the statutory text; verify exact wording on e-Gov):

| Sub-item | Gist |
|---|---|
| (i) (イ) | Receive presentation of a photo identification document (in-person) |
| (ro) (ロ) | Presentation of an identification document + send transaction-related documents as non-forwardable mail, etc. |
| (ha) (ハ) | Receive presentation of multiple identification documents, or an identification document + supplementary document |
| (ni) (ニ) | Presentation of an identification document + receive delivery of other identification documents, supplementary documents, etc. |
| (ho) (ホ) | Receive transmission of facial image information photographed using software provided by the specified business operator + image information of a photo identification document (the so-called "(ho) (ホ) method" = image transmission + selfie) |
| (he) (ヘ) | Transmission of facial image information + receive transmission of information recorded in a semiconductor integrated circuit (IC chip) embedded in a photo identification document (IC reading + facial image) |
| (to) (ト) | Receive transmission of image information of an identification document or IC chip recorded information + verification with another specified business operator or small-amount bank transfer, etc. |
| (chi) (チ) | Receive presentation/delivery of an identification document + send transaction-related documents as non-forwardable mail, etc. (separate category from (ro) (ロ)) |
| (ri) (リ) | Receive delivery of copies of multiple identification documents / supplementary documents + send non-forwardable mail, etc. |
| (nu) (ヌ) | Receive delivery of a copy of an identification document in certain cases + send non-forwardable mail, etc. |
| (ru) (ル) | **Receive transmission of a specific electromagnetic record recorded in a card-substitute electromagnetic record + verify that said record belongs to said customer** (My Number Card installed on a smartphone; newly established on June 24, 2025) |
| (wo) (ヲ) | Send transaction-related documents through presentation and other measures by a postal/delivery service operator |
| (wa) (ワ) | Receive transmission of an electronic certificate issued by a person accredited under Article 4, Paragraph 1 of the Act on Electronic Signatures and Certification Business + information with an electronic signature affixed |
| (ka) (カ) | **JPKI (Public Personal Authentication Service) = receive transmission of a signing certificate issued by the Japan Agency for Local Authority Information Systems (J-LIS) + information regarding specific transactions, etc. with an electronic signature affixed** (subject to the proviso below) |
| (yo) (ヨ) | Receive transmission of an electronic certificate issued by a person accredited under Article 17, Paragraph 1, Item 5 of the Public Personal Authentication Act (specified certification business) + information with an electronic signature affixed |

### Proviso to Article 6, Paragraph 1, Item 1 (ka) (カ) (Conditions for Using the JPKI Method)

Quoting the proviso at the end of the provision **verbatim** (confirmed via e-Gov v2 API):

> Limited to cases where the specified business operator is a signature verifier prescribed in Article 17, Paragraph 4 of the Public Personal Authentication Act.

→ The JPKI method ((ka) (カ)) cannot be used for confirmation at the time of transaction unless **the specified business operator itself is a "signature verifier."**
See Section 4 below for the definition of "signature verifier." A platform operator may handle the setup of signature verification equipment and act as an agent for accreditation/notification, but the title of accreditation/notification belongs to the specified business operator (`platform-jigyousha`).

### Article 19, Paragraph 1, Item 2 (ri) (リ) (Attachment of Electromagnetic Records to Confirmation Records)

When verification of identifying matters is conducted by a method from **(wa) (ワ) to (yo) (ヨ)** (= (wa) (ワ), (ka) (カ), (yo) (ヨ); including (ka) (カ) = JPKI) of Article 6, Paragraph 1, Item 1, an "electromagnetic record sufficient to prove that verification of identifying matters was conducted by said method" must be attached to the confirmation record (in practice, the electronic signature and the signing certificate). The retention period for confirmation records is 7 years from the contract termination date, etc., pursuant to Article 6, Paragraph 2 of the Act on Prevention of Transfer of Criminal Proceeds.
→ The principle that "the consent service does not retain signing certificates" is **separate from this evidence attachment obligation under the Act on Prevention of Transfer of Criminal Proceeds**.
Design the two in separate stores (`signature-verification` / `doui-jouhou-kanri`).

---

## 2. Enforcement Rules of the Act on Prevention of Transfer of Criminal Proceeds (Effective April 1, 2027 / Version Not Yet in Force)

- LawId: `420M60000F5A001`
- Retrieved Revision: `420M60000F5A001_20270401_508M60000F5A005`
- Amending Order: 2026 (Reiwa 8) Ordinance of the Cabinet Office, Ministry of Internal Affairs and Communications, Ministry of Justice, Ministry of Finance, Ministry of Health, Labour and Welfare, Ministry of Agriculture, Forestry and Fisheries, Ministry of Economy, Trade and Industry, and Ministry of Land, Infrastructure, Transport and Tourism
  **No. 5** (promulgated June 26, 2026; effective April 1, 2027; status on e-Gov = not yet in force)
- e-Gov: <https://laws.e-gov.go.jp/law/420M60000F5A001?asof=2027-04-01>

> Note: Among the 2026 (Reiwa 8) amendments, there is also a separate "Ordinance No. 1," and the Q&A (`260306qa.pdf`) by the National Police Agency (JAFIC) provides explanations based on Ordinance No. 1. What e-Gov indicates as the amending order for the 2027-04-01 revision is Ordinance No. 5 (promulgated June 26, 2026). The relationship between the two (whether a series of amendments or overlapping partial amendments) needs verification in the main text of the Enforcement Rules and the side-by-side comparison of old and new provisions. **Provisions prior to enforcement may be further amended.**

### Article 6, Paragraph 1, Item 1 (From April 1, 2027 Onward)

The method designations are **14 sub-items from (i) (イ) to (ka) (カ)** (final designation = (ka) (カ)). Gist of each sub-item (to the extent confirmed via e-Gov v2 API; a single-line summary faithful to the statutory text):

| New Sub-item | Gist | Current Equivalent (Approx.) |
|---|---|---|
| (i) (イ) | Presentation of an identification document with a specified semiconductor integrated circuit + reading and screen display of IC chip information (in-person) / presentation of a valid passport, etc. + IC reading | Newly established |
| (ro) (ロ) | Certain acts + send transaction-related documents as non-forwardable mail, etc. / IC reading + chip information display, etc. | Equivalent to current (ro) (ロ) |
| (ha) (ハ) | **Using software provided by the specified business operator, receive transmission of facial image information + IC chip recorded information of a photo identification document (non-face-to-face IC reading + facial image)** | **Current (he) (ヘ)** |
| (ni) (ニ) | Have IC chip recorded information read using software provided by the specified business operator + verification with another specified business operator / small-amount bank transfer, etc. (image transmission type abolished) | Current (to) (ト) (IC type only) |
| (ho) (ホ) | Delivery of a copy of an identification document / transmission of IC chip recorded information + send non-forwardable mail, etc. | Current (chi) (チ) (image transmission type abolished) |
| (he) (ヘ) | For specific transactions, delivery of a copy + send non-forwardable mail, etc. | Equivalent to current (nu) (ヌ) |
| (to) (ト) | **Receive transmission of a specific electromagnetic record recorded in a card-substitute electromagnetic record + verify attribution of said record (program accredited under the Number Use Act)** (My Number Card installed on a smartphone) | **Current (ru) (ル)** |
| (chi) (チ) | Restricted-delivery mail with specific matter communication, etc. (postal operator acts as agent for IC reading) + receipt of transaction-related documents | Equivalent to current (wo) (ヲ) + IC reading |
| (ri) (リ) | Transmission of an electronic certificate issued by an accredited certification business operator under Article 4, Paragraph 1 of the Act on Electronic Signatures and Certification Business + electronic signature information | Current (wa) (ワ) |
| (nu) (ヌ) | **JPKI (Public Personal Authentication Service) = receive transmission of a signing certificate issued by J-LIS + information regarding specific transactions, etc. with an electronic signature affixed** (same proviso as current (ka) (カ) = limited to signature verifiers) | **Current (ka) (カ)** |
| (ru) (ル) | Transmission of a specified certification business certificate of a person accredited under Article 17, Paragraph 1, Item 5 of the Public Personal Authentication Act + electronic signature information | Current (yo) (ヨ) |
| (wo) (ヲ) | In-person presentation for persons not subject to the Residential Basic Book Act, etc. | Newly established |
| (wa) (ワ) | Delivery of a copy / image transmission + non-forwardable mail for persons not subject to the Residential Basic Book Act or persons moving abroad | Newly established |
| (ka) (カ) | Delivery of 2 copies of documents stating current address, or a copy + supplementary document + send non-forwardable mail, etc. (new (wa) (ワ) and new (ka) (カ) are limited to persons not subject to the Residential Basic Book Act or persons moving abroad; 2027 version Article 6, Paragraph 1, Item 1 (wa) (ワ) introductory clause "the same applies hereinafter in (wa) (ワ) and (ka) (カ)", revision `420M60000F5A001_20270401_508M60000F5A005`, retrieved 2026-10-05) | Equivalent to current (ri) (リ) (limited target persons) |

> Verify the details of each sub-item (especially branch numbers of (i) (イ), (ro) (ロ), (ni) (ニ), (ho) (ホ), and requirements of (he) (ヘ), (wa) (ワ)) article by article in the `?asof=2027-04-01` revision on e-Gov. The table above is a summary based on API excerpts, and **article-by-article collation against the side-by-side comparison of old and new provisions is not yet completed** (left in Unverified Items of `method-map.md`).

#### Statutory Text of 3 Important Sub-items for eKYC (Re-retrieved via e-Gov v2 on 2026-09-11; (ha) (ハ) and (to) (ト) are near-verbatim)

**New (ha) (ハ)** (non-face-to-face IC reading + facial image = equivalent to current (he) (ヘ)):

> A method of receiving transmission from said customer, etc. or their representative, etc., using software provided by the specified business operator, of identification image information (meaning image information of the facial appearance of said customer, etc. photographed by having said customer, etc. or their representative, etc. use said software), together with receiving transmission from said customer, etc. or their representative, etc. of said information recorded in a semiconductor integrated circuit embedded in a photo identification document of said customer, etc. (limited to one in which a semiconductor integrated circuit recording information on name, residence, date of birth, and photograph is embedded)

**New (to) (ト)** (My Number Card installed on a smartphone = equivalent to current (ru) (ル)):

> A method of receiving transmission (limited to that performed using a program accredited under Article 18-3, Paragraph 1 of the Number Use Act) from said customer, etc. of an electromagnetic record recording information on the name, residence, date of birth, and photograph of said customer, etc. among the electromagnetic records constituting a card-substitute electromagnetic record (hereinafter referred to as a "specific electromagnetic record"), together with performing verification (limited to that performed using a program provided pursuant to the provisions of Article 18-4, Paragraph 1 of the Number Use Act or a program accredited under Paragraph 2 of the same Article) that said specific electromagnetic record belongs to said customer, etc. who made said transmission

→ The acquired data are **name, residence, date of birth, and photograph**. **Individual Number (My Number) and gender are not included** (same as current (ru) (ル)).

**New (nu) (ヌ)** (JPKI (Public Personal Authentication Service) = equivalent to current (ka) (カ). Proviso = limited to signature verifiers. Verbatim text of Article 6, Paragraph 1, Item 1 (nu) (ヌ) of revision `420M60000F5A001_20270401_508M60000F5A005` re-retrieved via e-Gov v2 on 2026-10-05):

> A method of receiving transmission from said customer, etc. of a signing certificate issued by the Japan Agency for Local Authority Information Systems (J-LIS) pursuant to the provisions of Article 3, Paragraph 6 or Article 16-2, Paragraph 6 of the Act on Certification Business of the Japan Agency for Local Authority Information Systems Regarding Electronic Signatures, etc. (Act No. 153 of 2002; hereinafter referred to as the "Public Personal Authentication Act" in this sub-item) and information regarding specific transactions, etc. on which an electronic signature prescribed in Article 2, Paragraph 1 of the Public Personal Authentication Act verified by said signing certificate has been performed (limited to cases where the specified business operator is a signature verifier prescribed in Article 17, Paragraph 4 of the Public Personal Authentication Act).

> **Resolved (numbering of (nu) (ヌ) / (ru) (ル)).** In the re-retrieval on 2026-09-11, there was a discrepancy where the summarization model returned the provision for specified certification business as "(nu) (ヌ)", but on 2026-10-05 the main text of the same revision was extracted directly from the API, confirming that **new (nu) (ヌ) = JPKI (verbatim above), and new (ru) (ル) = specified certification business certificate of a person accredited under Article 17, Paragraph 1, Item 5 of the Public Personal Authentication Act**.

### Direction of the Amendment (Confirmed / National Police Agency JAFIC & Financial Services Agency)

- Effective date = **April 1, 2027 (Reiwa 9)** (JAFIC `260306qa.pdf` Q2; announced by the Financial Services Agency on June 26, 2026 [Reiwa 8]).
- Methods with high spoofing risk (the method of sending an image of a photo identification document = the so-called "(ho) (ホ) method", and among methods of receiving **delivery of a copy** of an identification document, the image transmission type and non-photo document type) are abolished, transitioning non-face-to-face verification to IC chip reading + card-face verification. However, categories involving delivery of a copy + non-forwardable mail are retained under separate sub-items (new (he) (ヘ) is limited in target transactions; new (wa) (ワ) and new (ka) (カ) are limited to persons not subject to the Residential Basic Book Act or persons moving abroad; confirmed in re-retrieval on 2026-10-05 via the introductory clause of Article 6, Paragraph 1, Item 1 (wa) (ワ) of the 2027 version: "the same applies hereinafter in (wa) (ワ) and (ka) (カ)").
- Confirmation at the time of transaction lawfully completed prior to enforcement remains valid ("already-verified customer"; re-verification not required).

---

## 3. Enforcement Rules of the Mobile Phone Fraud Prevention Act (Current / In Force)

Official Title: Enforcement Rules of the Act on Identification, etc. by Mobile Voice Communications Carriers of Their Subscribers, etc. and for Prevention of Improper Use of Mobile Voice Communications Services

- LawId: `417M60000008167`
- Retrieved Revision: `417M60000008167_20260806_508M60000008099`
- e-Gov: <https://laws.e-gov.go.jp/law/417M60000008167>
- **Amendment is already in force** (effective April 1, 2026 [Reiwa 8] = 2026-04-01. Amending Ministerial Ordinance = April 1, 2025 [Reiwa 7] Ministry of Internal Affairs and Communications Ordinance No. 37, etc. **Transitional measures** for former Rules Article 3, Paragraph 1, Item 2 (ha) (ハ), etc. **ran until September 30, 2026 [Reiwa 8] = 2026-09-30**.
  *Note: Article-by-article text of the Supplementary Provisions was not re-verified in this retrieval. Based on what the September 2026 review confirmed on e-Gov as of September 2026.)

### Article 3, Paragraph 1, Item 1 (Identity Verification Methods for Natural Persons at Contract Conclusion)

The current method designations are **10 sub-items from (i) (イ) to (nu) (ヌ)** (final designation = (nu) (ヌ)). **No method of transmitting an image of a document remains** ((ha) (ハ) and (ni) (ニ) involve transmission of IC chip recorded information, not transmission of a photograph of a document). Gist of each sub-item (summary faithful to the statutory text confirmed via e-Gov v2 API):

| Sub-item | Gist |
|---|---|
| (i) (イ) | Presentation of a document prescribed in Article 5, Paragraph 1, Item 1 (excluding (ni) (ニ) and (he) (ヘ)) or Item 3 |
| (ro) (ロ) | Receive presentation of a document under Article 5, Paragraph 1, Item 1 (ni) (ニ) or (he) (ヘ), or (ho) (ホ) of the same Item (excluding those issued as a single unique copy) + send terminal equipment, etc. as registered mail, etc. / non-forwardable mail, etc. addressed to the residence stated in said document |
| (ha) (ハ) | **Receive transmission of identification image information (facial appearance) + receive transmission of information recorded in a semiconductor integrated circuit embedded in a photo identification document** (IC reading + facial image) |
| (ni) (ニ) | Receive transmission of IC chip recorded information of a document under Article 5, Paragraph 1, Item 1 (ro)(2) (ロ(2)) + send terminal equipment, etc. as registered mail, etc. / non-forwardable mail, etc. addressed to the residence recorded in said chip |
| (ho) (ホ) | Receive delivery of a document under Article 5, Paragraph 1, Item 1 (ni) (ニ) (excluding those issued as a single unique copy) + send terminal equipment, etc. as registered mail, etc. / non-forwardable mail, etc. addressed to the residence stated in said document |
| (he) (ヘ) | Send terminal equipment, etc. to said natural person by restricted-delivery mail with specific matter communication, etc. |
| (to) (ト) | When concluding a contract by receiving transmission of information with an electronic signature affixed, receive the electronic certificate pertaining to said electronic signature from said natural person |
| (chi) (チ) | **Receive transmission of a specific electromagnetic record from said natural person (limited to cases using a program accredited under Article 18-3, Paragraph 1 of the Number Use Act) + verify that said record belongs to the natural person who made the transmission** (My Number Card installed on a smartphone) |
| (ri) (リ) | For persons not subject to the Residential Basic Book Act or persons moving abroad: receive delivery of a document under Article 5, Paragraph 1, Item 1 (he) (ヘ), etc. + send terminal equipment, etc. as registered mail, etc. / non-forwardable mail, etc. addressed to the residence |
| (nu) (ヌ) | Receive delivery of a **copy** of a document under Article 5, Paragraph 1, Item 1 or Item 3 + send terminal equipment, etc. as registered mail, etc. / non-forwardable mail, etc. addressed to the residence stated in said copy |

> The article-by-article text of the effective date and transitional measure deadline (2026-09-30) in the Supplementary Provisions was not fully verified in this retrieval, and relies on the e-Gov verification at the time of the September 10, 2026 review (excerpts of the main text of the Supplementary Provisions are not included). Verify the Supplementary Provisions on e-Gov during `sources-refresh` to finalize.

---

## 4. Public Personal Authentication Act (Act on Certification Business of the Japan Agency for Local Authority Information Systems Regarding Electronic Signatures, etc.)

- LawId: `414AC0000000153`
- Retrieved Revision: `414AC0000000153_20260614_506AC0000000059`
- e-Gov: <https://laws.e-gov.go.jp/law/414AC0000000153>

### Article 17, Paragraph 1, Item 6 (Competent Minister Accreditation of Private Business Operators)

> A person other than those listed in the preceding items who is accredited by the competent minister as being capable of performing verification that a signature user performed said electronic signature or that a user-authentication user performed said electronic user authentication in conformity with standards specified by Cabinet Order

(Item 5 is "a person who performs a specified certification business prescribed in Article 2, Paragraph 3 of the Act on Electronic Signatures and Certification Business and is accredited by the competent minister as conforming to standards specified by Cabinet Order.")

### Article 17, Paragraph 4 (Definition of Signature Verifier)

> J-LIS, having received the notification under Paragraph 1, and the person who made said notification (hereinafter referred to as a "signature verifier") must conclude an arrangement in advance regarding the scope of information to be provided by J-LIS pursuant to the provisions of Paragraphs 1 and 2 of the following Article and other matters specified by ordinance of the competent ministry as matters that should be agreed upon in making said provision.

→ "Signature verifier" = **a person who made a notification** under Article 17, Paragraph 1 (in the case of a private business operator, a person who made a notification after receiving accreditation from the competent minister under Item 6) + J-LIS. The proviso to the (ka) (カ) method under the Act on Prevention of Transfer of Criminal Proceeds (new (nu) (ヌ) from 2027 onward) — "limited to cases where the specified business operator is a signature verifier prescribed in Article 17, Paragraph 4 of the Public Personal Authentication Act" — refers to this.

---

## 5. Enforcement Rules of the Secondhand Articles Dealer Act (Current / In Force)

- LawId: `407M50400000010` (1995 [Heisei 7] National Public Safety Commission Rules No. 10)
- Retrieved Revision: `407M50400000010_20260812_508M60400000017` (reflects amendments in force up to August 12, 2026 [Reiwa 8] = 2026 [Reiwa 8] National Public Safety Commission Rules No. 17)
- e-Gov: <https://laws.e-gov.go.jp/law/407M50400000010>
- Retrieval Date: 2026-10-05 (e-Gov Law Search API v2 `law_data/407M50400000010`)
- **Presence of amendments not yet in force (e-Gov as of 2026-10-05)**: All 39 revisions returned by `law_revisions/407M50400000010` are already in force (1 `CurrentEnforced`, 38 `PreviousEnforced`), and there are no revisions not yet in force (`UnEnforced`). `law_data/407M50400000010?asof=2027-04-01` also returned the same current revision.
  → Any amendment to the Enforcement Rules of the Secondhand Articles Dealer Act corresponding to the amendment of the Enforcement Rules of the Act on Prevention of Transfer of Criminal Proceeds effective April 1, 2027 **is not registered on e-Gov as of 2026-10-05** (whether there will be future amendments is unverified).
- The main text of Article 15 is identical to the immediately preceding 7 revisions (`…_20260710_508M60400000014`, `…_20260601_508M60400000013`, `…_20260501_508M60400000007`, `…_20251001_507M60400000017`, `…_20251001_507M60400000014`, `…_20250628_507M60400000011`, `…_20250501_507M60400000005`) (compared via API on 2026-10-05).
- Related: Secondhand Articles Dealer Act (Principal Act) LawId `324AC0000000108`, reference revision of the Principal Act `324AC0000000108_20250601_504AC0000000068` (`CurrentEnforced` on e-Gov, no revisions not yet in force; retrieved 2026-10-05). <https://laws.e-gov.go.jp/law/324AC0000000108>

Below is a **verbatim** transcription of the main text from e-Gov API v2 (omitting only supplementary documents (i) (イ) to (ho) (ホ) of Article 15, Paragraph 3, Item 5).
Item numbers are in Kanji numerals (Paragraph 3 has **13 items from Item 1 (一) to Item 13 (十三)**). This is a separate numbering system from the "(i) (イ), (ro) (ロ)..." method designations under the Act on Prevention of Transfer of Criminal Proceeds.

### Article 15, Paragraph 1 (Definition of "Identification Documents, etc.")

> Verification pursuant to the provisions of Article 15, Paragraph 1, Item 1 of the Act shall be performed by receiving presentation of an identification card, driver's license, Individual Number Card prescribed in Article 2, Paragraph 7 of the Act on the Use of Numbers to Identify a Specific Individual in Administrative Procedures (Act No. 27 of 2013), or other materials certifying the address, name, and age or date of birth of the counterparty (limited to those issued or granted as a single unique copy; hereinafter referred to as "identification documents, etc."), or by making an inquiry to a person other than the counterparty who is sufficient to ascertain the identity of the counterparty.

### Article 15, Paragraph 2 (Signature under Article 15, Paragraph 1, Item 2 of the Act)

> 2. The signature prescribed in Article 15, Paragraph 1, Item 2 of the Act must be clearly written with a fountain pen, ballpoint pen, etc. in the presence of said secondhand articles dealer or their agent, employee, or other worker (referred to as "agent, etc." in Item 10 of the following paragraph and Paragraph 4). In this case, when the secondhand articles dealer finds reason to suspect that the address, name, occupation, or age stated in the document bearing said signature is not genuine, the dealer must endeavor to verify that address, name, occupation, or age as prescribed in the preceding paragraph.

### Article 15, Paragraph 3 ("Measures Specified by National Public Safety Commission Rules" under Article 15, Paragraph 1, Item 4 of the Act)

> 3. The measures specified by National Public Safety Commission Rules under Article 15, Paragraph 1, Item 4 of the Act shall be as follows:
>
> **Item 1 (一)** Receiving a declaration from the counterparty of their address, name, occupation, and age, together with receiving delivery of their seal registration certificate and a document bearing the impression of the seal pertaining to said seal registration certificate.
>
> **Item 2 (二)** Receiving a declaration from the counterparty of their address, name, occupation, and age, and sending to that person restricted-delivery mail, etc. (meaning postal mail handled so as to be delivered only to the addressee themselves or a person who may receive it on behalf of the addressee designated by the sender, or correspondence mail prescribed in Article 2, Paragraph 3 of the Act on Correspondence Delivery by Private Business Operators (Act No. 99 of 2002) delivered by a general correspondence delivery operator prescribed in Paragraph 6 of the same Article or a specified correspondence delivery operator prescribed in Paragraph 9 of the same Article (hereinafter referred to as "correspondence mail"); the same applies hereinafter), and ascertaining its arrival.
>
> **Item 3 (三)** Receiving a declaration from the counterparty of their address, name, occupation, and age, and promising to pay the price of said secondhand article by a method of sending restricted-delivery mail, etc. containing money or articles to that person.
>
> **Item 4 (四)** Receiving a declaration from the counterparty of their address, name, occupation, and age, together with receiving delivery of a copy of their residence record, a certificate of items stated in the residence record, a copy of the supplementary family register, or a seal registration certificate (hereinafter referred to as a "copy of the residence record, etc."), or receiving transmission of information recorded in a semiconductor integrated circuit (meaning a semiconductor integrated circuit prescribed in Article 2, Paragraph 1 of the Act on the Circuit Layout of a Semiconductor Integrated Circuit (Act No. 43 of 1985); the same applies hereinafter in this Item and Item 9) embedded in an identification document, etc. of said counterparty (limited to one in which a semiconductor integrated circuit recording information on address, name, and age or date of birth is embedded) or identification image information (meaning image information of an identification document, etc. of said counterparty photographed by having said counterparty use software provided by said secondhand articles dealer, by which the address, name, and age or date of birth stated in said identification document, etc. as well as the thickness and other features of said identification document, etc. can be verified) (in the case of said identification image information, limited to transmission using said software), and sending recorded-delivery mail, etc. (meaning postal mail or correspondence mail handled so as to record acceptance and delivery, or freight handled in a similar manner (limited to that transported by a person who has obtained permission under Article 3 of the Motor Truck Transportation Business Act (Act No. 83 of 1989) or another person who lawfully conducts a freight transportation business); the same applies hereinafter) handled so as not to be forwarded, addressed to the address of said counterparty stated in said copy of the residence record, etc. or recorded in said information, and ascertaining its arrival (in the case of receiving transmission of said identification image information, limited to cases where said identification image information is preserved together with the books, etc. under Article 16 of the Act or a record by electromagnetic means (meaning electronic means, magnetic means, or other means that cannot be recognized by human perception; the same applies hereinafter) pertaining to said secondhand article).
>
> **Item 5 (五)** Receiving a declaration from the counterparty of their address, name, occupation, and age, together with receiving delivery of copies (limited to those clearly displayed) of any two documents from among their identification documents, etc. or copy of the residence record, etc., or receiving delivery of a copy (limited to one clearly displayed) of an identification document, etc. or copy of the residence record, etc. of said counterparty and any one of the following documents stating the address of said counterparty (excluding identification documents, etc. or a copy of the residence record, etc., and limited to one bearing a receipt date stamp or stating an issue date that is within six months prior to the day on which said secondhand articles dealer receives delivery; hereinafter referred to as a "supplementary document" in this Item) or a copy thereof (limited to one clearly displayed), and sending recorded-delivery mail, etc. handled so as not to be forwarded, addressed to the address of said counterparty stated in the copy of the identification document, etc. or copy of the residence record, etc. of said counterparty or in said supplementary document or copy thereof, and ascertaining its arrival (limited to cases where the copy of said identification document, etc. or copy of the residence record, etc. or said supplementary document or copy thereof is preserved together with the books, etc. under Article 16 of the Act or a record by electromagnetic means pertaining to said secondhand article).
>
> (Supplementary documents (i) (イ) to (ho) (ホ) of Item 5 are omitted. (i) (イ) = receipt or tax payment certificate for national tax or local tax; (ro) (ロ) = receipt for social insurance premiums; (ha) (ハ) = receipt for public utility charges; (ni) (ニ) = document issued by a government or public office, etc. stating address and name; (ho) (ホ) = document issued by a foreign government, etc. equivalent to an identification document, etc. or copy of the residence record, etc. Verify exact wording on e-Gov.)
>
> **Item 6 (六)** Receiving a declaration from the counterparty of their address, name, occupation, and age, together with receiving delivery of a copy of their residence record, etc., and promising to pay the price of said secondhand article by a method of bank transfer or account transfer to a deposit or savings account whose account holder name is the name of that person stated in said copy of the residence record, etc.
>
> **Item 7 (七)** Receiving a declaration from the counterparty of their address, name, occupation, and age, together with receiving delivery of a copy (limited to one clearly displayed) of their identification document, etc., sending recorded-delivery mail, etc. handled so as not to be forwarded, addressed to the address of that person stated in the copy of said identification document, etc. and ascertaining its arrival, and promising to pay the price of said secondhand article by a method of bank transfer or account transfer to a deposit or savings account whose account holder name is the name of that person stated in the copy of said identification document, etc. (limited to cases where the copy of said identification document, etc. is preserved together with the books, etc. under Article 16 of the Act or a record by electromagnetic means pertaining to said secondhand article).
>
> **Item 8 (八)** Receiving a declaration from the counterparty of their address, name, occupation, and age, together with receiving transmission, using software provided by said secondhand articles dealer, of identification image information (meaning image information of the facial appearance of said counterparty and an identification document, etc. (limited to one with a photograph of said counterparty affixed; hereinafter referred to as a "photo identification document, etc." in this Item and the following Item) photographed by having said counterparty use said software, where the image information pertaining to said photo identification document, etc. allows verification of the address, name, and age or date of birth stated in said photo identification document, etc., the photograph affixed to said photo identification document, etc., and the thickness and other features of said photo identification document, etc.) (limited to cases where said identification image information (excluding image information of the facial appearance of said counterparty) is preserved together with the books, etc. under Article 16 of the Act or a record by electromagnetic means pertaining to said secondhand article).
>
> **Item 9 (九)** Receiving a declaration from the counterparty of their address, name, occupation, and age, together with receiving transmission, using software provided by said secondhand articles dealer, of identification image information (meaning image information of the facial appearance of said counterparty photographed by having said counterparty use said software), and receiving transmission from said counterparty of said information recorded in a semiconductor integrated circuit embedded in a photo identification document, etc. of said counterparty (limited to one in which a semiconductor integrated circuit recording information on address, name, age or date of birth, and photograph is embedded).
>
> **Item 10 (十)** Receiving a declaration from the counterparty of their address, name, occupation, and age, and having said counterparty write their name using an instrument in the presence of said secondhand articles dealer or their agent, etc. (limited to writing performed so that said name is clearly displayed by electromagnetic means on the screen of a computer (including input/output devices; the same applies hereinafter) used by said secondhand articles dealer). In this case, when there is reason to suspect that the address, name, occupation, or age pertaining to said declaration is not genuine, the dealer must endeavor to verify that address, name, occupation, or age as prescribed in Paragraph 1.
>
> **Item 11 (十一)** Receiving provision from the counterparty of a signing certificate issued by the Japan Agency for Local Authority Information Systems (J-LIS) pursuant to the provisions of Article 3, Paragraph 6 or Article 16-2, Paragraph 6 of the Act on Certification Business of the Japan Agency for Local Authority Information Systems Regarding Electronic Signatures, etc. (Act No. 153 of 2002; hereinafter referred to as the "Public Personal Authentication Act" in this Item and the following Item) as well as a record by electromagnetic means of the address, name, occupation, and age of said counterparty on which an electronic signature prescribed in Article 2, Paragraph 1 of the Public Personal Authentication Act has been performed (limited to cases where said secondhand articles dealer is a signature verifier prescribed in Article 17, Paragraph 4 of the Public Personal Authentication Act).
>
> **Item 12 (十二)** Receiving provision from the counterparty of an electronic certificate issued by a person accredited by the Prime Minister and the Minister for Internal Affairs and Communications as listed in Article 17, Paragraph 1, Item 5 of the Public Personal Authentication Act who is a signature verifier prescribed in Paragraph 4 of the same Article, and used for a specified certification business (meaning a specified certification business prescribed in Article 2, Paragraph 3 of the Act on Electronic Signatures and Certification Business (Act No. 102 of 2000; hereinafter referred to as the "Electronic Signature Act" in this Item)) performed by said accredited person (limited to one issued after verification of the authenticity of the user (meaning a user prescribed in Article 2, Paragraph 2 of the Electronic Signature Act) pertaining to said counterparty is performed by a method prescribed in the items of Article 5, Paragraph 1 of the Enforcement Rules of the Act on Electronic Signatures and Certification Business (2001 Ordinance of the Ministry of Internal Affairs and Communications, Ministry of Justice, and Ministry of Economy, Trade and Industry No. 2)), as well as a record by electromagnetic means of the address, name, occupation, and age of said counterparty on which an electronic signature prescribed in Article 2, Paragraph 1 of the Electronic Signature Act has been performed.
>
> **Item 13 (十三)** Assigning an identification code (meaning an identification code prescribed in Article 2, Paragraph 3 of the Act on Prohibition of Unauthorized Computer Access (Act No. 128 of 1999)) to a person for whom measures listed in Article 15, Paragraph 1, Items 1 to 3 of the Act or the preceding items have been taken, and ascertaining that the measures listed in these provisions have already been taken for the counterparty by receiving transmission thereof or by another method capable of identifying the person for whom the measures listed in these provisions were taken and making it difficult for a third party to impersonate that person.

### Article 16 (Secondhand Articles, etc. Exempt from Verification Obligations, etc.)

> The amount specified by National Public Safety Commission Rules under Article 15, Paragraph 2, Item 1 of the Act shall be 10,000 yen.
>
> 2. The secondhand articles specified by National Public Safety Commission Rules under Article 15, Paragraph 2, Item 1 of the Act shall be secondhand articles falling under any of the following items:
>
> **Item 1 (一)** Motorcycles and motorized bicycles (including parts thereof (excluding screws, bolts, nuts, cords, and other general-purpose parts))
>
> **Item 2 (二)** Outdoor units of air conditioners and heat pumps of electric water heaters
>
> **Item 3 (三)** Articles recording programs used exclusively for home computer games
>
> **Item 4 (四)** Articles recording sound or images by optical means
>
> **Item 5 (五)** Electric wires
>
> **Item 6 (六)** Gratings (limited to those made of metal)
>
> **Item 7 (七)** Books

→ Item 11 (十一) (JPKI) of Article 15, Paragraph 3 of the Enforcement Rules of the Secondhand Articles Dealer Act, like Article 6, Paragraph 1, Item 1 (ka) (カ) (new (nu) (ヌ) in the 2027 version) of the Enforcement Rules of the Act on Prevention of Transfer of Criminal Proceeds, is **"limited to cases where said secondhand articles dealer is a signature verifier prescribed in Article 17, Paragraph 4 of the Public Personal Authentication Act."**
The target signing certificate is one based on Article 3, Paragraph 6 (signing certificate for Individual Number Card) **or** Article 16-2, Paragraph 6 (signing certificate for mobile terminal equipment) of the Public Personal Authentication Act (article headings of the same Act confirmed via `law_data/414AC0000000153` on 2026-10-05). The target of the electronic signature is "a record by electromagnetic means of the **address, name, occupation, and age** of said counterparty," which differs from "information regarding specific transactions, etc." under the Act on Prevention of Transfer of Criminal Proceeds.

→ The terms "card-substitute electromagnetic record (カード代替電磁的記録)" and "specific electromagnetic record (特定電磁的記録)" do not appear anywhere in the full text of the Enforcement Rules (revision retrieved on 2026-10-05). A method of receiving transmission of a specific electromagnetic record of a My Number Card installed on a smartphone — corresponding to current (ru) (ル) (new (to) (ト) in the 2027 version) of the Act on Prevention of Transfer of Criminal Proceeds — **does not exist** in Article 15, Paragraph 3.

### Reference: Related Provisions of the Secondhand Articles Dealer Act (Principal Act) (Revision `324AC0000000108_20250601_504AC0000000068`)

#### Secondhand Articles Dealer Act Article 15, Paragraph 1 (Main Body of Verification Obligation; Measures in Paragraph 3 Are Delegated by Item 4 of the Same Paragraph)

> When a secondhand articles dealer intends to purchase or exchange secondhand articles, or accept entrustment of sale or exchange, the dealer must take one of the measures listed in the following items in order to verify the authenticity of the counterparty:
>
> **Item 1 (一)** Verify the address, name, occupation, and age of the counterparty.
>
> **Item 2 (二)** Receive delivery from the counterparty of a document stating their address, name, occupation, and age (limited to one bearing that person's signature).
>
> **Item 3 (三)** Receive provision from the counterparty of a record by electromagnetic means (meaning electronic means, magnetic means, or other means that cannot be recognized by human perception; the same applies hereinafter) of their address, name, occupation, and age, on which an electronic signature (meaning an electronic signature prescribed in Article 2, Paragraph 1 of the Act on Electronic Signatures and Certification Business (Act No. 102 of 2000), limited to one for which certification prescribed in Article 2, Paragraph 2 of the same Act is performed by a person accredited under Article 4, Paragraph 1 or Article 15, Paragraph 1 of the same Act) by that person has been performed regarding such information.
>
> **Item 4 (四)** Beyond what is listed in the preceding three items, measures specified by National Public Safety Commission Rules as measures equivalent thereto.

#### Secondhand Articles Dealer Act Article 15, Paragraph 2 (Exemption from Verification Obligation)

> 2. Notwithstanding the provisions of the preceding paragraph, it is not required to take the measures prescribed in the same paragraph in the following cases:
>
> **Item 1 (一)** When conducting a transaction where the total amount of consideration is less than the amount specified by National Public Safety Commission Rules (excluding cases of conducting a transaction pertaining to secondhand articles specified by National Public Safety Commission Rules as those for which it is particularly necessary to take the measures prescribed in the preceding paragraph).
>
> **Item 2 (二)** When purchasing an article that the dealer themselves sold from the counterparty to said sale.

#### Secondhand Articles Dealer Act Article 16, Paragraph 1 (Entry in Books, etc.; Excerpt = Introductory Clause, Item 4, and Item 5)

> Whenever a secondhand articles dealer receives or delivers secondhand articles for purchase/sale or exchange, or by entrustment of purchase/sale or exchange, the dealer must enter the following matters in books or documents equivalent thereto specified by National Public Safety Commission Rules (hereinafter referred to as "books, etc."), or record them by electromagnetic means. However, this does not apply in the cases listed in the items of Paragraph 2 of the preceding Article or when delivering secondhand articles specified by National Public Safety Commission Rules as those requiring no such entry or record:
>
> **Item 4 (四)** The address, name, occupation, and age of the counterparty (excluding a counterparty to whom secondhand articles specified by National Public Safety Commission Rules were delivered)
>
> **Item 5 (五)** The category of measures taken pursuant to the provisions of Paragraph 1 of the preceding Article (for measures listed in Items 1 and 4 of the same paragraph, their category and method)

#### Secondhand Articles Dealer Act Article 18, Paragraph 1 (Preservation of Books, etc.)

> A secondhand articles dealer or secondhand articles market operator must keep the books, etc. under the preceding two Articles at their business office or secondhand articles market for three years from the day of the final entry, or preserve the record by electromagnetic means under the preceding two Articles for three years from the day of making said record so that it can be immediately displayed in writing at their business office or secondhand articles market.

→ The recording obligation under the Secondhand Articles Dealer Act is not a "confirmation record" under the Act on Prevention of Transfer of Criminal Proceeds (Article 6 of the Act on Prevention of Transfer of Criminal Proceeds), but an entry in **books, etc.** (Article 16 of the Principal Act: the counterparty's address, name, occupation, and age, and the category and method of measures taken) and preservation for **3 years** from the final entry date (or recording date for electromagnetic records) (Article 18, Paragraph 1 of the Principal Act). Details of the format and entry method for books, etc. under the Enforcement Rules are unverified in this retrieval.

---

## Unverified / Points Requiring Attention

- **Article-by-article collation of branch numbers and requirements** of each sub-item of Article 6, Paragraph 1, Item 1 of the 2027 version (remains a summary of e-Gov API excerpts). However, new (nu) (ヌ) = JPKI and the target person limitation of new (wa) (ワ) and new (ka) (カ) were confirmed verbatim on 2026-10-05 (§2).
- Relationship between "Ordinance No. 1" and "Ordinance No. 5" of the 2026 (Reiwa 8) amendments (JAFIC is based on Ordinance No. 1; the 2027-04-01 revision on e-Gov is Ordinance No. 5).
- **Article-by-article text of the Supplementary Provisions (effective date and transitional measures)** of the Enforcement Rules of the Mobile Phone Fraud Prevention Act.
- Each item of Article 15, Paragraph 3 of the Enforcement Rules of the Secondhand Articles Dealer Act was retrieved verbatim in §5 (2026-10-05). However, any amendment to the Enforcement Rules of the Secondhand Articles Dealer Act linked to the April 2027 amendment of the Act on Prevention of Transfer of Criminal Proceeds is not registered on e-Gov (as of 2026-10-05), and whether there will be future amendments is unverified. Details of the format and entry method (on the Enforcement Rules side) for books, etc. (Article 16 of the Principal Act) are also unverified.
- Identity verification methods at the time of Individual Number (My Number) acquisition under the Enforcement Rules of the Number Use Act (outside the scope of this retrieval).
