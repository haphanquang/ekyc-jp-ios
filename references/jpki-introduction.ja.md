<!--
出典: https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction
英語版: https://www.digital.go.jp/en/policies/mynumber/private-business/jpki-introduction
取得日: 2026-09-07
取得日時点のページ HTML から自動変換。軽微な整形のみ実施。
-->

# 公的個人認証サービス（JPKI）

_digital.go.jp 上の最終更新日: 2026年9月3日_

自治体や民間事業者の皆様に公的個人認証サービス（JPKI※1）を導入していただくにあたって必要となる基礎情報（サービスの特徴や認証の仕組み）やサービス導入事例、サービス導入のためのお役立ち情報（導入方式、導入のための手続き、公的個人認証サービス利用料など）をまとめてご紹介します。

※1 Japanese Public Key Infrastructure

## 新着情報

- 2026年6月23日6.1. 最新の利用者情報（4情報）提供サービスの資料を更新しました。
- 2026年4月13日公的個人認証サービス利用のための民間事業者向けガイドライン（第1.8版）を掲載しました。
- 「6. 公的個人認証サービスの機能拡充」に係る資料「公的個人認証法に基づく最新の利用者情報（基本4情報）提供サービスに係る同意の取得について」を更新しました。
- 2026年3月31日 プラットフォーム事業者の提供サービス等に関する問合せ先に「株式会社Liquid」を追加しました。
- 2026年1月28日 プラットフォーム事業者の提供サービス等に関する問合せ先に「株式会社プリマジェスト」を追加しました。
- 2025年12月26日 公的個人認証サービスにおける主務大臣認定についての問合せ先メールアドレス（デジタル庁）を更新しました。

## 目次

- 公的個人認証サービスとは
- サービスの特徴顧客サービスの向上
- 事務コスト削減
- セキュリティ強化
- サービス導入の方法サービス導入方式サービスプロバイダ事業者になる方式
- プラットフォーム事業者になる方式
- プラットフォーム事業者になるための手続き技術仕様等の入手
- 主務大臣認定手続き
- 本番利用開始準備
- 公的個人認証サービス利用料
- サービス導入事例
- 認証の仕組み電子証明書の有効性とは電子証明書の失効条件
- 電子証明書の有効性確認の方式
- 電子証明書の種類署名用電子証明書
- 利用者証明用電子証明書
- 公的個人認証サービスの機能拡充最新の利用者情報（4情報）提供サービスマイナポータルを活用した「基本4情報提供サービス」において必要となる「本人同意の取得支援サービス」
- マイナンバーカードの機能（電子証明書）のスマートフォンへの搭載
- 問合せよくある問合せ（FAQ）
- 問合せ先マイナンバーカード全般について
- 公的個人認証サービスの導入について
- 公的個人認証サービスにおける主務大臣認定について
- その他のサービスについて
- プラットフォーム事業者の提供サービス等に関する問合せ先
- 関連文書公的個人認証サービス利用のための民間事業者向けガイドライン
- 署名検証者等失効情報提供手続フロー（民間事業者）

## 1. 公的個人認証サービスとは

公的個人認証サービスとは、マイナンバーカードのICチップに搭載された電子証明書を利用（マイナンバーは利用しません）して、オンラインで利用者本人の認証や契約書等の文書が改ざんされていないことの確認を公的に行うための安全・確実な本人確認を行うためのサービスです。公的個人認証サービスは、行政機関だけでなく、民間事業者の各種サービスにも導入してご利用いただけます。

- [公的個人認証制度の概要について（PDF／501KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e3ef3a2e/20241119_news_mynumber_outline_01.pdf)

公的個人認証サービスを利用することで、顧客サービス向上や事務コスト削減等の効果が期待されます。たとえば、顧客が本人確認書類や申込書を記入、郵送するコストや時間を削減できます。また、民間事業者が書類の受付や審査に要する作業負担を軽減できます。

公的個人認証サービスを利用している民間事業者は1,307社（2026年8月17日時点）あります。銀行・証券口座開設やローン契約等、様々な場面で利用されています。

この仕組みは、「公的個人認証法※2」に基づき、国と地方公共団体が共同で管理する法人である地方公共団体情報システム機構（以下「J-LIS」と記す）により運営されており、最も高いレベルのセキュリティや信頼性を備えています。

民間事業者が公的個人認証サービスを導入する場合は、公的個人認証法に基づき主務大臣認定を受けて自社が認定事業者になるか、もしくは認定事業者に署名検証業務を委託する形で利用する2つの方法があります。認定事業者になるには、署名検証業務において情報管理を行うための設備・体制が必要となります。なお、設備はクラウド利用も可能です。一方で、認定事業者に署名検証業務を委託することにより、署名検証設備を各事業者が整備しなくとも、公的個人認証サービスを導入することが可能となります。

