---
name: jpki-overview
description: Used to grasp the overall picture, actors, trust model, and fees of the Public Personal Authentication Service (JPKI / My Number Card). The starting point for considering eKYC architecture. Covers signature verifiers, platform operators, J-LIS, and the differences between signing and user-authentication certificates.
---

# JPKI Overview

A reference on the Public Personal Authentication Service (JPKI) to read before considering eKYC architecture. Summarizes terminology, actors, authentication flows, fees, and a checklist for design decisions. Refer to individual skills (`signature-verification`, `jlis-yukousei-kakunin`, `platform-jigyousha`, etc.) for specific implementation procedures.

## When to Use This Skill

- When starting to design a new eKYC / identity verification feature using the My Number Card
- When deciding whether to use the "signing" or "user-authentication" certificate
- When considering whether to outsource to a platform operator (PF operator) or become one yourself
- When you want to understand the actors and cost structure, such as J-LIS, signature verifiers, and fees

## What is JPKI

The Public Personal Authentication Service (JPKI) is a mechanism for officially verifying a user's identity online and the non-alteration of electronic documents using electronic certificates installed on the IC chip of the My Number Card. The My Number (personal number) itself is not used.

- The legal basis is the "Public Personal Authentication Act". It is operated by the **Japan Agency for Local Authority Information Systems (J-LIS)**, jointly managed by the national and local governments.
- Electronic certificates are issued after strict face-to-face identity verification at the municipality. J-LIS, the issuer, serves as the **trust anchor** and proves their validity.
- It can be introduced not only by administrative agencies but also by private businesses (1,307 utilizing private businesses as of August 17, 2026).

There are two types of electronic certificates.

| Electronic Certificate | Purpose | Four Basic Attributes (Name, Address, Date of Birth, Gender) | Main Revocation Conditions |
|---|---|---|---|
| Signing certificate | Creation and transmission of electronic documents such as applications and contracts. Can verify that it is an "authentic document created and transmitted by the person themselves" | **Retains** | Expiration of validity period, change in four basic attributes (moving, marriage, etc.), death or moving overseas of the person, etc. |
| User-authentication certificate | Logging into websites, etc. Proves only that "the person is the user themselves". Identifies the logged-in person by the issue number | Does not retain | Expiration of validity period, death or moving overseas of the person, etc. (Not revoked by changes in the four basic attributes) |

Electronic signatures using signing certificates can be subject to Article 3 (Presumption of Authentic Execution) of the Electronic Signatures Act.

## Actors and 2 Introduction Methods

| Term | Meaning |
|---|---|
| Signature verifier / User-authentication verifier | A private business that receives and verifies electronic certificates from users. Those who verify signing certificates are signature verifiers, and those who verify user-authentication certificates are user-authentication verifiers |
| J-LIS (Japan Agency for Local Authority Information Systems) | Certificate Authority. Manages the issuance and revocation of electronic certificates and responds to inquiries for certificate validity verification. Trust anchor |
| Platform operator (PF operator) | A business that has received competent minister certification and directly verifies the validity of electronic certificates with J-LIS. Can provide certificate validity verification functions to other businesses as a "platform" |
| Service provider operator (SP operator) | A business that does not have its own signature verification facilities and provides services by outsourcing certificate validity verification to a PF operator |

There are two introduction methods. **Reading the electronic certificate from the IC chip by the app itself is possible with either method**; the difference lies in the route of certificate validity verification.

| Method | Certificate Validity Verification | Competent Minister Certification | Signature Verification Facilities | Period / Cost |
|---|---|---|---|---|
| Become a PF operator | Inquire to J-LIS directly | Required | Develop in-house (cloud is possible) | About 6 months to 1 year from obtaining technical specifications to acquiring certification |
| Become an SP operator | Outsource to a PF operator | Facility development is unnecessary (see proviso below) | Unnecessary | Cheap and quick. Usage fees determined by the PF operator (varies by operator) |

> **Proviso**: When performing **transaction verification under the Act on Prevention of Transfer of Criminal Proceeds using the ka method (JPKI. New nu method from April 2027)**, according to the proviso of Article 6, Paragraph 1, Item 1, ka of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds, **the specified business itself must be a "signature verifier"** (competent minister certification under Article 17, Paragraph 1, Item 6 of the Public Personal Authentication Act + notification to the agency). The PF operator can act as a proxy for certification, notification, and facility development, but the name belongs to the specified business. For details, see `honnin-kakunin-houhou`, `platform-jigyousha`, and `references/hourei-eKYC.md`. This is irrelevant if only the he method (IC reading + facial photo) is used.

## Authentication Flow

