---
title: "ネットワークドライブの接続"
date: 2020-08-29 13:30:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Azure
tags: 
 - Azure Files
---

ネットワークドライブの接続方法です。

## コマンドプロンプト

### 接続
ネットワークドライブに接続するコマンドです。永続的に接続するには、`/PERSISTENT:YES` を指定する必要があります。

```powershell
net use Z: \\computername\sharename /USER:domainname\username /PERSISTENT:YES
```

### 接続状況確認
接続しているネットワークドライブを閣員するコマンドです。

```powershell
net use
```
### 切断
ネットワークドライブを切断するコマンドです。
```powershell
net use Z: /DELETE
```
GUI から削除した場合、完全にネットワークドライブが切断されないときがあります。
エラー内容 `ローカルデバイス名は既に使用されています。`

この場合は、コマンドプロンプトから `net use` コマンドで状況確認し、`net use <ドライブ> /DELTE` コマンドでエラになっているドライブを削除してください。


