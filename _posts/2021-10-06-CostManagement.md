---
title: "Azure のコストを把握する！"
date: 2021-10-06 22:00:00 +08:00
#last_modified_at: 2021-01-02 11:00:00 +08:00
#categories: 
Tags:
- Azure
#Tags:
# - Cost Management
---

こんにちは。Azure でリソースを利用した際、何のリソースにいくら支払うかを確認する方法をご紹介します。  

## Azure Cost Management
Azure では、*コスト管理と請求* という機能を利用して、Azure ポータルから利用したコストを把握することが可能です。  
+ [Azure Cost Management および Billing のドキュメント](https://docs.microsoft.com/ja-jp/azure/cost-management-billing/)

Azure ポータルから「コスト」で検索すると、「コストの管理と請求」に簡単にアクセスできます。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/CostManagement1/1.png" class="full" width="900">

## コストを確認できる組み込みロール
Azure Cost Management からリソースのコストを確認できるロールの一覧です。

+ [Azure RBAC のスコープ](https://docs.microsoft.com/ja-jp/azure/cost-management-billing/costs/understand-work-scopes#azure-rbac-scopes)

|ロール|説明|
|--|--|
|所有者 |コストを表示し、コストの構成を含めたすべてを管理することができます。|
|共同作成者|コストを表示し、コストの構成を含めたすべてを管理できますが、アクセスの制御はできません。|
|閲覧者|コストのデータと構成を含めたすべてを表示できますが、変更を加えることはできません。|
|コスト管理の共同作成者|コストの表示、コストの構成の管理、および推奨事項の表示を実行できます。|
|コスト管理の閲覧者|コスト データの表示、コストの構成、および推奨事項の表示を実行できます。|

コストの確認のみができるユーザーを準備したい場合は、コストを把握したサブスクリプションのアクセス制御から `コスト管理の閲覧者` の権限をユーザーに付与してあげれば OK です。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/CostManagement1/2.png" class="full" width="900">

## コストを確認できるサブスクリプションの種類
+ [Azure のオンボード オプション](https://docs.microsoft.com/ja-jp/azure/cost-management-billing/costs/cost-mgt-best-practices#azure-onboarding-options)

こちらに記載の通り、Azure を契約するプランは複数あります。
+ Free
+ 従量課金制
+ マイクロソフトエンタープライズ契約
+ CSP

しかし、Azure で利用できる全てのサブスクリプションで Cost Management を利用できるわけではありません。こちらの Docs で紹介されている Azure プランで利用することが可能です。

+ [サポートされている Microsoft Azrue のプラン](https://docs.microsoft.com/ja-jp/azure/cost-management-billing/costs/understand-cost-mgt-data#supported-microsoft-azure-offers)

| **カテゴリ**  | **プラン名** | **クォータ ID** | **プラン番号** | **データ利用可能開始日** |
| --- | --- | --- | --- | --- |
| **Azure Government** | Azure Government Enterprise                                                         | EnterpriseAgreement_2014-09-01 | MS-AZR-USGOV-0017P | 2014 年 5 月<sup>1</sup> |
| **Azure Government** | Azure Government 従量課金制 | PayAsYouGo_2014-09-01 | MS-AZR-USGOV-0003P | 2018 年 10 月 2 日<sup>2</sup> |
| **Enterprise Agreement (EA)** | Enterprise Dev/Test                                                        | MSDNDevTest_2014-09-01 | MS-AZR-0148P | 2014 年 5 月<sup>1</sup> |
| **Enterprise Agreement (EA)** | Microsoft Azure エンタープライズ | EnterpriseAgreement_2014-09-01 | MS-AZR-0017P | 2014 年 5 月<sup>1</sup> |
| **Microsoft 顧客契約** | Microsoft Azure プラン | EnterpriseAgreement_2014-09-01 | 該当なし | 2019 年 3 月<sup>3</sup> |
| **Microsoft 顧客契約** | Dev/Test 用の Microsoft Azure プラン | MSDNDevTest_2014-09-01 | 該当なし | 2019 年 3 月<sup>3</sup> |
| **パートナーによってサポートされる Microsoft 顧客契約** | Microsoft Azure プラン | CSP_2015-05-01、CSP_MG_2017-12-01、および CSPDEVTEST_2018-05-01<br><br>クォータ ID は、Microsoft 顧客契約および従来の CSP サブスクリプションで再利用されます。 現時点では、Microsoft 顧客契約サブスクリプションのみがサポートされています。 | 該当なし | 2019 年 10 月 |
| **Microsoft Developer Network (MSDN)** | MSDN Platforms<sup>4</sup> | MSDN_2014-09-01 | MS-AZR-0062P | 2018 年 10 月 2 日<sup>2</sup> |
| **従量課金制** | 従量課金制                  | PayAsYouGo_2014-09-01 | MS-AZR-0003P | 2018 年 10 月 2 日<sup>2</sup> |
| **従量課金制** | 開発テスト用の従量課金制プラン         | MSDNDevTest_2014-09-01 | MS-AZR-0023P | 2018 年 10 月 2 日<sup>2</sup> |
| **従量課金制** | Microsoft Partner Network      | MPN_2014-09-01 | MS-AZR-0025P | 2018 年 10 月 2 日<sup>2</sup> |
| **従量課金制** | 無料試用版<sup>4</sup>         | FreeTrial_2014-09-01 | MS-AZR-0044P | 2018 年 10 月 2 日<sup>2</sup> |
| **従量課金制** | Azure イン オープン プラン<sup>4</sup>      | AzureInOpen_2014-09-01 | MS-AZR-0111P | 2018 年 10 月 2 日<sup>2</sup> |
| **従量課金制** | Azure Pass<sup>4</sup>                                                            | AzurePass_2014-09-01 | MS-AZR-0120P、MS-AZR-0122P - MS-AZR-0125P、MS-AZR-0128P - MS-AZR-0130P | 2018 年 10 月 2 日<sup>2</sup> |
| **Visual Studio** | Visual Studio Enterprise – MPN<sup>4</sup>     | MPN_2014-09-01 | MS-AZR-0029P | 2018 年 10 月 2 日<sup>2</sup> |
| **Visual Studio** | Visual Studio Professional<sup>4</sup>         | MSDN_2014-09-01 | MS-AZR-0059P | 2018 年 10 月 2 日<sup>2</sup> |
| **Visual Studio** | Visual Studio Test Professional<sup>4</sup>    | MSDNDevTest_2014-09-01 | MS-AZR-0060P | 2018 年 10 月 2 日<sup>2</sup> |
| **Visual Studio** | Visual Studio Enterprise<sup>4</sup>           | MSDN_2014-09-01 | MS-AZR-0063P | 2018 年 10 月 2 日<sup>2</sup> |
| **Visual Studio** | Visual Studio Enterprise:BizSpark<sup>4</sup> | MSDN_2014-09-01 | MS-AZR-0064P | 2018 年 10 月 2 日<sup>2</sup> |

なお、サポートされていないプランもありますのでご注意ください。

## コストの確認
コストを確認できる権限や Azure プランであれば、コスト分析からコストを確認することができます。  
*実際のコスト(濃い緑)* や *予測グラフ(薄い緑)* による今のリソースを使い続けたらいくらかかるのかという表示もあり、何も設定する必要なしにグラフで表示してくれます。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/CostManagement1/3.png" class="full" width="900">

作成したリソースに対していくらかかっているかを確認したい場合は、グラフの表示方法を変更することが可能です。  
+ グループ化 → リソース
+ 細分性 → 表示したいコストの単位
+ 表示形式 → テーブル

このように表示を変更すると、それぞれのリソースにいくらかかっているかを簡単に確認することができます。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/CostManagement1/4.png" class="full" width="900">

このテーブル表示の場合、仮想マシンや Azure Firewall の Outbound の Bandwidth でどれくらい課金されたのかを確認することが可能です。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/CostManagement1/5.png" class="full" width="900">

何にいくらかかっているか詳細な確認がしたいときにぜひ試してみてください。

## 予算の作成
Azure Cost Management では予算を作成することができます。月のコストが予算の何％に達したらアラートメールを送信する設定が可能です。

### 予算アラートの作成方法
コストのアラートから追加と選択します。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/CostManagement1/5.png" class="full" width="900">

次に予算を設定します。予算のリセット期間は、月や年などから柔軟に選択が可能です。今回は月で設定してみます。また、毎月の予算は 1万円に設定します。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/CostManagement1/5.png" class="full" width="900">

最後に、毎月の予算 1万円のうち 何％ を消費したらアラート通知するかを設定します。警告条件は複数作成できますので、予想外の課金が発生した場合などに早めに気づくことができます。メール通知も日本語や英語などに対応しています。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/CostManagement1/5.png" class="full" width="900">

この設定をするだけで予算を消費したタイミングでメール通知を受診することが可能になります。

また、Azure Automation や Logic Apps を利用することでメール以外の通知方法も利用可能ですので、ぜひ試してみてください。
+ [Azure Budgets でのコストの管理](https://docs.microsoft.com/ja-jp/azure/cost-management-billing/manage/cost-management-budget-scenario#create-the-azure-budget)

## まとめ
Azure などのクラウドサービスを利用するときは技術だけでなく、コスト管理も非常に重要かと思いますので、Azure Cost Management を利用して快適に Azure を利用してください！