In the case of private businesses, the part "Inquire/respond on validity to J-LIS" below is routed via a PF operator (see the [Architecture Consideration Checklist](#architecture-consideration-checklist)).

### Signing Certificate (Example: Final tax return via e-Tax, account opening application)

1. The user encrypts the electronic document (generates an electronic signature) with the signing private key stored on the My Number Card.
2. Sends the encrypted document, public key, and signing certificate along with the document body to the verifier.
3. The verifier decrypts the encrypted document using the sent public key.
4. Matches the decryption result with the document body to detect any alterations.
5. The verifier inquires to J-LIS (Certificate Authority) about the validity of the electronic certificate.
6. J-LIS responds with the validity.
7. If valid, authentication is successful (application, etc., is established).

### User-Authentication Certificate (Example: Login to Mynaportal)

1. The verifier generates a random number (challenge) and sends it to the user.
2. The user encrypts the random number with the user-authentication private key stored on the My Number Card.
3. Sends the ciphertext, public key, and user-authentication certificate along with the random number body to the verifier.
4. The verifier decrypts the ciphertext using the sent public key.
5. Matches the decryption result with the random number body to detect alterations or substitutions.
6. The verifier inquires to J-LIS about the validity of the electronic certificate and receives a response.
7. If valid, authentication is successful. The verifier identifies the logged-in person by the issue number of the electronic certificate.

## Fees

The electronic certificate verification fee to J-LIS is a pay-as-you-go system based on the number of certificate validity verifications.

| Electronic Certificate | Fee |
|---|---|
| Signing certificate | 20 yen / 1 case |
| User-authentication certificate | 2 yen / 1 case |

- **Free for the time being from January 2023** (the CRL provision method is permanently free, and the OCSP responder method is free for the time being for 3 years).
- No costs are incurred for acquiring or maintaining the competent minister certification itself.
- For SP operators, service usage fees determined by the PF operator are incurred separately from this (varies by operator).

## Architecture Consideration Checklist

- [ ] Identify the legal basis for eKYC (Act on Prevention of Transfer of Criminal Proceeds / Mobile Phone Fraud Prevention Act / My Number Act / Secondhand Articles Dealer Act, etc.). Do not assert method names and dates; refer to `honnin-kakunin-houhou` / `references/method-map.md` for details.
- [ ] Decide whether to use signing or user-authentication (signing if the four basic attributes are required for identity verification, user-authentication for person authentication/re-login).
- [ ] Design the app to read the IC chip and generate the electronic signature entirely within the device (do not expose the private key or PIN outside the device).
- [ ] **Always perform certificate validity verification via a PF operator. Do not inquire directly to J-LIS from the app or uncertified in-house servers.**
- [ ] Choose whether to become a PF operator or outsource to a PF operator as an SP operator.
  - [ ] If becoming a PF operator: Competent minister certification is required. Takes about 6 months to 1 year from obtaining technical specifications to acquiring certification.
  - [ ] If becoming an SP operator: Select a PF operator and sign an operator contract. Compare supported reading methods, SDKs/APIs, usage fees, and NDA conditions (see `platform-jigyousha`).
  - [ ] Determine whether to perform **transaction verification under the Act on Prevention of Transfer of Criminal Proceeds using the ka method (JPKI / new nu)**. If so, confirm with legal affairs and the PF operator the necessity of becoming a "signature verifier" in-house, the scope of proxying by the PF operator, and the required period (the proviso in `honnin-kakunin-houhou`).
- [ ] Estimate the schedule. Even for SP operators, procedures via the PF operator for AID disclosure application, usage application, and procedures on the J-LIS side take time (refer to `platform-jigyousha` for rough estimates. Do not assert them in this skill).
- [ ] Design separating a "cryptographically correct electronic certificate" from a "currently valid electronic certificate". Refer to `signature-verification` for signature verification and `jlis-yukousei-kakunin` for certificate validity verification.

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/jpki-introduction.ja.md` (§1 What is the Public Personal Authentication Service, §3 Methods of Service Introduction, §5 Authentication Mechanism)
- Live URL: <https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction> (Acquired 2026-09-07)
- `references/pdfs/01_overview-public-personal-authentication.pdf` (Overview of the Public Personal Authentication system, signature verifier model, revocation conditions)
- `references/pdfs/03_public-key-cryptography.pdf` (Public key cryptography, authentication flow for signing / user-authentication)
- `references/pdfs/04_jpki-platform-operator-system.pdf` (Platform operator system, relationship with SP operators, procedures on the J-LIS side)
- `references/pdfs/21_guide-public-personal-authentication.pdf` (Example of introduction flow from the perspective of an SP operator)

## Last Verified

2026-09-11

## Unverified Items

- The specific period required for procedures on the J-LIS side (AID disclosure application, usage application, screening) when an SP operator introduces it via a PF operator. Do not assert this as it is not explicitly stated in the read primary sources. Supplement it by checking the PF operator materials (`references/pdfs/04`, `05`, `21`, `29`, etc.) in `platform-jigyousha`.
