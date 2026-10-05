# 出典一覧（sources manifest）

最終更新: 2026-10-05

`sources-refresh` スキルが本ファイルを読み取り、一次資料の差分を検出します。
URL が変わった・資料が消えた・新規追加された場合は本表を更新し、
`CHANGELOG-sources.md` に記録してください。

本表は機械可読形式を維持します。パイプ区切り・1 資料 1 行・`ファイル` 列は
`pdfs/NN_name.pdf`・`URL` 列は完全な `https://…` を記載します。

PDF は第三者の著作物のためリポジトリに含めません。`refresh.sh` が `URL` 列から `pdfs/`
（`.gitignore` 対象）に取得し、`SHA256` 列と照合します。

## 一次ページ

| # | ページ | URL | 取得日 | 備考 |
|---|---|---|---|---|
| P1 | 公的個人認証サービス（JPKI）日本語版 | https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction | 2026-09-07 | plugin 内は `jpki-introduction.ja.md` |
| P2 | 同 英語版 | https://www.digital.go.jp/en/policies/mynumber/private-business/jpki-introduction | 2026-09-07 | 参考。`reference/jpki-introduction.en.md`（plugin 外） |

## 法令（e-Gov 法令検索）

条文抜粋は `hourei-eKYC.md`。`sources-refresh` の `refresh.sh` がリビジョン ID を突合する。

| # | 法令 | LawId | 取得リビジョン | e-Gov | 取得日 | 使用スキル |
|---|---|---|---|---|---|---|
| L1 | 犯罪収益移転防止法施行規則（現行） | 420M60000F5A001 | 420M60000F5A001_20260806_508M60000F5A006 | https://laws.e-gov.go.jp/law/420M60000F5A001 | 2026-09-10 | honnin-kakunin-houhou |
| L2 | 犯罪収益移転防止法施行規則（2027-04-01 未施行版） | 420M60000F5A001 | 420M60000F5A001_20270401_508M60000F5A005 | https://laws.e-gov.go.jp/law/420M60000F5A001?asof=2027-04-01 | 2026-09-10 | honnin-kakunin-houhou |
| L3 | 携帯電話不正利用防止法施行規則（現行） | 417M60000008167 | 417M60000008167_20260806_508M60000008099 | https://laws.e-gov.go.jp/law/417M60000008167 | 2026-09-10 | honnin-kakunin-houhou |
| L4 | 電子署名等に係る地方公共団体情報システム機構の認証業務に関する法律（公的個人認証法） | 414AC0000000153 | 414AC0000000153_20260614_506AC0000000059 | https://laws.e-gov.go.jp/law/414AC0000000153 | 2026-09-10 | honnin-kakunin-houhou, platform-jigyousha, jpki-overview |
| L5 | 犯罪による収益の移転防止に関する法律（本法） | 419AC0000000022 | ― | https://laws.e-gov.go.jp/law/419AC0000000022 | 2026-09-09 | honnin-kakunin-houhou |
| L6 | 古物営業法施行規則（現行） | 407M50400000010 | 407M50400000010_20260812_508M60400000017 | https://laws.e-gov.go.jp/law/407M50400000010 | 2026-10-05 | honnin-kakunin-houhou |
| L7 | 古物営業法（本法） | 324AC0000000108 | 324AC0000000108_20250601_504AC0000000068 | https://laws.e-gov.go.jp/law/324AC0000000108 | 2026-10-05 | honnin-kakunin-houhou |

L7（古物営業法 本法）は `refresh.sh` の突合対象外（`check_law` は各節の最初の「取得リビジョン」行のみを読むため）。
`sources-refresh` の際に `https://laws.e-gov.go.jp/api/2/law_revisions/324AC0000000108` を手動で確認する。

## PDF 資料

`使用スキル` 列は当該 PDF を `## 出典` で引用している、または本文中で裏付け資料として参照している
スキルのディレクトリ名（例: `platform-jigyousha` は事業者一覧の各「ご案内」を本文の一覧表で参照する）。
`（未使用）` は現時点でどのスキルも参照していない資料。将来スキルを追加する際の候補資料であり、
削除はしない。

