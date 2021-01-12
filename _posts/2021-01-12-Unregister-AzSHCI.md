---
title: "Azure Stack HCI の Azure 登録解除"
date: 2021-01-12 13:00:00 +08:00
#last_modified_at: 2021-01-02 11:00:00 +08:00
categories: 
 - Azure Stack HCI
---

Azure Stack HCI のライセンスは、1 物理コア に対して US$10 が月額課金されます。登録し続けている限り課金が発生しますので、不要になった Azure Stack HCI は登録を解除し、リソースを削除する必要があります。

Azure Stack HCI の登録解除は Azure CLI か Azure Powershell から実施可能です。今回は Azure Powershell から試してみます。  

# Azure Stack HCI の登録状況確認
Azure Stack HCI の登録状況は Windows Admin Center や Powershell から確認ができます。

WAC から確認する場合は、クラスターマネージャーのダッシュボードから確認できます。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/Register/1.png" class="full" width="600">

また、Powershell で確認する場合は、下記のコマンドを実行します。
```powershell
Get-AzureStackHCI
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/Register/2.png" class="full" width="600">


# Azure Stack HCI の登録解除
## Azure Powershell をインストールします。
+ [Install Azure Powershell for Current User](https://docs.microsoft.com/ja-jp/powershell/azure/install-az-ps?view=azps-5.3.0#install-for-current-user/?WT.mc_id=AZ-MVP-5002708)

```powershell
if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
      'Az modules installed at the same time is not supported.')
} else {
    Install-Module -Name Az -AllowClobber -Scope CurrentUser
}
```

## Az.StackHCI モジュールのインストール
```powershell
Install-Module -Name Az.StackHCI
```

##  Azure に接続
Powershell から Azure に接続します。
```powershell
Connect-AzAccount
```

## 登録解除コマンドの実行
WAC などの管理サーバーからリモートで AZSHCI ノードの登録削除コマンドを実行します。

```powershell
Unregister-AzStackHCI -SubscriptionId 12345678-abcd-1234-abcd-1234567890 -ResourceName azshcicl -ResourceGroupName AZSHCI-RG -ComputerName azshci01
```
コマンドの実行結果が下記の用に表示されれば登録削除が完了です。
|Result|Details|
|-----|-------|
|Success|Azure Stack HCI is successfully unregistered. The Azure resource representing Azure Stack HCI has been deleted. Azure Stack HCI can't sync with Azure until you...|

登録解除されたことを確認します。

```powershell
icm -ComputerName azshci01 -ScriptBlock { get-azurestackhci }
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/Register/3.png" class="full" width="600">

WAC から確認もできます。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/Register/4.png" class="full" width="600">

# まとめ
Azure Stack HCI を Azure に登録することで、Azure 経由でライセンスを支払いでき便利ですが、利用終了後は登録の削除を忘れずに実施して、無駄な課金を発生させないように気を付けたいですね。

