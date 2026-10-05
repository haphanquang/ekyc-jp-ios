---
name: kihon-4-jouhou-doui
description: Used when designing the acquisition of user consent using the four basic attributes (name, address, date of birth, gender) and the 'latest user information (4 attributes) provision service' based on the Public Personal Authentication Act. Covers consent screen requirements, 15 items of detailed/supplementary consent explanations, electronic consent acquisition via signing certificates, the 10-year validity period and withdrawal, and the user consent acquisition support service of Mynaportal.
---

# Four Basic Attributes and Consent for the Latest User Information (4 Attributes) Provision Service

A reference summarizing the definition of the four basic attributes, the mechanism of the service, the consent screen requirements demanded by the Ministry of Internal Affairs and Communications / Digital Agency, and the validity period and withdrawal of consent when incorporating the "Latest User Information (Four Basic Attributes) Provision Service", which is a value-added service of the Public Personal Authentication Service, into your company.

- This service is a value-added service **based on the Public Personal Authentication Act (Act on Certification Business of Local Government Information Systems Institution Pertaining to Electronic Signatures, etc.)**, and operates on a different institutional track from non-face-to-face identity verification methods. The selection, legal basis, and enforcement dates of identity verification methods are not covered in this skill. Refer to `honnin-kakunin-houhou`.
- For server-side preservation of acquired consent information, transmission to the Agency, and lifecycle management, refer to `doui-jouhou-kanri`.
- For the overall picture and actors involved in electronic certificate verification and validity checking, refer to `jpki-overview`.

## When to Use This Skill

- When designing a feature to keep customer addresses, names, etc. up to date online without relying on postal mail (Latest User Information (4 Attributes) Provision Service)
- When implementing a consent screen and flow to obtain "user consent to receive the latest four basic attributes from the Agency"
- When confirming what needs to be displayed on the consent screen and what should be written in the "Details and Supplementary Explanations of Consent Items"
- When designing the practical flow for the validity period, withdrawal (cancellation), and inquiries of consent
- When considering whether to use Mynaportal's "User Consent Acquisition Support Service" for obtaining consent from existing customers

## Contents of the Four Basic Attributes

Four Basic Attributes = **Name, Address, Date of Birth, Gender**. They are recorded on the signing certificate, which is recorded after face-to-face identity verification at the municipality. The **target items for consent** in the latest user information (4 attributes) provision service are also **these 4 items** (address, name, date of birth, gender).

Scope of each item (Based on consent screen examples *1 and *2 in PDF 09):

| Item | Scope / Notes |
|---|---|
| Name | If a former surname is jointly written, **the former surname is also included**. **On or after May 26, Reiwa 8 (2026-05-26), the phonetic spelling (furigana) of the name and former surname will also be included** (Text of PDF 09 *1: "On or after May 26, Reiwa 8, the phonetic spelling of the name and former surname will also be included."). |
| Address | If the person has moved overseas, "**the fact that they have moved overseas**" and "**the scheduled date of moving out**" are also included (PDF 09 *2). |
| Date of Birth | — |
| Gender | — |

- From the Agency to the **Platform Operator (PF operator)**, the **issue number of the signing certificate** is provided along with the latest four basic attributes. If the signing certificate is revoked, no provision is made while a new signing certificate has not been issued.
- There are discrepancies among materials regarding the handling of the issue number. PDF 05 §5(3) states that "the issue number is not included in the contents provided to the Service Provider Operator, and is not subject to consent", whereas PDF 09's consent screen example/detailed explanation 1 lists the issue number as an item provided from the Agency to the PF operator (modify description per service). → `## Unverified Items`

## Mechanism of the Latest User Information (4 Attributes) Provision Service

- **Started on May 16, 2023.** A value-added service of the Public Personal Authentication Service for signature verifiers using signing certificates.
- Assuming prior user consent, the latest four basic attributes of **users whose signing certificates have been reissued** due to moving, name change, etc., can be obtained online from the Agency (J-LIS) at any time. Postal mail (address confirmation via reply-paid postcards) becomes unnecessary.
- **Provision Route:** The PF operator receives the latest four basic attributes **directly** from the Agency, and the SP operator (Service Provider Operator) receives them **indirectly via the PF operator**. The PF operator does not store or manage the 4 attributes and discards them after providing them to the SP operator. Storage and management are performed by the Agency and the signature verifier (including SP operators who outsource signature verification to PF operators).
- **Do not inquire or transmit directly to J-LIS from the app or in-house servers. Always route through a PF operator** (see `jpki-overview`).

