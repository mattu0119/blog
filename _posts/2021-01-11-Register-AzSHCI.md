---
title: "Azure Stack HCI の Azure 登録"
date: 2021-01-11 13:00:00 +08:00
#last_modified_at: 2021-01-02 11:00:00 +08:00
categories: 
 - Azure Stack HCI
---
+ [Azure Stack HCI を Azure に接続する](https://docs.microsoft.com/ja-jp/azure-stack/hci/deploy/register-with-azure)
Azure Stack HCI のライセンスは、1 物理コア に対して US$10 が月額課金されます。仮想マシンを構築して利用するには、Azure Stack HCI を Azure に登録する必要があります。

また、Azure Stack HCI は Azure オンラインサービス条件にしたがってインストールから 30日以内に登録する必要があります。
登録がアクティブになるまで、クラスターは完全にサポートされません。クラスターを登録後30日以上 Azure に接続しなかった場合は新しい仮想マシンの作成や追加をすることができません。下記のエラーで失敗になります。

`'vmname' の仮想マシン ロールを構成中にエラーが発生しました。ジョブが失敗しました。"Vmname" のクラスター化されたロールを開くときにエラーが発生しました。アクセスされるサービスには、特定の数の接続のライセンスが付与されています。サービスで受け入れることができる数の接続が既に存在するため、現時点ではサービスにこれ以上接続することはできません。`

# Azure 登録の前提条件

1. Azure Stack HCI のクラスターは物理ホスト (UEFI をサポートした仮想マシンは検証用途で利用可能です。)
1. アウトバンド 443 のインターネット通信
1. Azure サブスクリプションとアクセス許可

# Azure 登録用のカスタムロール
クラスターを Azure 登録するには、下記アクセス許可が必要です。
+ リソースプロバイダーの登録
+ Azure リソースとリソースグループの作成、取得、削除

Azure 登録をするには、サブスクリプションの `所有者` か `共同作成者` Azureロールを提供することです。しかし、Azure 登録だけを提供するユーザーを利用したい場合は、Azure Stack HCI を Azure に登録するカスタムロールの作成方法が提供されています。
カスタムロールの作成には AAD Premium P1 か P2 が必要なので注意してください。

```json
{
  "Name": "Azure Stack HCI registration role”,
  "Id": null,
  "IsCustom": true,
  "Description": "Custom Azure role to allow subscription-level access to register Azure Stack HCI",
  "Actions": [
    "Microsoft.Resources/subscriptions/resourceGroups/write",
    "Microsoft.Resources/subscriptions/resourceGroups/read",
    "Microsoft.Resources/subscriptions/resourceGroups/delete",
    "Microsoft.AzureStackHCI/register/action",
    "Microsoft.AzureStackHCI/Unregister/Action",
    "Microsoft.AzureStackHCI/clusters/*"
  ],
  "NotActions": [
  ],
"AssignableScopes": [
    "/subscriptions/<subscriptionId>"
  ]
}
```
このjson ファイルを Azure カスタムロールに登録することで、Azure Stack HCI を登録する権限を持つロールを作成することができます。

```powershell
New-AzRoleDefinition -InputFile <path to customHCIRole.json>
```

# Azure Stack HCI の登録方法

Azure Stack HCI の登録には、GUI と CLI の2種類の登録方法があります。
+ Windows Admin Center 
+ Windows Powershell
+ Azure CLI

# Powershell からの登録
今回は、Powershell からの登録を実施してみます。

## Azure Stack HCI モジュールのインストール
まず、Azure Stack HCI の Powershell モジュールをインストールします。
```powershell
Install-Module -Name Az.StackHCI
```
モジュールがインストールされると、これらのコマンドを実行できるようになります。
```powershell
 Get-Command -Module Az.StackHCI

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Register-AzStackHCI                                0.4.1      Az.StackHCI
Function        Test-AzStackHCIConnection                          0.4.1      Az.StackHCI
Function        Unregister-AzStackHCI                              0.4.1      Az.StackHCI
```

## Register-AzStackHCI の実行
下記のように Register コマンドを実行することで、登録できます。
```powershell
$cred = get-credential mhiro\administrator
Register-AzStackHCI `
-SubscriptionId "123ab4cd-56a1-49bc-9b41-789abcdefgh" `
-ComputerName HCI01 `
–Credential $cred `
-ResourceName HCICL `
-ResourceGroupName AZSHCI-RG `
-Region eastus
```

コマンドを実行すると、登録を実行するユーザーのログインが求められるので、必要な権限を持つユーザーでログインしてください。

登録が完了すると、下記のように表示されます。  

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/Register/register.png" class="full" width="600">

# Azure Stack HCI の登録状況確認
Azure Stack HCI の登録状況は Windows Admin Center や Powershell から確認ができます。

WAC から確認する場合は、クラスターマネージャーのダッシュボードから確認できます。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/Register/register2.png" class="full" width="600">

また、Powershell で確認する場合は、下記のコマンドを実行します。
```powershell
Get-AzureStackHCI
```

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/Register/2.png" class="full" width="600">

# まとめ
Azure 登録が完了すれば、Azure Stack HCI OS のクラスターの機能を利用できるようになります。30日に1回は Azure に接続する必要があるので注意してください。登録後は、Azure ARC などを利用してハイブリッド管理の設定を進めてより便利に管理できるようになると思います。