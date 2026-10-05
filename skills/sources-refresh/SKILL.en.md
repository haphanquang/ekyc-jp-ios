---
name: sources-refresh
description: Use when re-acquiring primary sources (JPKI-related pages and PDFs on digital.go.jp, and e-Gov law search revisions for the Enforcement Ordinances of the Act on Prevention of Transfer of Criminal Proceeds, the Mobile Phone Fraud Prevention Act and the Secondhand Articles Dealer Act, and for the Public Personal Authentication Act) to check for differences. Document updates / re-acquiring sources / updating JPKI materials / digital.go.jp diff checking / re-confirming method designations in laws / updating sources.md and hourei-eKYC.md. Executes `references/refresh.sh` to report New, Disappeared, and CHANGED files. The script does not modify SKILL.md. A human decides which skills to update for CHANGED materials.
---

# Re-acquiring Primary Sources and Difference Checking (sources-refresh)

`references/refresh.sh` is simply a tool that re-fetches primary materials, checks them against the records in `references/sources.md`, and reports **New, Disappeared, CHANGED, and same**.
It does not automatically modify any `SKILL.md`. When there is a CHANGED item, a **human judges** which skill descriptions need review by following the procedure in this skill.

## When to Use This Skill

- Routine maintenance. Roughly 3 months after the previous `Last Verified` date.
- Before answering questions related to the timing of institutional revisions in 2026/2027 (revision timing, enforcement schedule, transitional measures for the Act on Prevention of Transfer of Criminal Proceeds, Mobile Phone Fraud Prevention Act, etc.). Do not make assertions based on an old `sources.md`.
- When you suspect the version number of guidelines, the list of platform operators, or forms may have changed.
- When you find a broken link (404) in a `sources.md` URL.

## Procedure

Make each step a todo when executing.

1. **Read `references/sources.md`.** Grasp the 2 known primary pages, the PDF list (URLs, acquisition dates, SHA256, used skills), and the lines under `## 未取得` (not yet acquired).
2. **Re-acquire the 2 primary pages.** Re-fetch the Japanese and English `jpki-introduction` pages (performed by `refresh.sh`).
3. **Extract `.pdf` links from the pages.** `refresh.sh` gathers `href="...pdf"`, normalizes relative paths to absolute URLs, and compares them with the known URLs in `sources.md`.
4. **Categorize into New, Disappeared, and CHANGED.**
   - New = Exists on the page but not in `sources.md`.
   - Disappeared = Exists in `sources.md` but disappeared from the page.
   - CHANGED is determined in the next step.
5. **Re-download known PDFs and compare SHA256.** `refresh.sh` re-fetches each URL and checks it against the SHA256 recorded in `sources.md`. If they match, it prints `same`; if not, it prints `CHANGED`. Downloaded PDFs are saved to `references/pdfs/NN_*.pdf` (a local cache ignored by `.gitignore`; the PDFs are third-party works and are not shipped in the repository).

   ```
   bash references/refresh.sh
   ```

6. **Update `sources.md` and `references/CHANGELOG-sources.md`.**
   Add lines for New URLs. Move Disappeared URLs to `## 未取得` or delete them and write the reason.
   For CHANGED, update the SHA256 and acquisition date. Record the changes with dates in `CHANGELOG-sources.md`.
7. **Review the skills listed in the `使用スキル` (citing skills) column for CHANGED materials.** Open the skills listed in the `使用スキル` column of the relevant row in `sources.md`, and check if cited sections, numbers, or version numbers conflict with the new PDF. A human judges and fixes any discrepancies. `refresh.sh` does not modify the skill body.
8. **Match e-Gov law revisions.** `refresh.sh` fetches the **revision IDs** for the Enforcement Ordinance of the Act on Prevention of Transfer of Criminal Proceeds (current and 2027-04-01 un-enforced versions), Enforcement Ordinance of the Mobile Phone Fraud Prevention Act, Public Personal Authentication Act, and Enforcement Ordinance of the Secondhand Articles Dealer Act from the e-Gov Law Search API v2, and compares them with the `取得リビジョン` (recorded revision) line in the matching section of `references/hourei-eKYC.md`. If `CHANGED`, re-read the legal text of that revision on e-Gov (especially method designations in Article 6, Paragraph 1, Item 1, and Article 19 of the Ordinance for Enforcement of the Act on Prevention of Transfer of Criminal Proceeds, Article 3 of the Ordinance for Enforcement of the Mobile Phone Act, Article 17 of the Public Personal Authentication Act, and Article 15, Paragraph 3 of the Ordinance for Enforcement of the Secondhand Articles Dealer Act), update the excerpts and revision IDs in `hourei-eKYC.md`, and then have a human match the method designations and application dates in `references/method-map.md` and `skills/honnin-kakunin-houhou/SKILL.md`. Since the 2027-04-01 version may be amended again before enforcement, execute this step every time before answering questions related to the timing of institutional revisions.