公的個人認証サービスを含む、マイナンバーカードの普及や利用拡大に向けた取組※3は政府全体で強力に推進されており、マイナンバーカードは国民にとってますます便利で使いやすいものになってきています。現在、マイナンバーカードの有効申請件数※4は、2023年1月時点で運転免許証の発行枚数を超え、人口の3分の2（約8,300万件）に達しています。

※2 電子署名等に係る地方公共団体情報システム機構の認証業務に関する法律

※3 主な取組のロードマップは以下をご参照ください。[デジタル社会の実現に向けた重点計画　工程表（PDF／2,015KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/5ecac8cc-50f1-4168-b989-2bcaabffe870/019e531c/20220607_policies_priority_outline_07.pdf)
マイナンバーカードに関する箇所
P7：（4）マイナンバーカードの普及及び利用の推進
P24からP25まで：マイナンバーカードを活用した各種カード等のデジタル化等に向けた工程表

※4 マイナンバーカードの発行申請のうち、書類に不備のあった場合と申請を取りやめた場合を取り除いた件数。最新の有効申請件数は[マイナンバーカードの普及に関するダッシュボード](https://www.digital.go.jp/resources/govdashboard/mynumber_penetration_rate)をご参照ください。

## 2. サービスの特徴

申込書等への住所、氏名等の記入レスや郵送等の手間削減といった「顧客サービス向上」、記入レスによる不備の削減といった「事務コスト削減」並びに「セキュリティ強化」などが実現できます。

### 2.1. 顧客サービス向上

本人確認書類や申込書の準備や記入、郵送など、顧客が負担しているコストを削減できます。たとえば、銀行口座開設時の本人確認の場合、本人確認書類及び申込書の提出が必要ですが、公的個人認証サービスを利用すれば、オンラインでの本人確認及び申込が可能となります。これにより、書類の準備や記入、郵送等に要するコストを削減できます。また、署名用電子証明書に記録される4情報（住所、氏名、生年月日、性別）から情報を転記することで、顧客の入力に係る負担やミスを軽減できます。さらに、オンラインで本人確認が完結するので、時間や場所の制約がないサービスを提供できるようになります。

### 2.2. 事務コスト削減

本人確認書類及び申込書等の受付や審査、顧客への通知業務に関する郵送など、民間事業者が負担している事務コストを削減できます。たとえば、銀行口座開設時の本人確認の場合、従来本人確認書類及び申込書の受付や審査、記入不備の際の書類再送付依頼等が発生していました。公的個人認証サービスを利用すれば、オンラインでの本人確認及び申込が可能となり、それらの作業負担を軽減できます。

### 2.3. セキュリティ強化

公的個人認証サービスでは、「公開鍵暗号方式」と呼ばれる暗号技術を使用することで、通信の安全性を確保しています。「公開鍵暗号方式」は、暗号化と復号で異なる2つの鍵（秘密鍵・公開鍵）を使用する方式です。片方の鍵で暗号化したものは、それと対になるもう一方の鍵でなければ復号できないことが特徴です。また、マイナンバーカードのICチップには秘密鍵を記録しております。マイナンバーカードはICチップ内の記録情報が不正に読みだされようとした場合には、自動的に消去される等の対抗措置が講じられるため、秘密鍵が詐取される心配はありません。

「公開鍵暗号方式」の詳細は以下をご参照ください。

- [公開鍵暗号方式（PDF／512KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/7c53ec45/20230310_private-businessjpki-introduction_outline_01.pdf)

## 3. サービス導入の方法

本章では、公的個人認証サービスの導入に興味をお持ちの民間事業者向けに、サービス導入の方法を紹介します。

### 3.1. サービス導入方式

公的個人認証サービスの利用にあたり、サービス導入事業者は、顧客から提供される電子証明書の有効性を確認する必要があります。有効性確認を自ら実施する「プラットフォーム事業者」になる場合と、プラットフォーム事業者に有効性確認を委託する「サービスプロバイダ事業者」になる場合の2つのサービス導入方式があります。

#### 3.1.1. サービスプロバイダ事業者になる方式

公的個人認証サービスの利用にあたり、自社で署名検証設備を整備せず、電子証明書の有効性確認をPF事業者に委託することでサービス提供する事業者をサービスプロバイダ事業者（以下「SP事業者」と記す）と呼びます。電子証明書の有効性確認を委託するため、設備の整備や運用等に係る費用負担の軽減、サービス導入までの期間短縮ができ、安価かつ迅速に導入できます。SP事業者の場合の電子証明書の有効性確認の流れは図1のとおりです。一般に、署名検証に係るサービス利用にあたっては、PF事業者が定めるサービス利用料が発生します。利用料はPF事業者によって異なります。SP事業者になるための手続き、サービス利用料については、「7.2.5.　プラットフォーム事業者の提供サービス等に関する問合せ先」に問い合わせください。

図1 電子証明書の有効性確認の流れ（SP事業者）

#### 3.1.2. プラットフォーム事業者になる方式

公的個人認証サービスの利用にあたり、自ら電子証明書の有効性をJ-LISに確認する民間事業者は、署名検証設備を整備し、公的個人認証法に基づき主務大臣の認定を受けて「プラットフォーム事業者（以下「PF事業者」と記す）」になる必要があります。

PF事業者は、電子証明書の有効性確認の機能をプラットフォームとして他の民間事業者に提供することが可能です。なお、整備すべき署名検証設備はクラウド型での導入も可能です。これにより、設備の整備や運用等に係る費用負担の軽減、サービス導入までの期間短縮が期待できます。

- [民間事業者における公的個人認証サービスの活用（プラットフォーム事業者制度）（PDF／345KB）](https://www.digital.go.jp/assets/contents/node/information/field_ref_resources/348cf54f-0c15-4b98-bb43-3171f7c092f7/0568b799/20241119_news_mynumber_outline_03.pdf)

サービス利用にあたっては、J-LISに対する電子証明書検証手数料が発生します。手数料は確認件数に応じた従量課金制であり、署名用電子証明書の場合20円/1件、利用者証明用電子証明書の場合2円/1件とされています。なお、2023年1月からは、これら手数料は当面無料となります。PF事業者になるための手続きは「3.2　プラットフォーム事業者になるための手続き」をご参照ください。

### 3.2. プラットフォーム事業者になるための手続き

PF事業者としてサービス導入する場合、まずはJ-LISから技術仕様等を入手のうえ、主務大臣認定手続きを進める必要があります。認定取得後には、署名検証等のためのシステム環境を整備する必要があります。

なお、技術仕様等の入手から主務大臣認定取得までには6か月から1年程度を要します。手続きの全体像は、以下総務省、デジタル庁が公表するガイドラインをご参照ください。

手続きの全体像に関する箇所は「39ページから41ページ：ウ認定手続」に掲載しています。

- 公的個人認証サービス利用のための民間事業者向けガイドライン（第1.8版）

#### 3.2.1. 技術仕様等の入手

J-LISと守秘義務に関する誓約を取り交わしたうえで、公的個人認証サービスに係る技術仕様等の開示を申請します。主務大臣認定手続きやシステム環境整備に必要な書類ではありますが、サービスの導入の検討にも必要な書類となっていますので、検討段階よりお役立てください。

#### 3.2.2. 主務大臣認定手続き

J-LISから提供された技術仕様を踏まえ、認定基準に示されている要求事項への対応を行い、要求事項を満たすことを証明する書類を作成します。その書類をもってデジタル庁及び総務省に対して認定審査を申請します。申請に関するお問い合わせは、「7.2.3. 公的個人認証サービスにおける主務大臣認定について」をご参照ください。

#### 3.2.3. 本番利用開始準備

認定取得後、公的個人認証サービスの試験環境で動作確認を行います。問題がなければ、公的個人認証法の規定に基づき、J-LISから電子証明書の有効性確認結果の提供を受けるための届出等を行います。最後に、本番環境で動作確認をし、サービス利用開始となります。

### 3.3. 公的個人認証サービス利用料

公的個人認証サービスの利用においては、一般的な国の許認可事業とは異なり、主務大臣認定の取得や維持等に係る費用は発生しません。J-LISに対する電子証明書検証手数料のみが必要となります。

公的個人認証サービス利用料は、有効性確認の件数に応じた従量課金制であり、署名用電子証明書の場合20円/1件、利用者証明用電子証明書の場合2円/1件とされています。

なお、これら利用料は2023年1月より当面無料となります※8。PF事業者のサービス利用コストを引き下げ、サービス導入を後押しすることが狙いです。詳細は、以下をご参照ください。

- [公的個人認証サービスの電子証明書失効情報の提供に係る手数料の当面3年間無料化等](https://www.digital.go.jp/news/ea776a15-ba19-44af-8d1e-02bd8a94cda2/)

※8 CRL方式は恒久無料化、OCSPレスポンダ方式は当面3年間無料化

## 4. サービス導入事例

本章では、現在公的個人認証サービスを導入している民間事業者における導入事例を紹介します。どういった業界やサービスにどのように導入されているのか、民間事業者や顧客にとってどのようなメリットがあるのか等の参考となる情報を掲載していますので、ぜひとも導入の検討にお役立てください。たとえば、銀行・証券業界においては、口座開設において公的個人認証サービスが多く利用されており、その導入効果が認められています。口座開設時に必要であった本人確認書類のコピーや申込書の記入・郵送などが不要となり、マイナンバーカードの電子証明書を利用することで、スマートフォンなどから簡単・正確に申込することができます。これにより、受付や審査などの事務コスト削減や、顧客利便性の向上につながります。

- [マイナンバーカードを用いた公的個人認証サービス（JPKI）導入事業者及び事例一覧](https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction/mynumbercard-user-list)

## 5. 認証の仕組み

公的個人認証サービスには、マイナンバーカードのICチップに搭載された電子証明書を利用します。電子証明書の発行者であるJ-LISがトラストアンカー（信頼性の基点）となり、その有効性を証明します。

### 5.1. 電子証明書の有効性とは

電子証明書は条件次第でその効力を失うため、民間事業者は、顧客から提出された電子証明書の有効性を確認する必要があります。

#### 5.1.1. 電子証明書の失効条件

電子証明書の失効条件としては、電子証明書の有効期間の満了、住民票の基本4情報（住所、氏名、生年月日、性別）の変更、本人死亡等があげられます。電子証明書には「署名用電子証明書」と「利用者証明用電子証明書」の2種類があり、それぞれで失効条件は異なります。「署名用電子証明書」、「利用者証明用電子証明書」の詳細は「5.2　電子証明書の種類」をご参照ください。電子証明書の失効条件の詳細は以下をご参照ください。

- [電子証明書が失効する場合とその対応（PDF／107KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/6e4fa365/20221219_private-businessjpki-introduction_outline_01.pdf)

#### 5.1.2. 電子証明書の有効性確認の方式

電子証明書の有効性確認の方式は、「CRL提供方式」と「OCSPレスポンダ方式」の2種類があります。

（1）CRL提供方式CRL※5とは、電子証明書の失効情報の一覧です。

CRL提供方式とは、電子証明書の失効情報の一覧を、定期的（1日1回等）に提供する方式です。

J-LISから提供されるCRLは、1日単位で更新されています。民間事業者は、それをローカル環境にダウンロードし、サービス利用者の電子証明書の発行番号と照合することで、電子証明書の有効性を確認します。

CRL提供方式はオフラインでも確認できることが特徴です。

※5 Certification Revocation List

図2 CRL提供方式

（2）OCSPレスポンダ方式OCSP※6とは、電子証明書の有効性を確認するための通信プロトコルです。

OCSPレスポンダ方式とは、特定の電子証明書の有効性の照会について、「OCSPレスポンダ」と呼ばれる応答用サーバから個別に回答する方式です。

OCSPレスポンダには、失効情報が保存されており、15分単位で更新されています。OCSPレスポンダは、失効情報とサービス利用者の電子証明書の発行番号を照合し、有効性確認結果を提供します。

OCSPレスポンダ方式はリアルタイムに確認できることが特徴です。一方で、オフラインでは電子証明書の有効性を確認できないことに留意が必要です。

※6 Online Certification Status Protocol

図3 OCSPレスポンダ方式

### 5.2. 電子証明書の種類

電子証明書には「署名用電子証明書」と「利用者証明用電子証明書」の2種類があります。

#### 5.2.1. 署名用電子証明書

インターネット等で申込や契約等の電子文書を作成・送信する際に利用されており、その利用者が作成・送信した電子文書が「利用者が作成した真正なものであり、利用者が送信したものであること」を確かめることができます。署名用電子証明書を使った電子署名は、電子署名及び認証業務に関する法律第3条（電子的記録の真正な成立の推定）※7の対象となり得るものです。すなわち、本人による一定の要件を満たす電子署名が行われた電子文書は、真正に成立したもの（本人の意思に基づき作成されたもの）と推定されます。

※7 電子署名及び認証業務に関する法律第3条　引用電磁的記録であって情報を表すために作成されたもの（公務員が職務上作成したものを除く。）は、当該電磁的記録に記録された情報について本人による電子署名（これを行うために必要な符号及び物件を適正に管理することにより、本人だけが行うことができることとなるものに限る。）が行われているときは、真正に成立したものと推定する。

#### 5.2.2 利用者証明用電子証明書

主に、インターネットサイト等にログインする際に利用されており、ログインした者が、利用者本人であることを確かめることができます。

なお、署名用電子証明書と利用者証明用電子証明書では、その用途が異なるため、保持する情報に差異があります。主な差異は、電子証明書内に基本4情報（住所、氏名、性別、生年月日）を保持するか否かです。申込時等に電子署名用途で利用される署名用電子証明書には、申込者等の正確な住所等の確認が必要なため、電子証明書内に基本4情報が保持されています。インターネットサイト等のログインに利用される利用者証明用電子証明書は、本人であることが確認できれば良いため、基本4情報が保持されていません。

「5.2　電子証明書の種類」の詳細は以下をご参照ください。

- [電子証明書の種類（PDF／501KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e376536f/20221219_private-businessjpki-introduction_outline_02.pdf)

## 6. 公的個人認証サービスの機能拡充

### 6.1. 最新の利用者情報（4情報）提供サービス（2023年5月16日開始）

本サービスの概要公的個人認証サービスを用いて事前に本人から同意を受けている前提で、顧客の最新の4情報（住所、氏名、生年月日および性別）をJ-LIS（地方公共団体情報システム機構）にいつでもオンラインで照会できるようになるサービスです。これにより、例えば金融機関等では、顧客の住所等変更をすぐに確認できるようになります。

本サービスは2023年5月16日に開始しました。概要は以下に掲載しています。

- [公的個人認証サービスを利用した最新の利用者情報（4情報）提供サービス（PDF／107KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/3f10dd8b-8c2a-4585-9cdc-674ad2112731/dad77a76/20230516_policies_mynumber_private-business_outline_02.pdf)

本サービスの詳細な内容については以下の「5 本人同意に基づく最新の利用者情報（基本4情報）提供サービスの概要（43ページから49ページ）」に掲載しています。

- 公的個人認証サービス利用のための民間事業者向けガイドライン（第1.8版）

民間事業者が本サービスを提供する際は、顧客の同意が必要とされています。当該同意は、顧客にとってわかりやすいことが求められ、また、確実に取得されることが必要です。同意の取得にあたり、以下の資料に留意事項を記載していますため、ご確認ください。

- [公的個人認証法に基づく最新の利用者情報（基本4情報）提供サービスに係る同意の取得について（PDF／363KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/7b496226/20260413_private-businessjpki-introduction_outline_01.pdf)（2026年4月13日更新）

本サービス利用のための手続き本サービスは公的個人認証サービスの付加サービスになりますので、民間事業者においては、まずは公的個人認証サービス利用のための手続きが必要になります。

公的個人認証サービスのための手続きをした上で、本サービスの利用手続きを実施してください。

公的個人認証サービスの詳細は [公的個人認証サービスによる電子証明書（民間事業者向け）（総務省）](https://www.soumu.go.jp/kojinbango_card/kojinninshou-02.html)をご参照ください。

本サービスの利用にあたり必要な手続きは以下のとおりです。

- サービスプロバイダ事業者（プラットフォーム事業者に署名検証業務を委託の上公的個人認証サービスを利用している事業者）サービスプロバイダ事業者は、署名検証業務を委託しているプラットフォーム事業者より、システム対応に必要な情報の提供を受けることができます。本サービスに対応しているプラットフォーム事業者は以下のとおりです。
- [最新の利用者情報（4情報）提供サービスに対応しているプラットフォーム事業者一覧（PDF／699KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/ae271062/20260623_policies_mynumber_private-business_outline_01.pdf)（2026年6月10日時点）
- プラットフォーム事業者（自ら主務大臣認定を受けて公的個人認証サービスを利用している事業者）J-LISに対し本サービスの利用の申込みが必要です。以下の問合せ先にご連絡ください。問合せ先：[地方公共団体情報システム機構](https://www.j-lis.go.jp/j-lis_corner/contact/form.xhtml)その上で、J-LISとの間で守秘義務に関する誓約を取り交わしの上で、技術仕様等の開示を申請する必要があります。

#### 6.1.1．マイナポータルを活用した、「基本4情報提供サービス」において必要となる「本人同意の取得支援サービス」を2024年10月29日に開始しました。

民間事業者は本サービスを利用することで、「最新の利用者情報（4情報）提供サービス」を利用するために必要となる顧客からの同意を取得できます。新規顧客の場合には、申込の際に顧客からの同意を容易に取得できますが、既存顧客に対しても円滑に本人同意を取得するための方法として、「本人同意の取得支援サービス」を開始しました。詳細は以下からご確認ください。

- [マイナポータルを活用した「本人同意の取得支援サービス」（PDF／274KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/a92c7db2/20241101_policies_mynumber_private-business_outline_01.pdf)

##### 本サービスを利用するメリット

- 事業者におけるメリット既存顧客の同意取得が容易となる。
- 同意取得にかかるシステム開発コストが低減される。
- 同意取得後は、住所等の基本4情報の変更手続にかかる事務コストが低減される。
- 顧客の変更書類の誤入力等を防ぎ、顧客情報を常に最新化できる。
- 国民におけるメリットマイナポータルを使うことで容易に手続きできる。
- 引越し等で住所等に変更がある場合、必要となる手続が不要となる。

##### 顧客へのご案内メール等の例示

同意手続にかかる、ご案内等は以下をご参照ください。なお、メールサンプルのテキストデータは仕様書開示時に配布予定です。

- [顧客へのご案内メールのサンプル（PDF／855KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/fd5117d8/20240906_policies_mynumber_private-business_outline_02.pdf)

##### お問合せ先

本サービスのお問合せは以下にご連絡ください。Forms：[【デジタル庁】マイナンバーカード（公的個人認証サービス）の利用に関する問い合わせフォーム](https://forms.office.com/pages/responsepage.aspx?id=_6DkBnJJi0qvMEVxNh0TRNJv3cv0c0FBhtslb22zQ4BUOTZQWFpGVFBISlVCVlpHRUZFOUVTVDdFVy4u&route=shorturl)※フォーム内の「5.問い合わせ内容を選択ください。」の設問にて「基本4情報提供サービス」を選択ください。

### 6.2. マイナンバーカードの機能（電子証明書）のスマートフォンへの搭載（2023年5月11日開始）

マイナンバーカードの電子証明書の機能をスマートフォンに搭載することによって、マイナンバーカードを持ち歩くことなく、スマートフォンひとつで、いつでもどこでも様々なマイナンバーカード関連サービスの申込や利用ができるようになりました。

詳細を以下に掲載しています。本サービスの利用検討にあたりご参照ください。今後も順次情報を拡充していきます。

- [スマホ用電子証明書搭載サービス](https://www.digital.go.jp/policies/mynumber/smartphone-certification/)
- [マイナンバーカードの機能のスマートフォン搭載に関する検討会](https://www.digital.go.jp/councils/smartphone-mynumbercard/)

## 7. 問合せ

### 7.1. よくある問合せ（FAQ）

よくある問合せ（FAQ）は以下のページをご参照ください。

- [よくある質問（FAQ）：民間事業者向けマイナンバーカード利活用](https://www.digital.go.jp/policies/mynumber/private-business/faq)

### 7.2. 問合せ先

#### 7.2.1. マイナンバーカード全般について

マイナンバーカード全般のお問合せについては[マイナンバー制度に関するお問合せ](https://www.digital.go.jp/policies/mynumber_contact)をご確認ください。

#### 7.2.2. 公的個人認証サービスの導入について

公的個人認証サービスの導入ついては、[【デジタル庁】マイナンバーカード（公的個人認証サービス）の利用に関する問い合わせフォーム](https://forms.office.com/pages/responsepage.aspx?id=_6DkBnJJi0qvMEVxNh0TRNJv3cv0c0FBhtslb22zQ4BUOTZQWFpGVFBISlVCVlpHRUZFOUVTVDdFVy4u&route=shorturl)よりお問い合わせください。なお、団体向け説明会の開催希望や相談がある方のお問い合わせも受け付けています。説明会では、多くの民間事業者に公的個人認証サービスを利用いただけるように団体向け説明会を開催しており、マイナンバーカードや公的個人認証サービスの概要、利用事例、最新動向、マイナポータルの概要等、公的個人認証サービスの導入検討に役立つ情報を紹介しています。

#### 7.2.3. 公的個人認証サービスにおける主務大臣認定について

以下の送付先へメールにてお問い合わせください。メールをお送りになる際には、送付先に記載されているデジタル庁及び総務省の2つのメールアドレス宛に、送付内容に記載されている事項をご記載のうえ、送信してください。

- 送付先迷惑メール防止のため、「@」を「_atmark_」と表示しています。メールをお送りになる際には「_atmark_」を「@」（半角）に直してください。メールアドレス（デジタル庁）：jpki-daijinnintei_atmark_digital.go.jp
- メールアドレス（総務省）：kouteki-kojin_atmark_soumu.go.jp
- 送付内容メール件名「PF事業者制度等に関する問合せ（事業者／団体名）」を記載
- メール本文事業者／団体名、部署名、担当者様の氏名、連絡先（メールアドレス＆電話番号）

#### 7.2.4. その他のサービスについて

その他のサービスについては、各サービスサイトをご確認ください。

- [デジタル認証サービスの利用](https://support.aas.digital.go.jp/hc/ja/requests/new?ticket_form_id=33975504314777)
- [マイナポータルAPIの利用](https://faq.myna.go.jp/helpdesk?category_id=125&site_domain=api)
- [マイナンバーカード対面確認アプリの利用](https://forms.office.com/pages/responsepage.aspx?id=_6DkBnJJi0qvMEVxNh0TRDnrgI74HABFlH3Laa63rxhUQ1JUTUhCMVBWTkw2TElZS0RGTUFRVVQ3UyQlQCN0PWcu&route=shorturl)

#### 7.2.5. プラットフォーム事業者の提供サービス等に関する問合せ先

PF事業者が顧客向け、またはSP事業者向けに提供しているサービスについて、更に詳しい情報を知りたい方は、以下のPF事業者にお問い合わせください。

メールをお送りになる際には、「_atmark_」を「@」（半角）に直してください。迷惑メール防止のため、「@」を「_atmark_」と表示しています。

- 一般社団法人ICTまちづくり共通プラットフォーム推進機構担当部署：技術部門
- 問合せ先：ogura_atmark_topic.or.jp
- サービス紹介資料：[myTAP（PDF／1,936KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e15f461e/20241217_policies_mynumber_mynumbercard-user-list_outline_01.pdf)
- 株式会社NTTデータ担当部署：社会基盤ソリューション事業本部 デジタルコミュニティ事業部
- 問合せ先：bizpico-service_atmark_kits.nttdata.co.jp
- サービス紹介資料：[BizPICO（PDF／1,498KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/d046094e-9570-49fa-8158-b912b86593c7/918e9d64/20221101_policies_mynumber_mynumbercard-user-list_outline_01.pdf)
- GMOグローバルサイン株式会社担当部署：GMOオンライン本人確認サービス問い合わせ窓口
- 問合せ先：[お問い合わせフォーム（GlobalSing by GMO）](https://jp.globalsign.com/contact/customer/)
- サービス紹介資料：[マイナンバー制度対応GMOオンライン本人確認サービス（PDF／770KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/d046094e-9570-49fa-8158-b912b86593c7/feb3ba1c/20221101_policies_mynumber_mynumbercard-user-list_outline_02.pdf)
- 日本電気株式会社担当部署：社会公共インテグレーション統括部 新事業創出グループ
- 問合せ先：ss_atmark_mcas.jp.nec.com
- サービス紹介資料：[マイナンバーカード認証サービス（PDF／1,795KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/24845ef6/20241217_policies_mynumber_mynumbercard-user-list_outline_02.pdf)
- 株式会社サイバーリンクス担当部署：公共クラウド事業部 公共営業部 企画営業課
- 問合せ先：kikaku-eigyou_atmark_cyber-l.co.jp
- サービス紹介資料：[マイナサイン（PDF／1,034KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/fe6659db/20241217_policies_mynumber_mynumbercard-user-list_outline_03.pdf)
- サイバートラスト株式会社担当部署：トラストサービスマネジメント部
- 問合せ先：ctj_reception_atmark_cybertrust.co.jp
- サービス紹介資料：[iTrust 本人確認サービス（PDF／2,594KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/d046094e-9570-49fa-8158-b912b86593c7/87cd07fe/20221007_policies_mynumber_mynumbercard-user-list_outline_04.pdf)
- TOPPAN株式会社担当部署：ハイブリッドBPO統括本部
- 問合せ先：[TOPPAN ウェブサイト](https://solution.toppan.co.jp/toppan-edge/service/honninkakunin.html)
- 株式会社野村総合研究所担当部署：ソーシャルDX事業部
- 問合せ先：nri-shomn-jigyo_atmark_nri.co.jp
- 株式会社Workthy担当部署：金融事業チーム
- 問合せ先：t.eguchi_atmark_workthy.jp
- サービス紹介資料：[ふるさと納税「ワンストップ特例申請」のオンライン化（PDF／714KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/f348c809/20260728_policies_mynumber_mynumbercard-user-list_outline_05.pdf)
- TISI株式会社担当部署：金融第1事業本部 金融ビジネス推進・営業統括部 金融ビジネス企画営業部 マイナンバーカード本人確認サービス担当窓口
- 問合せ先：info-fs_atmark_ml.tisi.jp
- サービス紹介資料：[TISI株式会社「マイナンバーカード本人確認サービス」（PDF／2,262KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/8dc4190e-109e-4b13-96a0-0dc42f09dbfa/e659a99e/20260903_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf)
- 株式会社ダブルスタンダード担当部署：データマネジメントグループ／データマネジメント部
- 問合せ先：[お問い合わせ（ダブルスタンダード）](https://double-std.com/service/jpki-ekyc/#sec_page_form)
- サービス紹介資料：[公的個人認証を利用したeKYCソリューション（PDF／788KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/17bd4282/20241217_policies_mynumber_mynumbercard-user-list_outline_04.pdf)
- 株式会社フライトソリューションズ担当部署：プロダクト＆フィナンシャルサービス事業部
- 問合せ先：myverifist_atmark_flight.co.jp
- サービス紹介資料：[myVerifist&キャッシュレスサービス（PDF／1,082KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/beaa4c40/20241217_policies_mynumber_mynumbercard-user-list_outline_05.pdf)
- ポケットサイン株式会社問合せ先：[ポケットサイン ウェブサイト](https://pocketsign.co.jp/service/pocketsignplatform)
- サービス紹介資料：[POCKETSIGN Platform（PDF／1,229KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/b63b21ef/20260601_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf)（2026年6月1日更新）
- 弁護士ドットコム株式会社担当部署：クラウドサイン事業本部
- 問合せ先：contact_atmark_cloudsign.jp
- サービス紹介資料：[クラウドサイン（PDF／766KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/45db0a72/20250109_policies_mynumber_mynumbercard-user-list_outline_01.pdf)
- 株式会社ミラボ担当部署：営業部
- 問合せ先：info_atmark_mi-labo.co.jp
- サービス紹介資料：[mila-e認証（PDF／1,451KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/530b8043/20250404_policies_mynumber_mynumbercard-user-list_outline_01.pdf)
- NTTドコモビジネス株式会社担当部署：ビジネスソリューション本部 ソーシャルイノベーション部
- 問合せ先：auth-and-sign-lita_atmark_ntt.com
- サービス紹介資料：[SmartLiTA（PDF／1,919KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/b5b5edab/20250815_policies_mynumber_mynumbercard-user-list_outline_02.pdf)
- 株式会社ACSiON担当部署：営業部
- 問合せ先：marketing_atmark_acsion.co.jp
- サービス紹介資料：[ACSiON公的個人認証サービス（PDF／1,630KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/3f9be206/20241217_policies_mynumber_mynumbercard-user-list_outline_09.pdf)
- マーソ株式会社担当部署：IT本部システム開発部
- 問合せ先：[CONTACT（MRSO）](https://www.mrso.jp/corp_inquiry/contact/)
- クラウドシップ株式会社問合せ先：tsuyoshi.hanai_atmark_growship.com
- サービス紹介資料：[CrowdShipTrust（PDF／2,710KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/16122fae/20241217_policies_mynumber_mynumbercard-user-list_outline_10.pdf)
- 株式会社TRUSTDOCK問合せ先：[株式会社TRUSTDOCK](https://lp.trustdock.io/product/JPKI)
- サービス紹介資料：[TRUSTDOCK公的個人認証サービス（PDF／583KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e145303e/20250930_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf)
- マイナウォレット株式会社担当部署：開発部
- 問合せ先：info_atmark_mynawallet.co.jp
- サービス紹介資料：[マイナウォレット（PDF／862KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e8cac00c/20251029_policies_mynumber_private-business__faq_platformer-list_outline_01.pdf)
- 株式会社JMDC担当部署：インシュアランス本部
- 問合せ先：recoell-support_atmark_jmdc.co.jp
- サービス紹介資料：[JMDCのデジタル認証アプリを活用した公的個人認証サービス（PDF／417KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/8dc4190e-109e-4b13-96a0-0dc42f09dbfa/d20a4b9d/20251127_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf)
- 株式会社プリマジェスト担当部署：新規事業推進部
- 問合せ先：[Primagest Trust Services ウェブサイト](https://www.primagest.net/)
- サービス紹介資料：[Primagest Trust Services（PDF／3,331KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/2e3cf4c8/20260512_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf)（2026年5月12日更新）
- 株式会社Liquid担当部署：カスタマーサクセス部 eKYC担当
- 問合せ先：info_atmark_liquidinc.asia
- サービス紹介資料：[LIQUID eKYCのご案内（PDF／2,152KB）](https://www.digital.go.jp/assets/contents/node/information/field_ref_resources/1390fa20-61f8-405f-8477-1f7a0f67cce1/5c819ff6/20260413_policies_mynumber_private-business_faq_platformer-list_outline_01.pdf)（2026年4月13日更新）
- アイフル株式会社担当部署：デジタル推進1部
- 問合せ先：asein_operation_atmark_aiful.co.jp

以上は、PF事業者のうち、問合せ先の掲載承諾を得られた事業者のみ掲載しています。また、PF事業者の中にはSP事業者向けに電子証明書の有効性確認の機能をプラットフォームとして提供していない事業者もいます。

## 8. 関連文書

### 8.1. 公的個人認証サービス利用のための民間事業者向けガイドライン

民間事業者における公的個人認証サービスの利用検討の支援や導入手続きの解説を目的に、総務省が公表するガイドラインです。サービスの概要やメリット、サービス利用の手引き（民間事業者側に必要となる情報システム設備、主務大臣認定基準・手続き、電子証明書検証手数料）等をまとめて掲載しています。

サービスの導入の検討にあたり、詳細かつ網羅的な情報が欲しい方は本書をご参照ください。

- [公的個人認証サービス利用のための民間事業者向けガイドライン（第1.8版）（PDF／5,163KB）](https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/e550d3de/20260413_policies_mynumber_private-business_outline_01.pdf)

なお、本書を掲載している総務省のウェブサイトは以下です。併せてご参照ください。

- [公的個人認証サービスによる電子証明書（民間事業者向け）（総務省）](https://www.soumu.go.jp/kojinbango_card/kojinninshou-02.html)

### 8.2. 署名検証者等失効情報提供手続フロー（民間事業者）

民間事業者がPF事業者として公的個人認証サービスを導入する際の署名検証に関する手続きや業務フロー、手続きに必要な書類等をJ-LISが紹介しています。

J-LISとの間で必要な手続きを確認する場合は、以下の資料をご参照ください。

- [署名検証者等失効情報提供手続きフロー（民間事業者）（令和4年10月17日J-LIS）](https://www.j-lis.go.jp/file/20221027minkan.pdf)

なお、資料を掲載しているJ-LISのウェブサイトは以下です。併せてご参照ください。

- [電子証明書の有効性確認等を利用したい場合の手続き（民間利用）（J-LIS）](https://www.j-lis.go.jp/jpki/minkan/procedure1_2_2.html)