Process Flow (PDF 05 Figure 5-2):

1. The user completes the card renewal procedure at the municipal counter → The pre-renewal signing certificate is revoked, and a signing certificate recording the updated four basic attributes is reissued.
2. The PF operator, upon request from the SP operator, obtains the revocation information of the previously acquired pre-renewal signing certificate from the Agency.
3. The PF operator provides information on the validity of the signing certificate at arbitrary intervals agreed upon with the SP operator.
4. When the SP operator confirms the revocation, it requests the provision of the latest four basic attributes from the PF operator.
5. The PF operator requests the provision of the latest four basic attributes from the Agency.
6. The Agency checks if the consent is within the validity period, hasn't been cancelled, and what the consent target items are.
7. The Agency provides the PF operator with the latest four basic attributes for the target items consented to.
8. The PF operator provides them to the SP operator.

Supplements:

- Revocation information (CRL) is **updated by J-LIS about once a day (on a daily basis)** and can be matched offline locally. The OCSP responder method operates on a 15-minute basis. The exact update time requires verification (`## Unverified Items`).
- Fees: When the PF operator acquires the latest four basic attributes from the Agency, **20 yen per case**. If there is no latest information, no fee is incurred. The certificate validity verification fee for the CRL method has been free (permanently) since January 2023.
- **Prerequisite for Use:** Procedures for using the Public Personal Authentication Service are required first. The SP operator receives information necessary for system support from the outsourced PF operator. The PF operator applies to J-LIS for the use of this service and requests disclosure of technical specifications, etc., after pledging confidentiality (see `platform-jigyousha`).
- A list of supported PF operators is in `references/pdfs/10_platform-operators-4-info-list.pdf` (As of June 10, Reiwa 8: Nomura Research Institute, TOPPAN, NEC, NTT DATA, Cloudship, Cybertrust, Workthy, PocketSign, ICT Machizukuri Common Platform Promotion Organization, Primagest, Double Standard).

### "User Consent Acquisition Support Service" Leveraging Mynaportal

- **Started on October 29, 2024.** Leverages the Mynaportal API to facilitate consent acquisition, especially from **existing customers**. New customers can be asked for consent at the time of application, but this is a safety net for existing customers.
- Flow (PDF 11): The SP operator sends a QR code/link via postcard, email, etc. → The customer accesses Mynaportal and confirms the consent target (provision of the new address, etc., to Company XX) → Consents by **electronic signature using the My Number Card** → Consent information, electronic certificate information (four basic attributes), PPID, etc., are linked to the SP operator, PF operator, and J-LIS.
- Benefits: Easy consent acquisition from existing customers, reduced system development costs for consent acquisition, reduced administrative costs for address change procedures.

## Consent Screen Requirements

Points to note presented by the Local Administration Bureau Resident System Division My Number System Support Office, Ministry of Internal Affairs and Communications / Citizen Service Group, Digital Agency in PDF 09. Consent is required to be "easy for the user to understand" and "reliably acquired".

### Screen Structure (PDF 09 I)

- [ ] **Provide an independent consent screen consisting of a title, summary, and consent button, and display it in its entirety** (do not bury it in other terms of service, etc.).
- [ ] Prepare "**Agree**" and "**Do not agree**" for the consent buttons (consent is voluntary, and disagreeing does not incur disadvantages).
- [ ] In the summary, state that this is consent to **receive the provision of the customer's latest address, etc. (name, address, gender, date of birth [+ issue number of the signing certificate depending on the service]) from the Agency**, adjusting the text to match the service.
- [ ] Place text such as "**Details and Supplementary Explanations of Consent Items**" directly below the consent screen, and **ensure it can be easily checked, such as by displaying the full text upon clicking**.
- [ ] As a note to the details/supplementary explanations, specify the scope of the name (former surname / phonetic spelling on or after May 26, Reiwa 8) and the scope of the address (fact of moving overseas / scheduled date of moving out) (PDF 09 *1, *2).

