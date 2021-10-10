---
title: "Azure Stack Hub Development Kit の Azure 登録解除"
date: 2021-01-02 13:00:00 +08:00
#last_modified_at: 2021-01-02 11:00:00 +08:00
categories: 
 - Azure Stack Hub
#tags:
# - Azure Stack Hub Development Kit
---
# はじめに
Azure Stack Hub Development Kit (ASDK) の再インストールについてです。  ASDK は、Azure Stack Hub の POC バージョンで、シングルノードにインストールして利用することができます。POC 用途になるので、バージョンアップなどを実施することができず、新しいバージョンで再インストールする必要があります。  
今回は、Azure に登録した ASDK の情報を削除する方法をご紹介します。

+ [Redeploy the ASDK](https://docs.microsoft.com/en-us/azure-stack/asdk/asdk-redeploy/?WT.mc_id=AZ-MVP-5002708)

# Azure Stack Hub 用 AZ Powershell のインストール
Azure Stack Hub には専用の Powershell が準備されています。Azure Stack Hub の登録や削除に利用しますので、az モジュールをインストールします。  

+ [Install PowerShell Az module for Azure Stack Hub](https://docs.microsoft.com/en-us/azure-stack/operator/powershell-install-az-module)

もし AzureRM Powershell モジュールがインストールされている場合は、AzureRM コマンド用の手順が別にあります。そちらを参照してください。

AZ Powershell をインストールしたい場合は、下記のコマンドよりインストールが可能です。
+ [Option 2: Uninstall the AzureRM PowerShell module from PowerShellGet](https://docs.microsoft.com/en-us/powershell/azure/uninstall-az-ps?view=azps-5.2.0#option-2-uninstall-the-azurerm-powershell-module-from-powershellget)
```powershell
Install-Module -Name Az -AllowClobber -Scope CurrentUser
Uninstall-AzureRm
```

# Azure Stack Hub Tools の準備
まず、ASDK を Azure に登録した際にも利用した Azure Stack Hub Tool のダウンロードを実施します。

+ [Download Azure Stack Hub tools from GitHub](https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-powershell-download/?WT.mc_id=AZ-MVP-5002708)

```powershell
# Change directory to the root directory.
cd \

# Download the tools archive.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
invoke-webrequest https://github.com/Azure/AzureStack-Tools/archive/az.zip -OutFile az.zip

# Expand the downloaded files.
expand-archive az.zip -DestinationPath . -Force

# Change to the tools directory.
cd AzureStack-Tools-az
```

Github からダウンロードした後、Azure Stack Hub Tools の AZ モジュールは下記のように配置されます。
```powershell
PS C:\AzureStack-Tools-az> ls


    Directory: C:\AzureStack-Tools-az


Mode                LastWriteTime         Length Name                                                                                                          
----                -------------         ------ ----                                                                                                          
d-----         1/2/2021   4:08 AM                CloudCapabilities                                                                                             
d-----         1/2/2021   4:08 AM                Connect                                                                                                       
d-----         1/2/2021   4:08 AM                DatacenterIntegration                                                                                         
d-----         1/2/2021   4:08 AM                Deployment                                                                                                    
d-----         1/2/2021   4:08 AM                Identity                                                                                                      
d-----         1/2/2021   4:08 AM                Policy                                                                                                        
d-----         1/2/2021   4:08 AM                Registration                                                                                                  
d-----         1/2/2021   4:08 AM                Support                                                                                                       
d-----         1/2/2021   4:08 AM                Syndication                                                                                                   
d-----         1/2/2021   4:08 AM                TemplateValidator                                                                                             
d-----         1/2/2021   4:08 AM                ToolTestingUtils                                                                                              
d-----         1/2/2021   4:08 AM                Usage                                                                                                         
-a----        10/9/2020   1:41 PM            397 CONTRIBUTING.md                                                                                               
-a----        10/9/2020   1:41 PM           1075 LICENSE.txt                                                                                                   
-a----        10/9/2020   1:41 PM           7794 README.md                                                                                                     
-a----        10/9/2020   1:41 PM           5432 ThirdPartyNotices.txt                                                                                       
```

# Azure 登録の削除
先ほどダウンロードした `Azure Stack Hub Tools - AZ` を利用して、Azure に登録した Azure Stack の情報を削除します。

```powershell
#Import the registration module that was downloaded with the GitHub tools
Import-Module C:\AzureStack-Tools-az\Registration\RegisterWithAzure.psm1

# Provide Azure subscription admin credentials
Add-AzAccount

# Provide ASDK admin credentials
$CloudAdminCred = Get-Credential -UserName AZURESTACK\CloudAdmin -Message "Enter the cloud domain credentials to access the privileged endpoint"

# Unregister Azure Stack
Remove-AzsRegistration `
   -PrivilegedEndpointCredential $CloudAdminCred `
   -PrivilegedEndpoint AzS-ERCS01
   -RegistrationName $RegistrationName

# Remove the Azure Stack resource group
Remove-AzResourceGroup -Name azurestack -Force
```
## $RegistrationName について
Azure Stack Hub の登録を削除する際に指定する $RegistrationName ですが、Azure Stack Hub Admin ポータルから確認することができます。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzSHub/Redeploy/1.png" class="full" width="600">

Registration Name コマンド発行後に RegistrationName を指定できますので、RegistrationName に登録名を記載してください。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzSHub/Redeploy/2.png" class="full" width="600">

## Remove-AzResourceGroup コマンドでエラーになる
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzSHub/Redeploy/3.png" class="full" width="600">  

ロックの設定値が残っていることで、リソースグループを削除できない状況になっているようです。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzSHub/Redeploy/4.png" class="full" width="600">

Azure ポータルから azurestack リソースグループに移動し、ロックを削除するこで、コマンドからリソースグループの削除が可能になります。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzSHub/Redeploy/5.png" class="full" width="600">

# Azure AD に Application 登録された Azure Stack Hub オブジェクトの削除
何度も ASDK をインストールすると、Azure AD にアプリケーション登録されたオブジェクトが複数存在します。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzSHub/Redeploy/6.png" class="full" width="600">

Azure のクラウドシェル (Powershell) から下記コマンドを実行するだけで、簡単に Azure Stac Hub に関する 登録された アプリケーションオブジェクトを削除できます。 GUI から1つ1つ削除するのはかなり面倒なので、クラウドシェルから削除してみてください。

1. クラウドシェルを起動して、AAD に接続します。
    ```powershell
    Connect-AzureAD
    ```
2. アプリケーション登録された Azure Stack Hub のオブジェクトを削除します。
    ```powershell
    Get-AzureADApplication -SearchString "Azure Stack" | Remove-AzureADApplication
    ```
3. Azure Stack Hub の登録されたオブジェクトが削除されたか確認します。
    ```powershell
    Get-AzureADApplication -SearchString "Azure Stack"
    ```
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzSHub/Redeploy/7.png" class="full" width="600">

ここまで完了すれば、キレイに Azure Stack のリソースを削除できたことになります。新しいバージョンの ASDK をインストールしてください！


