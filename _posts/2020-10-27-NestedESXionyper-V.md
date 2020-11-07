---
title: "Nested ESXi on Hyper-V の構築"
date: 2020-11-07 23:30:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Hyper-V
 - Nested ESXi
---

こんにちは。
今回は Nested ESXi on Hyper-V の構築を実施してみます。  
Nested Hyper-V on ESXi の記事は多くあるのですが、逆はあまりないので。。。  


## 1. カスタマイズ ESXi インストールメディアの作成
1. PowerCLI のインストール  
ESXi-Customizer-PS を利用するには、PowerCLI が必要になります。PowerCLI は、Powershell を利用して vSphere 環境を管理するツールです。  
PowerCLI のインストール後、OS の再起動を実施してください。  
下記のように `Get-VM` など Hyper-V と同じコマンドもありますので、Hyper-V ホスト以外にインストールすることをおすすめします。 

```powershell
PS C:\Users\Administrator> Get-Command get-vm*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Get-VM                                             6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMGuest                                        6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMGuestNetworkInterface                        6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMGuestRoute                                   6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHost                                         6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostAccount                                  6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostAdvancedConfiguration                    6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostAuthentication                           6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostAvailableTimeZone                        6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostDiagnosticPartition                      6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostDisk                                     6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostDiskPartition                            6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostFirewallDefaultPolicy                    6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostFirewallException                        6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostFirmware                                 6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostHba                                      6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostModule                                   6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostNetwork                                  6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostNetworkAdapter                           6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostNtpServer                                6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostPatch                                    6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostProfile                                  6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostProfileRequiredInput                     6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostRoute                                    6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostService                                  6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostSnmp                                     6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostStartPolicy                              6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostStorage                                  6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMHostSysLogServer                             6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMQuestion                                     6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMResourceConfiguration                        6.0.0.0    VMware.VimAutomation.Core
Cmdlet          Get-VMStartPolicy                                  6.0.0.0    VMware.VimAutomation.Core
```

2. ESXi-Customizer-PS ツールのダウンロード
Hyper-V の仮想マシンで ESXi を Neted で利用する場合、Net-Tulip というネットワークドライバーをESXi にインストールする必要があります。  
Net-Tulip をインストールした カスタム ESXi インストール ISO ファイルを作成するには、ESXi-Customizer-PS というツールを使います。最新のバージョンは Github で公開されていますので、任意のフォルダにダウンロードします。  
+ [ESXi-Customizer-PS GitHub Pages](https://github.com/VFrontDe/ESXi-Customizer-PS)
```powershell
# Change directory to the root directory.
cd C:\temp
# Download the tools archive.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
invoke-webrequest https://github.com/VFrontDe/ESXi-Customizer-PS/archive/master.zip -OutFile ESXi-Customizer-PS.zip
# Expand the downloaded files.
expand-archive ESXi-Customizer-PS.zip -DestinationPath . -Force
# Change to the tools directory.
cd .\ESXi-Customizer-PS-master\
```
3. カスタマイズ ESXi インストール ISO の作成
ESXi-Customizer-PS を利用して、カスタマイズ ISO ファイルを作成します。  
ESXi-Customizer-PS の使い方はこちらのブログサイトに詳細説明があります。  
+ [ESXi-Customizer-PS](https://www.v-front.de/p/esxi-customizer-ps.html)  
こちらのコマンドを実行することで、今回作成したい ISO を作成できます。   
```powershell
# カスタマイズ ISO の作成
ESXi-Customizer-PS.ps1 -v55 -vft -load net-tulip
```  
`-v55` というのは ESXi 5.5 バージョンを指定しています。     
`-v60` の場合は、 ESXi 6.0 になりますので、利用したいバージョンを指定してください。 
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/1.png" class="full" width="600">  

また、`-load` で net-tulip を指定することで、net-tulip をインストールした ESXi イメージになります。     
コマンドを実行したカレントディレクトリに、カスタマイズした ISO ファイルが作成されます。   
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/3.png" class="full" width="600">   
ESXi-Customizer-PS のヘルプを確認するにはこちらのコマンドです。   
```powershell
ESXi-Customizer-PS -help
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/2.png" class="full" width="600">

## 2. カスタマイズした ISO ファイルから ESXi をインストール
仮想マシンを作成して、ISO から ESXi をインストールします。

1.仮想マシンの作成  
 仮想マシンは 第1世代で作成する必要があります。また、CSP は 4コア以上に設定する必要があります。

 | 項目| 設定値|
 |----|----|
 |仮想マシン世代|第1世代|
 |CPU|4コア以上|
 |メモリ|4GB 以上|
 |ネットワークアダプタ|レガシーネットワークアダプター|

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/4.png" class="full" width="600">  
 コア数が要件に満たない場合は、インストール時にエラーとなりますので気を付けてください。  
 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/15.png" class="full" width="600">  

2.Nested の有効化  
仮想マシンを作成したら、下記コマンドを実行して CPU 仮想化を有効にします。`-VMname` の値は適宜修正してください。
また、つぎに、レガシーネットワークアダプターの MAC Address Spoofing を有効にします。  
```powershell
Set-VMProcessor -VMName esxi55 -ExposeVirtualizationExtensions $True
Set-VMNetworkAdapter -VMName esx55 -MacAddressSpoofing On
```
これで Nested 仮想マシンの準備は完了です。

3.ESXi のインストール  
作成した仮想マシンに ESXi をインストールします。

4.ESXi-Customizer-PS で作成した ISO を仮想マシンにマウントし、仮想マシンを起動します。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/5.png" class="full" width="600">

5.ISO メディアで Boot した後、`Tab` キーを押します。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/6.png" class="full" width="600">

6.下記のコマンドを実行します。  
 `ignoreHeadless=TRUE`
 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/7.png" class="full" width="600">
 このコマンドを実行すると、ESXi のインストールが開始されます。  
 実行しなかった場合は、OS をインストールすることができませんので注意してください。  
 この `Relocating modules and starting up the kernel...` から画面が遷移しない状態となります。  
 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/8.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/9.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/10.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/11.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/12.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/13.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/14.png" class="full" width="600">
 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/15.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/16.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/17.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/18.png" class="full" width="600">

7.OS インストールが完了後の再起動時に、再度コマンドを入れる必要があります。  
 OS が再起動した直後に `Shift + O` を押します。すると、コマンドラインを入力できるようになります。
そこで下記のコマンドを実行します。
`ignireHeadless=TRUE`
 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/19.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/20.png" class="full" width="600">

8.OS 起動後、ESX Shell を有効化します。  

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/21.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/22.png" class="full" width="600">

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/23.png" class="full" width="600">

9.`Alt + F1` を押し、ESX Shell に Root ユーザーでログインし、下記のコマンドを実行します。  
```powershell
esxcfg-advcfg --set-kernel "TRUE" ignoreHeadless
```

 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/24.png" class="full" width="600">

10.コマンドを実行します。  
 ```powershell
 esxcfg-advcfg --set-kernel "TRUE" ignoreHeadless
 ```

 これで再起動のたびにコマンドを実行する必要がなくなります。

11.`Alt ＋ F2` を押して、ESX のダイレクトコンソールに戻ります。  
 <img src="{{ site.url }}{{ site.baseurl }}/assets/images/NestedESXi/Customizer/25.png" class="full" width="600">

これで Nested ESXi の設定は完了です。  
このあとは、必要な設定を実施して vCenter に登録して動作確認をしてみてください！