### 15 Items to State in "Details and Supplementary Explanations of Consent Items" (PDF 09 II)

The [Required] and [Optional] for each item are as written in PDF 09. **Do not create new items or delete items.**

- [ ] **1 [Required] Provision of latest four basic attributes from the Agency to our company** — When our company requests the provision of the latest four basic attributes from the Agency via the PF operator, the Agency provides the PF operator with the latest four basic attributes (limited to information the customer consented to) and the issue number of the signing certificate. After a signing certificate is revoked, no provision is made while a new signing certificate has not been issued.
- [ ] **2 [Optional] Provision of latest four basic attributes from the PF operator to our company** — The PF operator provides our company with the latest four basic attributes provided by the Agency.
- [ ] **3 [Required] Purpose of use of the latest four basic attributes** — The latest four basic attributes acquired from the Agency will be used only within the scope necessary to achieve the defined purpose of use. The purpose of use will be specifically defined for each usage scenario and announced on the website, etc., and if changed, the person will be notified or it will be announced on the website, etc.
- [ ] **4 [Required] Disclosure request procedures** — We will respond to disclosure requests regarding the date/time of acquisition and the acquired information of the latest four basic attributes upon the customer's request. After identity verification, please fill out the prescribed form, and we will reply at a later date. A prescribed fee will be charged.
- [ ] **5 [Required] Preservation and management of consent information** — Acquired consent information will be appropriately preserved and managed based on the Public Personal Authentication Act, the Personal Information Protection Act, and other laws and regulations, and will be promptly deleted when preservation is no longer necessary. This consent information will be sent to the Agency via the PF operator and will also be managed by the PF operator and the Agency.
- [ ] **6 [Required] Method of acquiring consent** — **Acquisition on paper is not permitted; it will be acquired electronically.** To reliably indicate that it is based on the person's intent, the electronic signature and signing certificate pertaining to the My Number Card will be used. They are submitted to our company and the PF operator, and provided to the Agency along with the validity verification of the signing certificate. **The unit of consent acquisition is per service.** Our company does not retain the submitted signing certificate.
- [ ] **7 [Optional] Blanket acquisition of consent** — To reduce the burden of attaching a signing certificate for each service, consent will be acquired in a blanket manner for services, etc., provided by companies under the holding umbrella, premised on explicit consent for each service (state only if acquiring in a blanket manner).
- [ ] **8 [Required] Validity period of consent, etc.** — The validity period of the acquired consent is, in principle, **10 years** with the day following the date of consent as the starting date. The date of consent is the day the fact of consent is reflected in the Agency's system. Even if the signing certificate is revoked multiple times within the validity period, the consent during the validity period remains valid. Even within the validity period, the customer can apply to cancel the consent at any time.
- [ ] **9 [Required] Ensuring voluntariness and cases of non-consent** — Whether to consent or not is voluntary for the customer. Even if they do not consent, they will not suffer disadvantages such as being unable to receive our company's services.
- [ ] **10 [Required] Suspension of provision of the latest four basic attributes due to application for consent cancellation** — When an application for consent cancellation is made, the validity period is deemed to have ended at the point the fact of said cancellation is reflected in the Agency's system, and the provision from the Agency to our company will be suspended. **Consent cancellation can be done per service, and termination/suspension will apply only to that service.**
- [ ] **11 [Optional] Suspension of provision due to suspension of our company's services, etc.** — If our company's service is suspended, or if there is a request from the customer to suspend the use of the service, in principle, the provision from the Agency to our company will be suspended from the day following the service suspension date.
- [ ] **12 [Required] Contact points for inquiries and cancellation of consent** — For inquiries or cancellation of consent, contact our company's My Page or the "Contact Information" in Item 15. **Inquiries will involve identity verification using the user-authentication certificate, etc.**, and **cancellation will use the signing certificate as it involves transmitting an electronic document pertaining to consent cancellation**.
- [ ] **13 [Required] Inquiries and cancellation using the user client software** — Customers can also make inquiries and cancel consent themselves by downloading the app "User Client Software (JPKI Mobile)" provided by the Agency (state the Agency URL for downloading).
- [ ] **14 [Optional] Re-consenting after canceling consent using the user client software** — When re-consenting after cancellation via the user client software, re-consenting via the user client software is not possible; please re-consent on our company's My Page or contact the "Contact Information".
- [ ] **15 [Required] Contact information regarding the provision of the latest four basic attributes** — State the company name, address, and TEL.

