---
title: "Windows Server 2019 Active Directory で Windows Server 2003 のドメイン参加と RDP 接続でエラー"
date: 2020-10-15 16:00:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Windows Server
tags:
 - Windows Server 2003
 - Windows Server 2019
 - Active Directory
---

まだ Windows Server 2003 を利用されている人がどれくらいいるかわかりませんが、、、。  
Windows Server 2019 の Active Direcotry に移行後、Windows Server 2003 で新規にドメイン参加や、ドメインユーザーでのリモートデスクトップができない状況となりました。  
ローカルユーザーではリモートデスクトップでのログインが可能でした。  

接続時のエラーはこのような内容です。  
+ ドメイン参加
エラー内容は、**指定されたネットワーク名は利用できません。** と表示されます。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/WindowsServer/1-2003/1.png" class="full" width="400">
 
+ リモートデスクトップ
エラー内容は、**RPCサーバーを利用できません。**と表示されます。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/WindowsServer/1-2003/2.png" class="full" width="500">

詳しい理由はわからなかったのですが、Windows Server 2019 からは 既定で SMBv1 が無効化されていることが原因のようです。  

Windows Server 2003 の設定変更は何もせず、Windows Server 2016 の Active Directory には参加することができました。  

そのため、対応としてはすべての Active Directory で SMBv1 を有効化することで解決することができます。  
SMBv1 は**役割の追加**からインストールできます。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/WindowsServer/1-2003/4.png" class="full" width="600">

または、Powershell からインストールすることも可能です。  
[How to gracefully remove SMB v1 in Windows 8.1, Windows 10, Windows 2012 R2, Windows Server 2016, and Windows Server 2019](https://docs.microsoft.com/en-us/windows-server/storage/file-server/troubleshoot/detect-enable-and-disable-smbv1-v2-v3#smb-v1-client-and-server/?WT.mc_id=WDIT-MVP-5002708)

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName smb1protocol
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/WindowsServer/1-2003/7.png" class="full" width="600">

インストール後、再起動が必要です。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/WindowsServer/1-2003/5.png" class="full" width="600">

すべての Active Directory で SMBv1 をインストールしたら、Windows Server 2003 にドメインユーザーにリモートデスクトップしたり、ドメイン参加を試してみてください。問題なく成功するはずです。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/WindowsServer/1-2003/6.png" class="full" width="400">

SMBv1 はレガシープロトコルで、脆弱性を利用したランサムウェアによる被害も報告されています。SMB1 は既定で無効になったプロトコルでもあるため、利用は推奨されていません。  
[Stop using SMB1](https://techcommunity.microsoft.com/t5/storage-at-microsoft/stop-using-smb1/ba-p/425858)

本当に必要でない場合に限り、SMB1 を有効にして利用いただければと思います。  

以上となります。







