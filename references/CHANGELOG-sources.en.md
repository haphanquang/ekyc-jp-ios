# Sources Change Log

Records the results of running the `sources-refresh` skill and `refresh.sh`.
Entries are appended per document only when there is a new, removed, or CHANGED (content changed) item.

## 2026-09-07
- Initial retrieval. 33 PDFs and 2 primary pages. See `sources.md` for details.
- Not retrieved: J-LIS `20221027minkan.pdf` (`https://www.j-lis.go.jp/file/20221027minkan.pdf`).
  j-lis.go.jp rejects scripted retrieval with a Cloudflare JS challenge. Manual retrieval via a browser is required.

## 2026-09-08
- First run of `refresh.sh`; no differences.
  Re-retrieved the 2 primary pages; PDF link extraction found no new or removed items;
  all 33 known PDFs matched by SHA256 (same).
  J-LIS `20221027minkan.pdf` was excluded from the diff because no local file exists (`?? ファイル未対応` = no local file).

## 2026-09-09
- Filled in the `使用スキル` (skills using this source) column of `sources.md` for all 33 items. No new, removed, or content-changed (CHANGED) documents.

## 2026-09-10
- Cleanup following the skill-set review. Relaxed the definition of the `使用スキル` column in `sources.md` to
  "cited in `## 出典` (Sources), or referenced as supporting evidence in the body text," and aligned it so that
  `platform-jigyousha` lists each "ご案内" (guidance) PDF (14/16/17/18/23/26/27/32) referenced in its operator list table in the body, and
  `pin-lock-handling` lists PDF 33, which it references in the body. No change to the content of the retrieved documents.
- Verified the method designations of the Act on Prevention of Transfer of Criminal Proceeds and the Mobile Phone Fraud Prevention Act against primary sources via the e-Gov Law Search API v2, and created `hourei-eKYC.md`.
  Added a "## 法令" (Laws and Regulations) section (L1–L5) to `sources.md`. Retrieved revisions:
  Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds, current `420M60000F5A001_20260806_508M60000F5A006` /
  2027-04-01 version `420M60000F5A001_20270401_508M60000F5A005` (Ordinance No. 5 (令第5号), promulgated 2026-06-26, not yet in force) /
  Ordinance for Enforcement of the Mobile Phone Fraud Prevention Act `417M60000008167_20260806_508M60000008099` (**amendment already in force as of 2026-04-01**) /
  Public Personal Authentication Act `414AC0000000153_20260614_506AC0000000059`.
  Findings: current Act on Prevention of Transfer of Criminal Proceeds Article 6, Paragraph 1, Item 1 = I-method (イ) through Yo-method (ヨ) (Ka-method (カ) = JPKI; the proviso "limited to signature verifiers" retrieved verbatim);
  2027 version = I-method through Ka-method (new Nu-method (ヌ) = JPKI, new Ha-method (ハ) = IC reading + facial image, new To-method (ト) = smartphone-embedded card);
  Mobile Phone Fraud Prevention Act Article 3, Paragraph 1, Item 1 = I-method through Nu-method (the document-image submission method has been removed; Chi-method (チ) = smartphone-embedded card).
  Added an e-Gov revision cross-check step to `refresh.sh`.

## 2026-10-05
- Verified the identity verification methods of the Secondhand Articles Dealer Act (古物営業法) against primary sources via the e-Gov Law Search API v2, and created
  "## 5. 古物営業法施行規則（現行・在効）" (Ordinance for Enforcement of the Secondhand Articles Dealer Act (current, in force)) in `hourei-eKYC.md`. Added L6 (Ordinance for Enforcement of the Secondhand Articles Dealer Act) and
  L7 (Secondhand Articles Dealer Act) to `sources.md`. Retrieved revisions: Ordinance for Enforcement of the Secondhand Articles Dealer Act `407M50400000010_20260812_508M60400000017`
  (National Public Safety Commission Regulation No. 10 of 1995 (Heisei 7); last amended by National Public Safety Commission Regulation No. 17 of 2026 (Reiwa 8), in force 2026-08-12) /
  Secondhand Articles Dealer Act `324AC0000000108_20250601_504AC0000000068`.
  Findings: Ordinance Article 15, Paragraph 3 = items 1–13. Item 11 = JPKI (with the signature-verifier proviso; the signed content is
  a record of address, name, occupation, and age); item 9 = IC reading + facial image; item 8 = document image + facial image; item 4 = IC / image submission, or
  sending a copy of the residence certificate, etc. + non-forwardable mail (of the "item 4 ≈ To/Chi" mapping on p7 of the LIQUID document, the To-type does not match the primary source).
  The terms "card-substitute electromagnetic record" and "specified electromagnetic record" do not appear anywhere in the full text of the Ordinance (no method equivalent to the Ru-method (ル) of the Act on Prevention of Transfer of Criminal Proceeds).
  All 39 revisions under `law_revisions/407M50400000010` are in force (no revisions pending enforcement),
  and `?asof=2027-04-01` also returns the current revision. The text of Article 15 is identical across the preceding 7 revisions (20260710 / 20260601 / 20260501 / 20251001 [2 entries] / 20250628 / 20250501).
  Replaced "## 古物営業法" (Secondhand Articles Dealer Act) in `method-map.md` with a version based on primary sources instead of vendor documents, and
  added `check_law "407M50400000010" "" "古物営業法施行規則（現行）" 5` to `refresh.sh`.
- On the same day, re-verified Article 6, Paragraph 1, Item 1 of the 2027-04-01 version of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds (`420M60000F5A001_20270401_508M60000F5A005`) by
  extracting it directly from the API: new Nu-method = JPKI (with the signature-verifier proviso), new Ru-method = specified certification business (resolves the previously unverified item).
  Because the chapeau of new Wa-method (ワ) states "the same applies in Wa and Ka below," new Wa-method and new Ka-method are
  limited to persons not subject to the Basic Resident Registration Act and persons who have moved abroad; this was reflected in `method-map.md`, `hourei-eKYC.md`, and `honnin-kakunin-houhou`.
  Added Article 15, Paragraph 2 and Article 16 of the Ordinance for Enforcement of the Secondhand Articles Dealer Act (exemption threshold of 10,000 yen, covered secondhand articles) to `hourei-eKYC.md` §5.