Required = 1, 3, 4, 5, 6, 8, 9, 10, 12, 13, 15 (11 items) / Optional = 2, 7, 11, 14 (4 items).

## Validity Period and Withdrawal of Consent

### Validity Period

- In principle, **10 years** with the **day following** the consent as the starting date. Example in PDF 05 §5(5): Reception date/time 2023-05-18 10:00:00 → Validity period start 2023-05-19 00:00:00 → Validity period end 2033-05-18 23:59:59.
- Even if the signing certificate is revoked multiple times within the validity period, the consent during the validity period remains valid.
- Around the time the 10-year validity period elapses, the signature verifier must **prompt the user to renew the consent**.
- There are discrepancies among materials regarding the base date for calculation (PDF 09 "The day the fact of consent is reflected in the Agency's system" / PDF 05 "The day following the SP operator's reception"). → `## Unverified Items`

### Withdrawal (Cancellation) and Inquiries

- Even within the validity period, the user can **apply to cancel the consent at any time**. Cancellation can be done **per service**, and only the relevant service will be suspended.
- As soon as the Agency receives a cancellation application, it **immediately** suspends the provision of the latest four basic attributes from the Agency to the SP operator.
- **Method of cancellation**: To reliably indicate the person's intent, the **signing certificate** is used just as at the time of consent application (involves transmitting an electronic document pertaining to consent cancellation).
- **Method of inquiry**: Identity verification is performed using the user-authentication certificate, etc.
- **Receiving entity**: In principle, the SP operator that practically interacts with the user (counter, My Page, etc.). However, in the following cases, inquiries and cancellations are also accepted via the Agency-provided app "User Client Software (Windows/Android/Mac/iOS versions. JPKI Mobile)".
  - Outside business hours of the signature verifier/SP operator
  - When wanting to cancel services from multiple businesses in a blanket manner
  - When wanting to cancel urgently, etc.
- **Re-consenting after cancelling via the user client software is not possible via the user client software**. It must be done on the SP operator's My Page, etc.

## Implementation Checklist

