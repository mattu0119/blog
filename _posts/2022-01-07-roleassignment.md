---
title: "Azure Powershell で RBAC 設定で BadRequest エラー"
date: 2022-01-07 16:00:00 +08:00
#last_modified_at: 2021-11-20 09:45:00 +08:00
categories:
- Azure
---

こんにちは。
Azure Powershell から Azure リソースに RBAC の設定をしようとしたら、Bad Request となり設定できませんでした。  
手順としては、下記の「アクセス権の付与」を実施するとエラーになります。

+ [アクセス権の付与](https://docs.microsoft.com/ja-jp/azure/role-based-access-control/tutorial-role-assignments-user-powershell#grant-access)

ステップ3の、閲覧者権限を割り当てる `New-AzRoleAssignment` コマンドで下記のようにエラーとなります。


```Powershell
PS /home/hiroshi> New-AzRoleAssignment -SignInName tara@mmhiro.com -RoleDefinitionName "Reader" -Scope $subScope
WARNING: We have migrated the API calls for this cmdlet from Azure Active Directory Graph to Microsoft Graph.
Visit https://go.microsoft.com/fwlink/?linkid=2181475 for any permission issues.
New-AzRoleAssignment: Operation returned an invalid status code 'BadRequest'
```

調べてみると、`New-AzRoleAssignment` コマンドは `Az.Resources` モジュールに含まれており、そのモジュールを最新にすることで問題なく RBAC の権限割り当てができるようになりました。  

そのため、Az.Resources モジュールを最新の 5.2.0 にアップデートし、再度同じコマンドを実行してみます。  

念のため、現在インストールされている Az.Resource モジュールのバージョンを確認します。
```Powershell
Get-Module -Name Az.Resources
```

次に、Az.Resources モジュールのアップデートを実施します。`-Force` オプションを付けないとアップデートできないので注意してください。

```Powershell
Install-Module -Name Az.Resources -Repository PSGallery -Scope CurrentUser -Force
```
最新のモジュールのインストールが終わったら、Powershell または Cloud Shell を再起動してください。Cloud Shell は、ターミナル画面の上の電源ボタンを押すと再起動できます。再起動後にバージョンを確認すると 5.2.0 にアップデートされているはずです。

```Powershell
Get-Module -Name Az.Resources

ModuleType Version    PreRelease Name                                ExportedCommands
---------- -------    ---------- ----                                ----------------
Script     5.2.0                 Az.Resources                        {Export-AzResourceGroup, Export-AzTemplateSpec, Get-AzDenyAssignment,…
```

## まとめ
Az.Resources モジュールを最新にアップデートすることで、Azure Powershell から エラーなく RBAC 設定を実施できるようになりますので、試してみてください。




