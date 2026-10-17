<!--
Source: https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction
English version: https://www.digital.go.jp/en/policies/mynumber/private-business/jpki-introduction
Retrieved: 2026-09-07
Auto-converted from page HTML as of the retrieval date. Minor formatting cleanup only.
-->

# Public Personal Authentication Service (JPKI)

_Last updated on digital.go.jp: September 3, 2026_

This page provides a comprehensive overview of the basic information (service features and authentication mechanisms), service adoption case studies, and practical information (adoption methods, adoption procedures, Public Personal Authentication Service usage fees, etc.) needed for local governments and private-sector businesses to introduce the Public Personal Authentication Service (JPKI*1).

*1 Japanese Public Key Infrastructure

## What's New

- June 23, 2026: 6.1. Updated materials for the Service for Providing the Latest User Information (Four Attributes).
- April 13, 2026: Published the Guidelines for Private-Sector Businesses on Using the Public Personal Authentication Service (Version 1.8).
- Updated the material "Obtaining Consent for the Service for Providing the Latest User Information (Four Basic Attributes) under the Public Personal Authentication Act" under "6. Functional Expansion of the Public Personal Authentication Service."
- March 31, 2026: Added "Liquid, Inc." to Contact Information for Services Provided by Platform Operators.
- January 28, 2026: Added "Primagest, Inc." to Contact Information for Services Provided by Platform Operators.
- December 26, 2025: Updated the inquiry email address (Digital Agency) for competent minister certification in the Public Personal Authentication Service.

## Table of Contents

- What is the Public Personal Authentication Service?
- Service Features: Improving Customer Service
- Reducing Administrative Costs
- Enhancing Security
- How to Introduce the Service: Service Introduction Methods: Method of Becoming a Service Provider Operator
- Method of Becoming a Platform Operator
- Procedures for Becoming a Platform Operator: Obtaining Technical Specifications, etc.
- Competent Minister Certification Procedures
- Preparation for Production Launch
- Public Personal Authentication Service Usage Fees
- Service Adoption Case Studies
- Authentication Mechanism: What is Electronic Certificate Validity?: Conditions for Revocation of Electronic Certificates
- Methods of Certificate Validity Verification
- Types of Electronic Certificates: Signing Certificate
- User-Authentication Certificate
- Functional Expansion of the Public Personal Authentication Service: Service for Providing the Latest User Information (Four Attributes): "User Consent Acquisition Support Service" Required for the "Four Basic Attributes Provision Service" Utilizing Mynaportal
- Installing My Number Card Functions (Electronic Certificates) on Smartphones
- Inquiries: Frequently Asked Questions (FAQ)
- Contact Information: General Inquiries about My Number Card
- Introducing the Public Personal Authentication Service
- Competent Minister Certification in the Public Personal Authentication Service
- Other Services
- Contact Information for Services Provided by Platform Operators
- Related Documents: Guidelines for Private-Sector Businesses on Using the Public Personal Authentication Service
- Procedure Flow for Providing Revocation Information to Signature Verifiers, etc. (Private-Sector Businesses)

## 1. What is the Public Personal Authentication Service?

The Public Personal Authentication Service is a service for performing safe and reliable identity verification online to publicly authenticate a user's identity and confirm that electronic documents such as contracts have not been tampered with, using electronic certificates stored on the IC chip of a My Number Card (the My Number itself is not used). The Public Personal Authentication Service can be introduced and used not only by administrative agencies, but also across various services provided by private-sector businesses.

