---
title: "Powershell でポート指定の通信確認"
date: 2020-07-30 00:00:00 +08:00
last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Windows Server
tags: 
 - Powershell
 - Network
---

# ポート番号指定での疎通確認方法
特定の TCP ポートの疎通確認をしたい場合は、下記のコマンドを試してみてください。
```powershell
Test-NetConnection
```

このコマンドは、Windows 8.1、Windows Server 2012R2 以降の OS では既定で利用できるコマンドです。

+ [Test-NetConnection](https://docs.microsoft.com/ja-jp/powershell/module/nettcpip/Test-NetConnection?view=win10-ps/?WT.mc_id=WDIT-MVP-5002708)

このコマンドでは、Ping コマンドでは確認できない項目を確認することが可能です。
1. Ping 疎通確認
1. TCP 疎通確認
1. よく使う TCP ポート


## 1. Ping 疎通確認
通信先のみを指定して確認します。

```powershell
PS C:\> Test-NetConnection google.com

ComputerName           : google.com
RemoteAddress          : 172.217.161.78
InterfaceAlias         : Team0
SourceAddress          : 192.168.244.16
PingSucceeded          : True
PingReplyDetails (RTT) : 3 ms
```

#### Ping 疎通確認のより詳細バージョン
通信先だけでなく、表示する情報のレベルを指定します。
詳細表示させたい場合、`-InformationLevel` を `Detailed` としてください。
名前解決や Next Hop の情報が追加されます。

```powershell
PS C:\> Test-NetConnection google.com -InformationLevel Detailed

ComputerName           : google.com
RemoteAddress          : 172.217.161.78
NameResolutionResults  : 172.217.161.78
InterfaceAlias         : Team0
SourceAddress          : 192.168.244.16
NetRoute (NextHop)     : 192.168.244.254
PingSucceeded          : True
PingReplyDetails (RTT) : 3 ms
```

`-InformationLevel` はもう1つオプションがあり、`Quiet` と指定もできます。
こちらは非常にシンプルな結果が表示されます。
```powershell
PS C:\> Test-NetConnection google.com -InformationLevel Quiet
True
```
## 2. TCP 疎通確認
TCP ポートの疎通確認をする場合、`-Port` オプションを利用します。`TcpTestSucceeded` の結果が `True` であれば、指定した TCP ポートで疎通できたことが確認できます。

```powershell
PS C:\> Test-NetConnection google.com -Port 443

ComputerName     : google.com
RemoteAddress    : 216.58.197.206
RemotePort       : 443
InterfaceAlias   : Team0
SourceAddress    : 192.168.244.16
TcpTestSucceeded : True
```
#### 詳細バージョン
`-InformationLevel` を `Detailed` で指定した場合の結果はこちらです。
```powershell
PS C:\> Test-NetConnection google.com -Port 443 -InformationLevel Detailed

ComputerName            : google.com
RemoteAddress           : 216.58.197.206
RemotePort              : 443
NameResolutionResults   : 216.58.197.206
MatchingIPsecRules      :
NetworkIsolationContext : Internet
InterfaceAlias          : Team0
SourceAddress           : 192.168.244.16
NetRoute (NextHop)      : 192.168.244.254
TcpTestSucceeded        : True
```

## 3. よく使う TCP ポートの疎通確認
`Test-NetConnection` コマンドでは、よく使う TCP ポートのポート番号を指定せず、`-CommonTCPPort` のオプションを指定するだけで、疎通確認することができます。

+ `-CommonTCPPort` で指定できる引数

|オプション|ポート番号|
|--|--|
|HTTP|80|
|RDP|3389|
|SMB|445|
|WinRM|5985|

ポート番号を覚えていなくても通信確認できるのが便利ですね。
```powershell
PS C:\> Test-NetConnection google.com -CommonTCPPort HTTP

ComputerName     : google.com
RemoteAddress    : 172.217.31.174
RemotePort       : 80
InterfaceAlias   : Team0
SourceAddress    : 192.168.244.16
TcpTestSucceeded : True
```
RDP の通信確認もできるので、クラウドに作成した仮想マシンに通信できないときなど、切り分けとしても使えると思います。
```powershell
PS C:\> Test-NetConnection AZSHCINODE01 -CommonTCPPort RDP -InformationLevel Detailed

ComputerName            : AZSHCINODE01
RemoteAddress           : 192.168.245.71
RemotePort              : 3389
NameResolutionResults   : 192.168.245.71
MatchingIPsecRules      :
NetworkIsolationContext : Internet
InterfaceAlias          : Team0
SourceAddress           : 192.168.244.16
NetRoute (NextHop)      : 192.168.244.254
TcpTestSucceeded        : True
```

Windows 8.1 や Windows Server 2012R2 から標準でインストールされているコマンドのため、手軽に疎通確認できるコマンドです。
通信できない状況になった場合、どのレベルで疎通ができていないのか確認したいときに試してみてください！