## How to Read the Results

The script prints its messages in Japanese. The first column shows them verbatim, with an English gloss.

| Display | Meaning | Action |
|---|---|---|
| `same` | The re-acquired PDF is identical to the record. | No action needed. |
| `CHANGED` | The PDF differs from the SHA256 recorded in `sources.md`. The new file has been saved to the local `pdfs/`. | Execute steps 6 and 7. |
| URL under `-- 新規 --` (new) | A new PDF was added to the page. | Add a row to `sources.md`, import to plugin if necessary. |
| URL under `-- 消滅 --` (disappeared) | A PDF disappeared from the page (replaced/abolished). | Find successor material, update `sources.md`. Record in CHANGELOG. |
| `?? ファイル未対応` (no file mapping) | The URL has no `pdfs/` file entry in `sources.md` (e.g., J-LIS material under `## 未取得`). | Expected. Items requiring manual acquisition remain under `## 未取得`. |
| `!! 取得失敗（HTTP エラー等）` (fetch failed) | A known URL returned 4xx/5xx (broken link/moved). The local PDF **was not modified**. | Manually check the URL, find the successor URL, and update `sources.md`. Record in CHANGELOG. |
| `!! PDF ではない/小さすぎる応答` (not a PDF / too small) | The response lacks a PDF header or is under 1KB (error page, etc.). The local PDF **was not modified**. | Same as above. The script does not `cp` to avoid erroneous overwrites. |
| `same <法令名> (<リビジョン ID>)` (law name, revision ID) | The e-Gov law revision matches the record in `hourei-eKYC.md`. | No action needed. |
| `CHANGED <法令名>` + `記録 = … / 現在 = …` (recorded / current) | The e-Gov law was amended, and the revision ID changed. | Execute step 8 (Update excerpts/IDs in `hourei-eKYC.md` -> Human matches method designations in `method-map.md` / `honnin-kakunin-houhou`). |
| `?? 記録リビジョンが見つからない` (recorded revision not found) | The matching section of `hourei-eKYC.md` (`## 1.`–`## 5.`) has no `取得リビジョン` line. Happens when sections are renumbered. | Align the section numbers in `hourei-eKYC.md` with the 4th argument of `check_law` at the end of `refresh.sh`. |
| `?? リビジョン ID を抽出できず` (revision ID not extracted) | No revision ID could be extracted from the e-Gov API response. | Check manually whether the API v2 response format has changed. |

## What to Do After CHANGED

- [ ] Update the SHA256 of the relevant row in `sources.md` to the new value.
- [ ] Update the acquisition date of the relevant row in `sources.md` to the execution date.
- [ ] Enter the date, document name, and summary of changes in `CHANGELOG-sources.md`.
- [ ] Review the `Last Verified` and `Unverified Items` of each skill listed in the `使用スキル` column for that row. Fix citations if they are outdated, and leave points that cannot be fully confirmed as `Unverified`.
- [ ] **Skill bodies are not automatically fixed.** A human judges what and how to fix by comparing the old and new PDFs. `refresh.sh` only shows the differences, it does not judge or edit.

## Sources

- `references/sources.md` — List of primary sources (URL, acquisition date, SHA256, used skills).
- `references/hourei-eKYC.md` — Primary law excerpts and e-Gov revision IDs for the Act on Prevention of Transfer of Criminal Proceeds, Mobile Phone Fraud Prevention Act, Public Personal Authentication Act, and Secondhand Articles Dealer Act.
- `references/refresh.sh` — Script for re-acquisition and difference checking (PDFs + e-Gov law revisions).
- `references/CHANGELOG-sources.md` — Change history.
- Public Personal Authentication Service (For private businesses): https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction (Verified 2026-09-08)
- e-Gov Law Search API v2: https://laws.e-gov.go.jp/api/2/law_data/ (Destination for matching revision IDs. Verified 2026-09-10)

## Last Verified

2026-09-11

## Unverified Items

None