- [Overview of the Public Personal Authentication System (PDF / 501KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e3ef3a2e/20241119_news_mynumber_outline_01.pdf)

Using the Public Personal Authentication Service is expected to yield benefits such as improved customer service and reduced administrative costs. For example, it can reduce the cost and time required for customers to fill out and mail identity verification documents and application forms. It can also reduce the workload for private-sector businesses in receiving and reviewing documents.

There are 1,307 private-sector businesses using the Public Personal Authentication Service (as of August 17, 2026). It is used in a wide variety of scenarios, including opening bank and securities accounts and concluding loan agreements.

Based on the "Public Personal Authentication Act*2," this system is operated by the Japan Agency for Local Authority Information Systems (hereinafter referred to as "J-LIS"), a corporation jointly managed by the national and local governments, and features the highest level of security and reliability.

When a private-sector business introduces the Public Personal Authentication Service, there are two methods: either obtain certification from the competent minister under the Public Personal Authentication Act to become a certified business operator directly, or use the service by entrusting signature verification operations to a certified business operator. Becoming a certified business operator requires facilities and organizational structures for information management in signature verification operations. Note that cloud services may also be used for these facilities. On the other hand, by entrusting signature verification operations to a certified business operator, businesses can introduce the Public Personal Authentication Service without each business operator having to build its own signature verification facilities.

Initiatives*3 to promote the adoption and expanded use of the My Number Card, including the Public Personal Authentication Service, are being strongly promoted across the entire government, making the My Number Card increasingly convenient and easy to use for citizens. Currently, the number of valid applications*4 for the My Number Card exceeded the number of driver's licenses issued as of January 2023, reaching two-thirds of the population (approximately 83 million applications).

*2 Act on Certification Business of Local Governments Organization for Information Systems in Relation to Electronic Signatures and Electronic User Certificates

*3 For the roadmap of major initiatives, please refer to the following: [Priority Policy Program for Realizing a Digital Society — Work Schedule (PDF / 2,015KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/5ecac8cc-50f1-4168-b989-2bcaabffe870/019e531c/20220607_policies_priority_outline_07.pdf)
Sections relating to the My Number Card
P7: (4) Promoting the Adoption and Use of the My Number Card
P24 to P25: Work Schedule for Digitizing Various Cards Utilizing the My Number Card

*4 The number of My Number Card issuance applications excluding cases with incomplete documents and cases where the application was withdrawn. For the latest number of valid applications, please refer to the [Dashboard on My Number Card Adoption](https://www.digital.go.jp/resources/govdashboard/mynumber_penetration_rate).

## 2. Service Features

The service enables "Improving Customer Service" by eliminating the need to fill in addresses, names, etc. on application forms and reducing the effort of mailing, "Reducing Administrative Costs" by reducing incomplete or erroneous entries through form-less applications, and "Enhancing Security."

### 2.1. Improving Customer Service

It reduces costs borne by customers, such as preparing, filling out, and mailing identity verification documents and application forms. For example, for identity verification when opening a bank account, submitting identity verification documents and an application form was traditionally required, but using the Public Personal Authentication Service enables online identity verification and application. This reduces the costs and time required to prepare, fill out, and mail documents. Furthermore, by auto-populating information from the four basic attributes (address, name, date of birth, and gender) recorded in the signing certificate, the input burden and input errors by customers can be reduced. In addition, because identity verification is completed online, businesses can provide services free from time and location constraints.

### 2.2. Reducing Administrative Costs

It reduces administrative costs borne by private-sector businesses, such as receiving and reviewing identity verification documents and application forms, and mailing notifications to customers. For example, for identity verification when opening a bank account, receiving and reviewing identity verification documents and application forms, as well as requesting resubmission of documents when entries were incomplete, were traditionally required. Using the Public Personal Authentication Service enables online identity verification and application, reducing the workload for these operations.

### 2.3. Enhancing Security

The Public Personal Authentication Service ensures communication security by using a cryptographic technology called "public-key cryptography." "Public-key cryptography" is a method that uses two different keys (a private key and a public key) for encryption and decryption. Its defining characteristic is that data encrypted with one key can only be decrypted with the other paired key. Furthermore, the private key is recorded inside the IC chip of the My Number Card. Because the My Number Card employs countermeasures such as automatically erasing recorded information inside the IC chip if an unauthorized attempt is made to read it, there is no risk of the private key being stolen.

For details on "public-key cryptography," please refer to the following:

- [Public-Key Cryptography (PDF / 512KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/7c53ec45/20230310_private-businessjpki-introduction_outline_01.pdf)

## 3. How to Introduce the Service

This chapter introduces how to implement the service for private-sector businesses interested in adopting the Public Personal Authentication Service.

### 3.1. Service Introduction Methods

When using the Public Personal Authentication Service, the adopting business operator must verify the validity of the electronic certificate provided by the customer. There are two service introduction methods: becoming a "platform operator" that performs certificate validity verification directly, or becoming a "service provider operator" that entrusts certificate validity verification to a platform operator.

#### 3.1.1. Method of Becoming a Service Provider Operator

When using the Public Personal Authentication Service, a business operator that provides services by entrusting electronic certificate validity verification to a PF operator without building its own signature verification facilities is called a service provider operator (hereinafter referred to as an "SP operator"). Because electronic certificate validity verification is entrusted to a PF operator, the cost burden of building and operating facilities is reduced and the lead time to service launch is shortened, enabling low-cost and rapid adoption. The flow of electronic certificate validity verification for an SP operator is shown in Figure 1. Generally, using services related to signature verification incurs a service usage fee set by the PF operator. Usage fees vary depending on the PF operator. For procedures to become an SP operator and service usage fees, please contact the operators listed in "7.2.5. Contact Information for Services Provided by Platform Operators."

Figure 1: Flow of Electronic Certificate Validity Verification (SP Operator)

#### 3.1.2. Method of Becoming a Platform Operator

When using the Public Personal Authentication Service, a private-sector business that directly checks the validity of electronic certificates with J-LIS must build signature verification facilities and obtain certification from the competent minister under the Public Personal Authentication Act to become a "platform operator (hereinafter referred to as a 'PF operator')."

A PF operator can provide electronic certificate validity verification functionality as a platform to other private-sector businesses. Furthermore, the required signature verification facilities can also be deployed on the cloud. This is expected to reduce the cost burden of building and operating facilities and shorten the lead time to service launch.

- [Utilization of the Public Personal Authentication Service by Private-Sector Businesses (Platform Operator System) (PDF / 345KB)](https://www.digital.go.jp/assets/contents/node/information/field_ref_resources/348cf54f-0c15-4b98-bb43-3171f7c092f7/0568b799/20241119_news_mynumber_outline_03.pdf)

Using the service incurs an electronic certificate verification fee payable to J-LIS. The fee is pay-per-use based on the number of verifications, set at 20 yen per verification for a signing certificate and 2 yen per verification for a user-authentication certificate. Note that starting from January 2023, these fees are waived for the time being. For procedures to become a PF operator, please refer to "3.2. Procedures for Becoming a Platform Operator."

### 3.2. Procedures for Becoming a Platform Operator

When introducing the service as a PF operator, you must first obtain the technical specifications, etc. from J-LIS and proceed with the competent minister certification procedures. After obtaining certification, you must prepare the system environment for signature verification and related operations.

Note that it takes approximately 6 months to 1 year from obtaining the technical specifications, etc. to obtaining competent minister certification. For an overview of the procedures, please refer to the guidelines published below by the Ministry of Internal Affairs and Communications and the Digital Agency.

The overview of the procedures can be found on "Pages 39 to 41: (c) Certification Procedures."

- Guidelines for Private-Sector Businesses on Using the Public Personal Authentication Service (Version 1.8)

#### 3.2.1. Obtaining Technical Specifications, etc.

After executing a confidentiality pledge with J-LIS, apply for disclosure of the technical specifications, etc. relating to the Public Personal Authentication Service. While these documents are required for competent minister certification procedures and system environment preparation, they are also necessary for evaluating service adoption, so please make use of them from the evaluation stage.

#### 3.2.2. Competent Minister Certification Procedures

Based on the technical specifications provided by J-LIS, address the requirements set forth in the certification standards and prepare documents demonstrating compliance with those requirements. Submit those documents to the Digital Agency and the Ministry of Internal Affairs and Communications to apply for a certification review. For inquiries regarding applications, please refer to "7.2.3. Competent Minister Certification in the Public Personal Authentication Service."

#### 3.2.3. Preparation for Production Launch

After obtaining certification, perform operational verification in the test environment of the Public Personal Authentication Service. If there are no issues, submit the required notifications, etc. under the Public Personal Authentication Act to receive electronic certificate validity verification results from J-LIS. Finally, perform operational verification in the production environment and launch the service.

### 3.3. Public Personal Authentication Service Usage Fees

Unlike typical government licensing and approval businesses, using the Public Personal Authentication Service incurs no fees for obtaining or maintaining competent minister certification. Only the electronic certificate verification fee payable to J-LIS is required.

The Public Personal Authentication Service usage fee is pay-per-use based on the number of validity checks, set at 20 yen per check for a signing certificate and 2 yen per check for a user-authentication certificate.

Note that starting from January 2023, these usage fees are waived for the time being*8. This measure aims to lower service usage costs for PF operators and encourage service adoption. For details, please refer to the following:

- [Waiver of Fees for Providing Electronic Certificate Revocation Information in the Public Personal Authentication Service for Three Years for the Time Being, etc.](https://www.digital.go.jp/news/ea776a15-ba19-44af-8d1e-02bd8a94cda2/)

*8 Permanent fee waiver for the CRL method; three-year fee waiver for the time being for the OCSP responder method.

## 4. Service Adoption Case Studies

This chapter introduces adoption case studies among private-sector businesses currently using the Public Personal Authentication Service. It provides reference information on what industries and services have adopted the service, how it is implemented, and what benefits it brings to private-sector businesses and customers, which we encourage you to use when considering adoption. For example, in the banking and securities industries, the Public Personal Authentication Service is widely used for account opening, and its adoption benefits have been well recognized. Copies of identity verification documents and filling out or mailing application forms—previously required when opening an account—are no longer necessary; by using the electronic certificate on the My Number Card, customers can apply easily and accurately from a smartphone or other device. This leads to reduced administrative costs for reception and review, as well as improved customer convenience.

- [List of Businesses and Case Studies Adopting the Public Personal Authentication Service (JPKI) Using My Number Cards](https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction/mynumbercard-user-list)

## 5. Authentication Mechanism

The Public Personal Authentication Service uses electronic certificates stored on the IC chip of the My Number Card. J-LIS, the issuer of the electronic certificates, serves as the trust anchor (the root of trust) and certifies their validity.

### 5.1. What is Electronic Certificate Validity?

Because an electronic certificate may lose its validity under certain conditions, private-sector businesses must verify the validity of electronic certificates submitted by customers.

#### 5.1.1. Conditions for Revocation of Electronic Certificates

Conditions for the revocation of an electronic certificate include expiration of the electronic certificate's validity period, changes to the four basic attributes on the resident record (address, name, date of birth, and gender), or the death of the holder. There are two types of electronic certificates—"signing certificates" and "user-authentication certificates"—and the revocation conditions differ for each. For details on "signing certificates" and "user-authentication certificates," please refer to "5.2. Types of Electronic Certificates." For details on the revocation conditions for electronic certificates, please refer to the following:

- [Cases Where Electronic Certificates Are Revoked and How to Respond (PDF / 107KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/6e4fa365/20221219_private-businessjpki-introduction_outline_01.pdf)

#### 5.1.2. Methods of Certificate Validity Verification

There are two methods for verifying the validity of an electronic certificate: the "CRL provision method" and the "OCSP responder method."

(1) CRL Provision Method: A CRL*5 is a list of electronic certificate revocation information.

The CRL provision method is a method in which a list of electronic certificate revocation information is provided periodically (e.g., once a day).

The CRL provided by J-LIS is updated on a daily basis. A private-sector business downloads it to its local environment and verifies the validity of an electronic certificate by checking it against the serial number of the service user's electronic certificate.

A key feature of the CRL provision method is that validity can be checked even offline.

*5 Certification Revocation List

Figure 2: CRL Provision Method

(2) OCSP Responder Method: OCSP*6 is a communication protocol for verifying the validity of an electronic certificate.

The OCSP responder method is a method in which a response server called an "OCSP responder" individually replies to inquiries regarding the validity of a specific electronic certificate.

Revocation information is stored on the OCSP responder and updated every 15 minutes. The OCSP responder checks the revocation information against the serial number of the service user's electronic certificate and provides the validity check result.

A key feature of the OCSP responder method is that validity can be checked in real time. On the other hand, please note that electronic certificate validity cannot be checked offline.

*6 Online Certification Status Protocol

Figure 3: OCSP Responder Method

### 5.2. Types of Electronic Certificates

There are two types of electronic certificates: "signing certificates" and "user-authentication certificates."

#### 5.2.1. Signing Certificate

Used when creating and transmitting electronic documents such as applications and contracts over the internet, this certificate makes it possible to verify that an electronic document created and transmitted by the user "is an authentic document created by the user and was transmitted by the user." An electronic signature using a signing certificate can qualify for Article 3 (Presumption of Authentic Establishment of Electromagnetic Records)*7 of the Act on Electronic Signatures and Certification Business. In other words, an electronic document bearing an electronic signature performed by the principal that satisfies certain requirements is presumed to have been authentically established (created based on the principal's intent).

*7 Quote from Article 3 of the Act on Electronic Signatures and Certification Business: An electromagnetic record that is made in order to express information (except for that which a public official makes in the course of duties) is presumed to be established authentically if the electronic signature (limited to that which can be performed only by the principal through appropriate management of codes and objects necessary to perform it) is performed by the principal with respect to information recorded in the electromagnetic record.

#### 5.2.2 User-Authentication Certificate

Primarily used when logging into websites and online services, this certificate makes it possible to verify that the person logging in is the user themselves.

Because signing certificates and user-authentication certificates serve different purposes, the information they contain differs. The main difference is whether or not the four basic attributes (address, name, gender, and date of birth) are held within the electronic certificate. A signing certificate, which is used for electronic signatures at the time of application, etc., holds the four basic attributes within the electronic certificate because it is necessary to verify the accurate address, etc. of the applicant. A user-authentication certificate, which is used for logging into websites, etc., only needs to confirm that the person is the user themselves, and therefore does not hold the four basic attributes.

For details on "5.2. Types of Electronic Certificates," please refer to the following:

- [Types of Electronic Certificates (PDF / 501KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e376536f/20221219_private-businessjpki-introduction_outline_02.pdf)

## 6. Functional Expansion of the Public Personal Authentication Service

### 6.1. Service for Providing the Latest User Information (Four Attributes) (Launched May 16, 2023)

Overview of This Service: On the premise that prior consent has been obtained from the individual using the Public Personal Authentication Service, this service enables businesses to inquire online with J-LIS (Japan Agency for Local Authority Information Systems) at any time for a customer's latest four basic attributes (address, name, date of birth, and gender). This allows financial institutions and other businesses, for example, to immediately confirm changes to a customer's address, etc.

This service was launched on May 16, 2023. An overview is available below:

- [Service for Providing the Latest User Information (Four Attributes) Using the Public Personal Authentication Service (PDF / 107KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/3f10dd8b-8c2a-4585-9cdc-674ad2112731/dad77a76/20230516_policies_mynumber_private-business_outline_02.pdf)

Detailed information on this service is provided in "5. Overview of the Service for Providing the Latest User Information (Four Basic Attributes) Based on User Consent (Pages 43 to 49)" in the document below:

- Guidelines for Private-Sector Businesses on Using the Public Personal Authentication Service (Version 1.8)

When a private-sector business provides this service, customer consent is required. Such consent must be easy for the customer to understand and must be reliably obtained. Points to note when obtaining consent are described in the following material; please review it:

- [Obtaining Consent for the Service for Providing the Latest User Information (Four Basic Attributes) under the Public Personal Authentication Act (PDF / 363KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/7b496226/20260413_private-businessjpki-introduction_outline_01.pdf) (Updated April 13, 2026)

Procedures for Using This Service: Because this service is an add-on service to the Public Personal Authentication Service, private-sector businesses must first complete the procedures for using the Public Personal Authentication Service.

After completing the procedures for the Public Personal Authentication Service, please carry out the procedures for using this service.

For details on the Public Personal Authentication Service, please refer to [Electronic Certificates under the Public Personal Authentication Service (For Private-Sector Businesses) (Ministry of Internal Affairs and Communications)](https://www.soumu.go.jp/kojinbango_card/kojinninshou-02.html).

The procedures required to use this service are as follows:

- Service provider operators (businesses that use the Public Personal Authentication Service by entrusting signature verification operations to a platform operator): Service provider operators can receive the information necessary for system integration from the platform operator to which they entrust signature verification operations. The platform operators that support this service are as follows:
- [List of Platform Operators Supporting the Service for Providing the Latest User Information (Four Attributes) (PDF / 699KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/ae271062/20260623_policies_mynumber_private-business_outline_01.pdf) (As of June 10, 2026)
- Platform operators (businesses that have directly obtained competent minister certification to use the Public Personal Authentication Service): An application to J-LIS is required to use this service. Please contact the inquiry desk below. Contact: [Japan Agency for Local Authority Information Systems](https://www.j-lis.go.jp/j-lis_corner/contact/form.xhtml). In addition, you must execute a confidentiality pledge with J-LIS and apply for disclosure of the technical specifications, etc.

#### 6.1.1. The "User Consent Acquisition Support Service" Required for the "Four Basic Attributes Provision Service" Utilizing Mynaportal Was Launched on October 29, 2024.

By using this service, private-sector businesses can obtain the customer consent required to use the "Service for Providing the Latest User Information (Four Attributes)." While consent from new customers can be easily obtained at the time of application, the "User Consent Acquisition Support Service" was launched as a method to smoothly obtain consent from existing customers as well. Please check the details below:

- ["User Consent Acquisition Support Service" Utilizing Mynaportal (PDF / 274KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/a92c7db2/20241101_policies_mynumber_private-business_outline_01.pdf)

##### Benefits of Using This Service

- Benefits for Businesses: Obtaining consent from existing customers becomes easier.
- System development costs for obtaining consent are reduced.
- Once consent is obtained, administrative costs for procedures to update the four basic attributes (such as address) are reduced.
- Input errors on customer change forms are prevented, and customer information can be kept up to date at all times.
- Benefits for Citizens: Procedures can be completed easily using Mynaportal.
- When there is a change of address, etc. due to moving, the procedures previously required with businesses become unnecessary.

##### Sample Notification Emails to Customers

Please refer to the following for sample notifications regarding consent procedures. Note that text data for the email samples will be distributed when the specifications are disclosed.

- [Sample Notification Email to Customers (PDF / 855KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/fd5117d8/20240906_policies_mynumber_private-business_outline_02.pdf)

##### Contact Information

For inquiries regarding this service, please contact us via the link below. Forms: [[Digital Agency] Inquiry Form Regarding the Use of My Number Card (Public Personal Authentication Service)](https://forms.office.com/pages/responsepage.aspx?id=_6DkBnJJi0qvMEVxNh0TRNJv3cv0c0FBhtslb22zQ4BUOTZQWFpGVFBISlVCVlpHRUZFOUVTVDdFVy4u&route=shorturl) *Please select "Four Basic Attributes Provision Service" under question "5. Please select the subject of your inquiry." in the form.

### 6.2. Installing My Number Card Functions (Electronic Certificates) on Smartphones (Launched May 11, 2023)

By installing the electronic certificate functions of the My Number Card on a smartphone, users can now apply for and use various My Number Card-related services anytime and anywhere with just a smartphone, without having to carry their physical My Number Card.

Details are available below. Please refer to them when considering the use of this service. Information will continue to be expanded sequentially.

- [Smartphone Electronic Certificate Installation Service](https://www.digital.go.jp/policies/mynumber/smartphone-certification/)
- [Study Group on Installing My Number Card Functions on Smartphones](https://www.digital.go.jp/councils/smartphone-mynumbercard/)

## 7. Inquiries

### 7.1. Frequently Asked Questions (FAQ)

Please refer to the following page for Frequently Asked Questions (FAQ):

- [Frequently Asked Questions (FAQ): My Number Card Utilization for Private-Sector Businesses](https://www.digital.go.jp/policies/mynumber/private-business/faq)

### 7.2. Contact Information

#### 7.2.1. General Inquiries about My Number Card

For general inquiries about the My Number Card, please check [Inquiries Regarding the My Number System](https://www.digital.go.jp/policies/mynumber_contact).

#### 7.2.2. Introducing the Public Personal Authentication Service

For inquiries regarding the introduction of the Public Personal Authentication Service, please contact us via the [[Digital Agency] Inquiry Form Regarding the Use of My Number Card (Public Personal Authentication Service)](https://forms.office.com/pages/responsepage.aspx?id=_6DkBnJJi0qvMEVxNh0TRNJv3cv0c0FBhtslb22zQ4BUOTZQWFpGVFBISlVCVlpHRUZFOUVTVDdFVy4u&route=shorturl). We also accept inquiries from organizations wishing to request a briefing session or consultation. Briefing sessions are held for organizations so that as many private-sector businesses as possible can use the Public Personal Authentication Service, introducing useful information for evaluating adoption such as overviews of the My Number Card and the Public Personal Authentication Service, use cases, latest trends, and an overview of Mynaportal.

#### 7.2.3. Competent Minister Certification in the Public Personal Authentication Service

Please contact us by email at the addresses below. When sending an email, please address it to both the Digital Agency and Ministry of Internal Affairs and Communications email addresses listed under Recipients and include the items listed under Email Content.

- Recipients: To prevent spam, "@" is displayed as "_atmark_". When sending an email, please replace "_atmark_" with "@" (half-width). Email address (Digital Agency): jpki-daijinnintei_atmark_digital.go.jp
- Email address (Ministry of Internal Affairs and Communications): kouteki-kojin_atmark_soumu.go.jp
- Email Content: Subject line: Enter "Inquiry Regarding PF Operator System, etc. (Company/Organization Name)"
- Email body: Company/organization name, department name, contact person's name, contact information (email address & phone number)

#### 7.2.4. Other Services

For other services, please check each service website:

- [Using the Digital Authentication Service](https://support.aas.digital.go.jp/hc/ja/requests/new?ticket_form_id=33975504314777)
- [Using the Mynaportal API](https://faq.myna.go.jp/helpdesk?category_id=125&site_domain=api)
- [Using the My Number Card Face-to-Face Verification App](https://forms.office.com/pages/responsepage.aspx?id=_6DkBnJJi0qvMEVxNh0TRDnrgI74HABFlH3Laa63rxhUQ1JUTUhCMVBWTkw2TElZS0RGTUFRVVQ3UyQlQCN0PWcu&route=shorturl)

#### 7.2.5. Contact Information for Services Provided by Platform Operators

If you would like more detailed information about services provided by PF operators for customers or SP operators, please contact the PF operators below.

When sending an email, please replace "_atmark_" with "@" (half-width). To prevent spam, "@" is displayed as "_atmark_".

- ICT Town Development Common Platform Promotion Organization (General Incorporated Association) — Department in charge: Technology Division
- Contact: ogura_atmark_topic.or.jp
- Service introduction material: [myTAP (PDF / 1,936KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e15f461e/20241217_policies_mynumber_mynumbercard-user-list_outline_01.pdf)
- NTT DATA Japan Corporation — Department in charge: Digital Community Division, Social Infrastructure Solutions Headquarters
- Contact: bizpico-service_atmark_kits.nttdata.co.jp
- Service introduction material: [BizPICO (PDF / 1,498KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/d046094e-9570-49fa-8158-b912b86593c7/918e9d64/20221101_policies_mynumber_mynumbercard-user-list_outline_01.pdf)
- GMO GlobalSign K.K. — Department in charge: GMO Online Identity Verification Service Inquiry Desk
- Contact: [Inquiry Form (GlobalSing by GMO)](https://jp.globalsign.com/contact/customer/)
- Service introduction material: [GMO Online Identity Verification Service Compatible with the My Number System (PDF / 770KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/d046094e-9570-49fa-8158-b912b86593c7/feb3ba1c/20221101_policies_mynumber_mynumbercard-user-list_outline_02.pdf)
- NEC Corporation — Department in charge: New Business Creation Group, Social and Public Integration Division
- Contact: ss_atmark_mcas.jp.nec.com
- Service introduction material: [My Number Card Authentication Service (PDF / 1,795KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/24845ef6/20241217_policies_mynumber_mynumbercard-user-list_outline_02.pdf)
- CYBERLINKS CO., LTD. — Department in charge: Planning and Sales Section, Public Sales Department, Public Cloud Business Division
- Contact: kikaku-eigyou_atmark_cyber-l.co.jp
- Service introduction material: [MynaSign (PDF / 1,034KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/fe6659db/20241217_policies_mynumber_mynumbercard-user-list_outline_03.pdf)
- Cybertrust Japan Co., Ltd. — Department in charge: Trust Service Management Department
- Contact: ctj_reception_atmark_cybertrust.co.jp
- Service introduction material: [iTrust Identity Verification Service (PDF / 2,594KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/d046094e-9570-49fa-8158-b912b86593c7/87cd07fe/20221007_policies_mynumber_mynumbercard-user-list_outline_04.pdf)
- TOPPAN Inc. — Department in charge: Hybrid BPO Headquarters
- Contact: [TOPPAN Website](https://solution.toppan.co.jp/toppan-edge/service/honninkakunin.html)
- Nomura Research Institute, Ltd. — Department in charge: Social DX Business Division
- Contact: nri-shomn-jigyo_atmark_nri.co.jp
- Workthy Inc. — Department in charge: Financial Business Team
- Contact: t.eguchi_atmark_workthy.jp
- Service introduction material: [Online Hometown Tax Donation "One-Stop Special Exception Application" (PDF / 714KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/f348c809/20260728_policies_mynumber_mynumbercard-user-list_outline_05.pdf)
- TISI, Inc. — Department in charge: My Number Card Identity Verification Service Desk, Financial Business Planning & Sales Department, Financial Business Promotion & Sales Management Division, Financial Business Headquarters 1
- Contact: info-fs_atmark_ml.tisi.jp
- Service introduction material: [TISI, Inc. "My Number Card Identity Verification Service" (PDF / 2,262KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/8dc4190e-109e-4b13-96a0-0dc42f09dbfa/e659a99e/20260903_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf)
- Double Standard Inc. — Department in charge: Data Management Group / Data Management Department
- Contact: [Inquiries (Double Standard)](https://double-std.com/service/jpki-ekyc/#sec_page_form)
- Service introduction material: [eKYC Solution Using Public Personal Authentication (PDF / 788KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/17bd4282/20241217_policies_mynumber_mynumbercard-user-list_outline_04.pdf)
- FLIGHT SOLUTIONS Inc. — Department in charge: Product & Financial Services Division
- Contact: myverifist_atmark_flight.co.jp
- Service introduction material: [myVerifist & Cashless Service (PDF / 1,082KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/beaa4c40/20241217_policies_mynumber_mynumbercard-user-list_outline_05.pdf)
- PocketSign Inc. — Contact: [PocketSign Website](https://pocketsign.co.jp/service/pocketsignplatform)
- Service introduction material: [POCKETSIGN Platform (PDF / 1,229KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/b63b21ef/20260601_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf) (Updated June 1, 2026)
- Bengo4.com, Inc. — Department in charge: CloudSign Business Division
- Contact: contact_atmark_cloudsign.jp
- Service introduction material: [CloudSign (PDF / 766KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/45db0a72/20250109_policies_mynumber_mynumbercard-user-list_outline_01.pdf)
- Mi-Labo, Inc. — Department in charge: Sales Department
- Contact: info_atmark_mi-labo.co.jp
- Service introduction material: [mila-e Authentication (PDF / 1,451KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/530b8043/20250404_policies_mynumber_mynumbercard-user-list_outline_01.pdf)
- NTT DOCOMO BUSINESS, Inc. — Department in charge: Social Innovation Department, Business Solutions Division
- Contact: auth-and-sign-lita_atmark_ntt.com
- Service introduction material: [SmartLiTA (PDF / 1,919KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/b5b5edab/20250815_policies_mynumber_mynumbercard-user-list_outline_02.pdf)
- ACSiON, Ltd. — Department in charge: Sales Department
- Contact: marketing_atmark_acsion.co.jp
- Service introduction material: [ACSiON Public Personal Authentication Service (PDF / 1,630KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/3f9be206/20241217_policies_mynumber_mynumbercard-user-list_outline_09.pdf)
- MRSO Inc. — Department in charge: System Development Department, IT Division
- Contact: [CONTACT (MRSO)](https://www.mrso.jp/corp_inquiry/contact/)
- CrowdShip Inc. — Contact: tsuyoshi.hanai_atmark_growship.com
- Service introduction material: [CrowdShipTrust (PDF / 2,710KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/16122fae/20241217_policies_mynumber_mynumbercard-user-list_outline_10.pdf)
- TRUSTDOCK Inc. — Contact: [TRUSTDOCK Inc.](https://lp.trustdock.io/product/JPKI)
- Service introduction material: [TRUSTDOCK Public Personal Authentication Service (PDF / 583KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e145303e/20250930_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf)
- MynaWallet Inc. — Department in charge: Development Department
- Contact: info_atmark_mynawallet.co.jp
- Service introduction material: [MynaWallet (PDF / 862KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e8cac00c/20251029_policies_mynumber_private-business__faq_platformer-list_outline_01.pdf)
- JMDC Inc. — Department in charge: Insurance Division
- Contact: recoell-support_atmark_jmdc.co.jp
- Service introduction material: [Public Personal Authentication Service Utilizing JMDC's Digital Authentication App (PDF / 417KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/8dc4190e-109e-4b13-96a0-0dc42f09dbfa/d20a4b9d/20251127_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf)
- Primagest, Inc. — Department in charge: New Business Promotion Department
- Contact: [Primagest Trust Services Website](https://www.primagest.net/)
- Service introduction material: [Primagest Trust Services (PDF / 3,331KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/2e3cf4c8/20260512_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf) (Updated May 12, 2026)
- Liquid, Inc. — Department in charge: eKYC Team, Customer Success Department
- Contact: info_atmark_liquidinc.asia
- Service introduction material: [Guide to LIQUID eKYC (PDF / 2,152KB)](https://www.digital.go.jp/assets/contents/node/information/field_ref_resources/1390fa20-61f8-405f-8477-1f7a0f67cce1/5c819ff6/20260413_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf) (Updated April 13, 2026)
- AIFUL CORPORATION — Department in charge: Digital Promotion Department 1
- Contact: asein_operation_atmark_aiful.co.jp

The list above includes only those PF operators that have consented to having their contact information published. Please also note that some PF operators do not provide electronic certificate validity verification functionality as a platform for SP operators.

## 8. Related Documents

### 8.1. Guidelines for Private-Sector Businesses on Using the Public Personal Authentication Service

These guidelines are published by the Ministry of Internal Affairs and Communications to support private-sector businesses in evaluating the use of the Public Personal Authentication Service and to explain the introduction procedures. They compile an overview and benefits of the service, a guide to using the service (information system facilities required by private-sector businesses, competent minister certification standards and procedures, electronic certificate verification fees), and related information.

Please refer to this document if you would like detailed and comprehensive information when considering introducing the service.

- [Guidelines for Private-Sector Businesses on Using the Public Personal Authentication Service (Version 1.8) (PDF / 5,163KB)](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e550d3de/20260413_policies_mynumber_private-business_outline_01.pdf)

The Ministry of Internal Affairs and Communications website hosting this document is listed below for your reference:

- [Electronic Certificates under the Public Personal Authentication Service (For Private-Sector Businesses) (Ministry of Internal Affairs and Communications)](https://www.soumu.go.jp/kojinbango_card/kojinninshou-02.html)

### 8.2. Procedure Flow for Providing Revocation Information to Signature Verifiers, etc. (Private-Sector Businesses)

J-LIS introduces the procedures, operational flows, and required documents for signature verification when a private-sector business introduces the Public Personal Authentication Service as a PF operator.

Please refer to the following material when checking the procedures required with J-LIS:

- [Procedure Flow for Providing Revocation Information to Signature Verifiers, etc. (Private-Sector Businesses) (October 17, 2022, J-LIS)](https://www.j-lis.go.jp/file/20221027minkan.pdf)

The J-LIS website hosting this material is listed below for your reference:

- [Procedures for Using Electronic Certificate Validity Verification, etc. (Private-Sector Use) (J-LIS)](https://www.j-lis.go.jp/jpki/minkan/procedure1_2_2.html)
