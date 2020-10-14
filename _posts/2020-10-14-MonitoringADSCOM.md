---
title: "SCOM で Active Directory の監視"
date: 2020-10-14 23:00:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - SCOM
 - Active Directory
---

SCOM エージェントをインストールして Active Directory の監視を行う場合、エージェントのインストールだけでは Active Directory の監視をできるようなりません。  
エージェントをインストールしたタイミングでは問題なくみえますが、少しすると「状態」が <font color="DarkGreen">**グリーン**</font> から<font color="Gray">**グレーアウト**</font>の状態となります。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/SCOM/ADMonitoring/1.png" class="full" width="600">

これは、HSLOCKDOWN がローカルシステムアカウントを `拒否` する設定になっていることが原因ということです。
SCOM のトラブルシューティングにも対処内容が紹介されています。  

+ [Operations Manager のヘルス サービス ロックダウン ツールを使用したアクセス制御](https://docs.microsoft.com/ja-jp/previous-versions/system-center/system-center-2012-R2/hh212737(v=sc.12)?redirectedfrom=MSDN\?WT.mc_id=WDIT-MVP-500270\)

そのため、Active Directory にインストールした Monitoring エージェントで、**NT Authority\System** アカウントを拒否設定を削除することで、問題なく Active Direcotry を監視できる状態になります。    

## Active Directory サーバーで HSLockdown.exe で設定値を確認
HSLockdown.exe は Monitoring エージェントをインストールしたフォルダにあります。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/SCOM/ADMonitoring/2.png" class="full" width="600">
 
HSLockdown で 許可 または 拒否されているアカウントは、下記のコマンドで確認できます。  

```powershell
cd 'C:\Program Files\Microsoft Monitoring Agent\Agent\'
PS C:\Program Files\Microsoft Monitoring Agent\Agent> .\HSLockdown.exe /L
```
文字化けしているのですが、下記の項目が表示されます。
1. 管理グループ名
1. 許可
1. 拒否
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/SCOM/ADMonitoring/3.png" class="full" width="600">


## Active Directory を監視できるようにする
Active Directory を監視するには、拒否状態になっている **NT Authority\System** アカウントを削除します。

```powershell
.\hslockdown.exe "Management_Group _Name" /R "NT AUTHORITY\SYSTEM"
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/SCOM/ADMonitoring/4.png" class="full" width="600">

**NT Authority\system** アカウントが削除されたことを確認します。
```powershell
.\HSLockdown.exe /L
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/SCOM/ADMonitoring/5.png" class="full" width="600">

その後、Operations Manager Health Service を再起動します。
```powershell
net stop healthservice
net start healthservice
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/SCOM/ADMonitoring/6.png" class="full" width="600">

すると、Active Directory が正常に監視できる状態になります。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/SCOM/ADMonitoring/7.png" class="full" width="600">

以上となります。