| # | 資料名 | ファイル | URL | 取得日 | SHA256 | 使用スキル |
|---|---|---|---|---|---|---|
| 01 | 公的個人認証制度の概要について | pdfs/01_overview-public-personal-authentication.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e3ef3a2e/20241119_news_mynumber_outline_01.pdf | 2026-09-07 | d4922143c5e4d441362ddf6c2bf9e0b24d6cf390c71ff6e8b37e4a0655be2c20 | jpki-overview |
| 02 | デジタル社会の実現に向けた重点計画　工程表 | pdfs/02_priority-plan-roadmap-digital-society.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/5ecac8cc-50f1-4168-b989-2bcaabffe870/019e531c/20220607_policies_priority_outline_07.pdf | 2026-09-07 | a86cf6e238193e98e4ddfffac753a66c6783248dc4f6dadb95292a76dc3e4a05 | （未使用） |
| 03 | 公開鍵暗号方式 | pdfs/03_public-key-cryptography.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/7c53ec45/20230310_private-businessjpki-introduction_outline_01.pdf | 2026-09-07 | b2820806bd566d6eb87705d82ec4c83b55e5dbf7b2020c8dcbbec85e08ce5604 | jpki-overview |
| 04 | 民間事業者における公的個人認証サービスの活用（プラットフォーム事業者制度） | pdfs/04_jpki-platform-operator-system.pdf | https://www.digital.go.jp/assets/contents/node/information/field_ref_resources/348cf54f-0c15-4b98-bb43-3171f7c092f7/0568b799/20241119_news_mynumber_outline_03.pdf | 2026-09-07 | e00cdaa38315752c30a3d09888d7f389bba417d67ca2e968cd15e0ce0f8eae6b | jpki-overview, platform-jigyousha, jlis-yukousei-kakunin |
| 05 | 公的個人認証サービス利用のための民間事業者向けガイドライン（第1.8版） | pdfs/05_private-sector-guidelines-v1.8.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e550d3de/20260413_policies_mynumber_private-business_outline_01.pdf | 2026-09-07 | 1f7a6c58ebe167c92b6bb5cce0988db23dda618ba86ea758491b084530d93039 | honnin-kakunin-houhou, kihon-4-jouhou-doui, doui-jouhou-kanri |
| 06 | 電子証明書が失効する場合とその対応 | pdfs/06_certificate-expiry-what-to-do.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/6e4fa365/20221219_private-businessjpki-introduction_outline_01.pdf | 2026-09-07 | 921e5b82ffc9022f4fa7e3e1ada16a19471c1ddfae2718e817c32ed82515bf7f | jlis-yukousei-kakunin, pin-lock-handling |
| 07 | 電子証明書の種類 | pdfs/07_types-of-electronic-certificate.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e376536f/20221219_private-businessjpki-introduction_outline_02.pdf | 2026-09-07 | ac31e4968f06127bf23979a9c0efb18ebabd169373a7ebd1fe259f155728e3d3 | mynumber-card-ic, signature-verification |
| 08 | 公的個人認証サービスを利用した最新の利用者情報（4情報）提供サービス | pdfs/08_latest-information-4-types.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/3f10dd8b-8c2a-4585-9cdc-674ad2112731/dad77a76/20230516_policies_mynumber_private-business_outline_02.pdf | 2026-09-07 | e762edadd1f8b65ae147dce0202de39ee6400dac4ad76c12f7e125dad24a8696 | kihon-4-jouhou-doui |
| 09 | 公的個人認証法に基づく最新の利用者情報（基本4情報）提供サービスに係る同意の取得について | pdfs/09_latest-user-info-obtaining-consent.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/7b496226/20260413_private-businessjpki-introduction_outline_01.pdf | 2026-09-07 | fa7f6c284d6199c9e8ddc8e3faa278e39cf40960c895c6e0c653f5ac8889f43f | kihon-4-jouhou-doui, doui-jouhou-kanri |
| 10 | 最新の利用者情報（4情報）提供サービスに対応しているプラットフォーム事業者一覧 | pdfs/10_platform-operators-4-info-list.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/ae271062/20260623_policies_mynumber_private-business_outline_01.pdf | 2026-09-07 | f7d6dc1cdfa2bbb65ebf5ccbfeab4b1c4cc835714a330bff948721d1cc9b4f0e | kihon-4-jouhou-doui, doui-jouhou-kanri |
| 11 | マイナポータルを活用した「本人同意の取得支援サービス」 | pdfs/11_personal-consent-support-mynaportal.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/a92c7db2/20241101_policies_mynumber_private-business_outline_01.pdf | 2026-09-07 | f54761ee7f91f22b81a208da7b9266afc493f8972417f6aad7a27bd148b6a557 | kihon-4-jouhou-doui, doui-jouhou-kanri |
| 12 | 顧客へのご案内メールのサンプル | pdfs/12_sample-customer-invitation-email.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/fd5117d8/20240906_policies_mynumber_private-business_outline_02.pdf | 2026-09-07 | 723ca7fb1d9796a3a9c576e12aec95e76056579901e221bd6e504a049eae38f0 | （未使用） |
| 13 | myTAPのご案内 | pdfs/13_guide-mytap.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e15f461e/20241217_policies_mynumber_mynumbercard-user-list_outline_01.pdf | 2026-09-07 | 7dd081d2268a6b92fa7e7427dd1e2a37fb7a63cb1ede2571806aa93d37da6746 | （未使用） |
| 14 | BizPICOのご案内 | pdfs/14_guide-bizpico.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/d046094e-9570-49fa-8158-b912b86593c7/918e9d64/20221101_policies_mynumber_mynumbercard-user-list_outline_01.pdf | 2026-09-07 | 6106bcf306e3029d2720615d0481f9218870560c2dc9f72d6729c2fe2e8b7485 | platform-jigyousha |
| 15 | マイナンバー制度対応GMOオンライン本人確認サービスのご案内 | pdfs/15_guide-identity-verification.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/d046094e-9570-49fa-8158-b912b86593c7/feb3ba1c/20221101_policies_mynumber_mynumbercard-user-list_outline_02.pdf | 2026-09-07 | 2be9b89d7bf3ce1b7ba2a8fed38fb6023c79ef1826a1f99fe89be75c53b3fbda | platform-jigyousha |
| 16 | マイナンバーカード認証サービスのご案内 | pdfs/16_guide-my-number-card-certification-service.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/24845ef6/20241217_policies_mynumber_mynumbercard-user-list_outline_02.pdf | 2026-09-07 | 29fd761807571e5ec2a6ce4347e56c6161adc3361014d889e3df518d74698e25 | platform-jigyousha |
| 17 | マイナサインのご案内 | pdfs/17_guide-maina-sign.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/fe6659db/20241217_policies_mynumber_mynumbercard-user-list_outline_03.pdf | 2026-09-07 | 3797185c999d768b00b74f61b3cc1f26beec594f2d9f069040f7df2e94538a8f | platform-jigyousha |
| 18 | iTrust 本人確認サービスのご案内 | pdfs/18_guide-itrust-identity-verification.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/d046094e-9570-49fa-8158-b912b86593c7/87cd07fe/20221007_policies_mynumber_mynumbercard-user-list_outline_04.pdf | 2026-09-07 | 21c78d399530069001da948213be613e4c5f3f0d4da2da85d33fcae6af5fb447 | platform-jigyousha |
| 19 | ふるさと納税「ワンストップ特例申請」のオンライン化 | pdfs/19_guide-hometown-tax-one-stop.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/f348c809/20260728_policies_mynumber_mynumbercard-user-list_outline_05.pdf | 2026-09-07 | 7ef842f5b586c69cd621bc9144a2f9eb6348720486a0634786dfac006fb7d6b8 | （未使用） |
| 20 | TISI株式会社「マイナンバーカード本人確認サービス」のご案内 | pdfs/20_guide-tisi-my-number-card-identity-verification.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/8dc4190e-109e-4b13-96a0-0dc42f09dbfa/e659a99e/20260903_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf | 2026-09-07 | b77f6b15379b0d00afe776453dc19c92862c69540778371d3eee383935c7e36f | （未使用） |
| 21 | 公的個人認証を利用したeKYCソリューションのご案内 | pdfs/21_guide-public-personal-authentication.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/17bd4282/20241217_policies_mynumber_mynumbercard-user-list_outline_04.pdf | 2026-09-07 | 319a47120226874f650b6f502c9e3054afccc5076b58fba5441990ae4a63a0b5 | jpki-overview, ios-nfc-ux-errors |
| 22 | myVerifist&キャッシュレスサービスのご案内 | pdfs/22_guide-myverifist-cashless.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/beaa4c40/20241217_policies_mynumber_mynumbercard-user-list_outline_05.pdf | 2026-09-07 | f7a4c2ed872d4468df611cdc54bd13c73e8a6240a50a5ce17546a1a3082522ac | （未使用） |
| 23 | POCKETSIGN Platformのご案内 | pdfs/23_guide-pocketsign-platform.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/b63b21ef/20260601_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf | 2026-09-07 | b5d8955d6bf927c0abe16c35cb2313b5a0b50109e47412dc67192f406b55b69c | platform-jigyousha |
| 24 | クラウドサインのご案内 | pdfs/24_guide-cloudsign.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/45db0a72/20250109_policies_mynumber_mynumbercard-user-list_outline_01.pdf | 2026-09-07 | 706f7a5c2ca13e4efc14d17e9eb31e722a63d5bf6c09309115dd773162427258 | （未使用） |
| 25 | mila-e認証のご案内 | pdfs/25_guide-mila-e-certification.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/530b8043/20250404_policies_mynumber_mynumbercard-user-list_outline_01.pdf | 2026-09-07 | e6ecfb7328f347143e567411b148ff4b4ae899c5c5a4fdadf04d218703b3612c | （未使用） |
| 26 | SmartLiTAのご案内 | pdfs/26_guide-smartlita.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/b5b5edab/20250815_policies_mynumber_mynumbercard-user-list_outline_02.pdf | 2026-09-07 | f543e71f58d428162d36f54fb5e2d8556219e7a268bc9518580b192da1ff6ede | platform-jigyousha |
| 27 | ACSiON公的個人認証サービスのご案内 | pdfs/27_guide-acsion-jpki.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/3f9be206/20241217_policies_mynumber_mynumbercard-user-list_outline_09.pdf | 2026-09-07 | 0092838708c60f047a1c07ed6d807c44eebd80bb4174ee86881239717ace510a | platform-jigyousha |
| 28 | CrowdShipTrustのご案内 | pdfs/28_guide-crowdshiptrust.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/16122fae/20241217_policies_mynumber_mynumbercard-user-list_outline_10.pdf | 2026-09-07 | 149f99b3278a51647457b7af4801f6ac8ec840d706388ab3b741414f4588d02e | （未使用） |
| 29 | TRUSTDOCK公的個人認証サービスのご案内 | pdfs/29_guide-trustdock-jpki.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e145303e/20250930_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf | 2026-09-07 | 60ade8a8bfdfe89c92db1a5878d61f1f237b9ae7c2693f3ed4981f2061bfdf39 | platform-jigyousha, jlis-yukousei-kakunin |
| 30 | マイナウォレットのご案内 | pdfs/30_guide-maina-wallet.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e8cac00c/20251029_policies_mynumber_private-business__faq_platformer-list_outline_01.pdf | 2026-09-07 | 11ac7c081b014c8f270ad06806c4bfad84fa8c936f813e8c088f7f2c46c13d21 | （未使用） |
| 31 | JMDCのデジタル認証アプリを活用した公的個人認証サービスのご案内 | pdfs/31_insurance-division-guide.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/8dc4190e-109e-4b13-96a0-0dc42f09dbfa/d20a4b9d/20251127_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf | 2026-09-07 | 8e2a1bdcbf15152e20402296deb5f8aac3122f3057a4796de62fe9d15d38980c | （未使用） |
| 32 | Primagest Trust Servicesのご案内 | pdfs/32_guide-pridest-trust-services.pdf | https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/2e3cf4c8/20260512_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf | 2026-09-07 | 092330ff3299f76ff906d67fca35cf0ab583d960b9667e8291b878fcad657382 | platform-jigyousha |
| 33 | LIQUID eKYCのご案内 | pdfs/33_guide-liquid-ekyc.pdf | https://www.digital.go.jp/assets/contents/node/information/field_ref_resources/1390fa20-61f8-405f-8477-1f7a0f67cce1/5c819ff6/20260413_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf | 2026-09-07 | 5bf38d654d6d9e9179c27c9a99e529b8dc4ea321fe0a1c43dca4e36ce2204f04 | honnin-kakunin-houhou, kenmen-nyuryoku-hojo-ap, kenmen-jikou-kakunin-ap, pin-lock-handling, signature-verification, ekyc-session-orchestration, ios-nfc-ux-errors, ios-security, platform-jigyousha |

## 未取得

| 資料名 | URL | 理由 |
|---|---|---|
| 署名検証者等失効情報提供手続きフロー（民間事業者）（J-LIS 令和4年10月17日） | https://www.j-lis.go.jp/file/20221027minkan.pdf | j-lis.go.jp が Cloudflare の JS チャレンジでスクリプト取得を拒否。ブラウザで手動取得が必要。 |
