---
title: "WAC 2007 の Cluster Creation でクラスター検証エラー"
date: 2020-07-26 00:00:00 -0000
categories: 
 - Azure Stack HCI
#tags: 
# - Azure Stack HCI
---

# Azure Stack HCI 20H2 を WAC から構成する際にクラスター検証でエラーで進めないエラー

## Azure Stack HCI 20H2 について
先週開催された Micosoft Inspire 2020 で、Azure Stack HCI Version 20H2 が発表されました。
+ [ハイブリッド クラウドを可能にする次世代の Azure Stack HCI を発表](https://azure.microsoft.com/ja-jp/blog/deliver-hybrid-cloud-capabilities-with-the-next-generation-of-azure-stack-hci/?fbclid=IwAR17txajhgSvuxmB_Pb9WPh0w21BS7VsrpmVX6Pyzh64njCcud5emy36aVw/?WT.mc_id=WDIT-MVP-5002708)

HCI の機能に特化した新しい HCI 用の OS が Public Preview となりました。

また、同じタイミングで Windows Admin Center は **Version 2007** がリリースされました。
+ [Windows Admin Center version 2007 is now generally available!](https://techcommunity.microsoft.com/t5/windows-admin-center-blog/windows-admin-center-version-2007-is-now-generally-available/ba-p/1536215/?WT.mc_id=WDIT-MVP-5002708)

新しい Azure Stack HCI と Windows Admin Center は下記の評価ガイドのシナリオを参考に効率よく検証することが可能です。

+ [Azure Stack HCI Evaluation Guide](https://github.com/Azure/AzureStackHCI-EvalGuide)

評価ガイドが提供されています。Nested on Physical で構成してみましたが、クラスラー検証でエラーになりました。
同じエラーに遭遇した際に参考いただければと思います。

## クラスター検証のエラーについて
さっそく試してみたのですが、評価ガイド ステップ 4 のクラスター検証でエラーとなり次に進めない事象に遭遇しました。
+ [Step4：Create nested Azure Stack HCI cluster with Windows Admin Center](https://github.com/Azure/AzureStackHCI-EvalGuide/blob/main/nested/steps/4_AzSHCICluster.md)

クラスター検証でエラーがでたというわけではなく、WAC から Azure Stack HCI ノードに対して WMI 通信ができずにクラスター検証を開始できなかったという内容のエラーです。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/20H2/1.png" class="full" width="1000">

私の他にも同じ問題が発生した人がいたようで、Github の Issue にあがっていました。

+ [Validation cluster failed #9
](https://github.com/Azure/AzureStackHCI-EvalGuide/issues/9 )

上記の Issue だけでなく、ワークアラウンドとして Evaluation Guide にもトラブルシューティング方法が追記されましたので、こちらを参考に対応することで無事にクラスター検証のステップを通過することができました。
+ [Troubleshooting cluster validation issues](https://github.com/Azure/AzureStackHCI-EvalGuide/blob/main/nested/steps/4_AzSHCICluster.md#troubleshooting-cluster-validation-issues)

## ワークアラウンド対応内容
私は下記の対応で、クラスター検証を通過することができました。
1. WAC と Azure Stack HCI OS のシステムロケールを en-us に変更する
    + この対応だけでは、クラスター検証はエラーのままでした
2. WAC と Azure Stack HCI OS で、WinRM サービスを再起動し、OS 再起動する。
    + これで問題解決しました！

設定の詳細はこちらです。

### 1. クラスター作成ウィザードを保存して終了する
クラスター検証まで進むには、ネットワークの設定など結構大変なステップが多かったと思います。WAC の画面をそのまま閉じてしまうと、再度初めからやり直しになります。
途中まで進めた状態を保存することで、クラスター検証の画面から作業を再開できます。システムロケール変更や WinRM 再起動を実施する前に、ウィザードの状態を保存しましょう。

1. 途中終了するタイミングで、右下の [Exit] をクリックします。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/20H2/6.png" class="full" width="1000"> 

2. [クラスターの作成を停止しますか？] の表示で、[進捗状況をあとで保存する] にチェックを入れて、[はい] を選択します。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/20H2/7.png" class="full" width="600"> 

クラスター作成のウィザードを開始すると、 

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/20H2/8.png" class="full" width="1000"> 

クラスター作成を再開しますか？という画面が表示されます。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/20H2/9.png" class="full" width="600"> 

[はい] をクリックすることで、クラスター検証から作業を再開することができます。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/20H2/10.png" class="full" width="1000"> 


### 2. WAC と Azure Stack HCI OS のシステムロケールを変更
私は、評価ガイド通り Sandbox 的な構成とはせず、オンプレの Hyper-V に Nested で Azure Stack HCI 用の仮想マシンを準備しました。既存の WAC 用仮想マシン(日本語OS)をそのまま流用したため、念のためシステムロケールをすべて英語に変更しました。

1. システムロケールの設定を確認します。
```powershell
Get-WinSystemLocale
```
2. en-us 以外の場合は設定を変更します。
```powershell
Set-WinSystemLocale -SystemLocale en-us
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/20H2/2.png" class="full" width="1000">

3. 設定を反映させるため再起動したあとに、設定を確認します。
```powershell
Get-WinSystemLocale
```

### 3. WAC と Azure Stack HCI OS のWinRMサービスを再起動
1. WAC と Azure Stack HCI ノードの仮想マシンコンソールを起動し、管理者ユーザーでログインします。
2.  下記コマンドを実行して WinRM サービスを再起動します。
```powershell
Restart-Service WinRM
```
リモートセッションでは実行できないので、それぞれの仮想マシンにログインして実施する必要があります。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/20H2/3.png" class="full" width="1000">

3. OS を再起動します。
```powershell
Restart-Computer -Force
```
4. WAC と Azure Stack HCI ノードすべての再起動が完了したら、再度クラスター検証を実施します。

そうすると、エラーなくクラスターの検証が始まります。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/20H2/4.png" class="full" width="1000">

クラスターの検証が完了すると、検証レポートをダウンロードすることもできます。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/20H2/5.png" class="full" width="1000">

私の環境では、CredSSPの対応をしなくてもクラスター検証のエラーを解消することができました。もし直らなかった場合は、CredSSP の対応も実施してみてください。
Evalation Guide にしたがって、クラスターやS2Dの有効化などを進めてください！