- [ ] Consent acquisition is **electronic only** (paper is not permitted). Acquired via **electronic signature using a signing certificate** on the My Number Card or smartphone. The submitted signing certificate is not retained (for the purpose of the consent service). *When performing transaction verification under the Act on Prevention of Transfer of Criminal Proceeds using the ka method (JPKI), Article 19 of the Enforcement Ordinance requires attaching the electronic signature and signing certificate to the verification record and preserving them for 7 years, which is a separate store (`honnin-kakunin-houhou` "Creation and Preservation of Verification Records", `doui-jouhou-kanri`).
- [ ] Design the consent acquisition unit **per in-house service**. If acquiring in a blanket manner, explicitly and comprehensively specify the target services, and explicitly acquire consent for each service.
- [ ] Implement an independent consent screen (title, summary, "Agree"/"Do not agree" buttons, "Details and Supplementary Explanations of Consent Items" link), and ensure the 15 items in `## Consent Screen Requirements` can be displayed in full.
- [ ] Decide how to handle cases where consent is given for only some of the 4 target consent items (the service provider can decide to make the service itself unavailable, but must not impose disadvantages such as making services unavailable simply due to non-consent).
- [ ] Design a lifecycle to **preserve and manage** consent information and electronic certificate information in the in-house DB, and delete it when no longer needed. → **`doui-jouhou-kanri`** (Server-side preservation of consent information, transmission to the Agency, storage period, deletion).
- [ ] Consent information is transmitted via the route **SP Operator → PF Operator → Agency**. Do not inquire or transmit directly to J-LIS from the app / in-house servers (see `jpki-overview`).
- [ ] Prepare deadline management for the **10-year** validity period and a flow for **consent renewal guidance** prior to expiration.
- [ ] Prepare an **inquiry/cancellation reception path** (My Page, etc.) for consent. Verify identity with a signing certificate for cancellation, and a user-authentication certificate, etc., for inquiries.
- [ ] Explicitly state in the help and consent items that the user can inquire/cancel by themselves using the "User Client Software (JPKI Mobile)", and that re-consenting after cancellation must be done through in-house paths.
- [ ] Prepare response procedures, forms, identity verification, and fees for **disclosure requests** (disclosure of acquisition date/time and acquired information).
- [ ] Consider whether to use the Mynaportal "**User Consent Acquisition Support Service**" for acquiring consent from existing customers.
- [ ] Complete the procedures for using the Public Personal Authentication Service as a prerequisite for using this service. The SP operator receives system support information from the PF operator (see `platform-jigyousha`).
- [ ] The selection and legal basis of identity verification methods (Act on Prevention of Transfer of Criminal Proceeds, Mobile Phone Fraud Prevention Act, etc.) are outside the scope of this skill. Refer to `honnin-kakunin-houhou`.

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/pdfs/09_latest-user-info-obtaining-consent.pdf` — "Regarding the Acquisition of Consent Pertaining to the Latest User Information (Four Basic Attributes) Provision Service Based on the Public Personal Authentication Act" (Local Administration Bureau Resident System Division My Number System Support Office, Ministry of Internal Affairs and Communications / Citizen Service Group, Digital Agency). Consent screen structure (I), consent screen examples, scope of name and address (*1, *2; phonetic spelling on or after May 26, Reiwa 8), 15 items for "Details and Supplementary Explanations of Consent Items" and their [Required]/[Optional] distinctions (II). **The required/optional status of the 15 items follows the notation in this PDF.**
- `references/pdfs/08_latest-information-4-types.pdf` — "Latest User Information (4 Attributes) Provision Service Using the Public Personal Authentication Service". Comparison before and after service utilization, overview via PF operator and J-LIS, 4 attributes = address, name, date of birth, gender.
- `references/pdfs/10_platform-operators-4-info-list.pdf` — "List of Platform Operators Supporting the Latest User Information (4 Attributes) Provision Service" (As of June 10, Reiwa 8).
- `references/pdfs/11_personal-consent-support-mynaportal.pdf` — "'User Consent Acquisition Support Service' for the 'Four Basic Attributes Provision Service' Leveraging Mynaportal". Consent flow via QR/links, linked information (consent information, electronic certificate information, PPID, etc.).
- `references/pdfs/05_private-sector-guidelines-v1.8.pdf` §5 "Overview of the Latest User Information (Four Basic Attributes) Provision Service Based on User Consent" (pages 43-49, Version 1.8, 2026-04-13). Mechanism (Figure 5-2), acquisition and cancellation of consent, example of calculating the 10-year validity period, User Client Software (Windows/Android/Mac/iOS versions), fee 20 yen per case.
- `references/jpki-introduction.ja.md` (§6.1 "Latest User Information (4 Attributes) Provision Service" started May 16, 2023, §6.1.1 "User Consent Acquisition Support Service" started October 29, 2024. Digital Agency, acquired 2026-09-07).
- Live URL: <https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction> (Acquired 2026-09-07)

## Last Verified

2026-09-11

## Unverified Items

- **Specific update time of the J-LIS CRL (revocation information).** Primary materials read only stated that the CRL is "updated about once a day (on a daily basis)" and the OCSP responder method is on a "15-minute basis". The specific time (e.g., 7 AM) is unverified in primary sources.
- **Whether the "electronic certificate issue number (serial number)" is included in the consent screen for SP operators and the information received by SP operators.** PDF 09's consent screen example/detailed explanation 1 lists "issue number of the signing certificate" as an item provided from the Agency to the PF operator, but PDF 05 §5(3) states the issue number is not provided to the SP operator and is not subject to consent. Requires verification with the latest PF operator specifications when designing the service.
- **Base date for calculating the 10-year validity period.** PDF 09 states it is the day following "the day the fact of consent is reflected in the Agency's system", while PDF 05 states it is the day following "the day the SP operator received consent from the user", showing inconsistent wording. The practical base date requires verification via PF operator specifications and Agency specifications.
- **Verification via primary sources that the provision of the phonetic spelling of the name and former surname on or after May 26, Reiwa 8 (2026-05-26)** is accompanied by the enforcement of the phonetic spelling system for names under the Basic Resident Registration Act. This skill relies solely on the wording of PDF 09 *1 and does not assert the background of the system.
