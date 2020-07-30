---
title: "Powershell でポート指定の通信確認"
date: 2020-07-30 00:00:00 -0000
categories: 
 - Windows Sever
tags: 
 - Powershell
---

# ポート番号指定での疎通確認方法

新規環境の構築やトラブルシューティング時の通信確認として、Pingを利用する場面は非常に多いと思います。
Ping は非常に簡単に通信確認ができるコマンドですが、特定の TCP ポートで通信確認がしたい場合には機能不足です。

特定の TCP ポートの疎通確認をしたい場合は、下記のコマンドを試してみてください。
```powershell
Test-NetConnection
```

このコマンドは、Windows 8.1、Windows Server 2012R2 以降の OS では既定で利用できるコマンドです。

+ [Test-NetConnection](https://docs.microsoft.com/ja-jp/powershell/module/nettcpip/Test-NetConnection?view=win10-ps)



