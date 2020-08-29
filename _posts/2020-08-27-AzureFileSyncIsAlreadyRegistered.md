---
title: "Azure File Sync で This server is already registered"
date: 2020-08-27 20:00:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Azure
tags: 
 - Azure File Sync
---

# Azure File Sync のエラー

Azure File Sync の登録済みサーバーから解除したサーバーを、もう一度登録しようとしたときにエラーになる事象に遭遇しました。
Azure ポータルから登録削除をしたのですが、ファイルサーバー側はまだ登録されている認識でした。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzureFileSyncError/1.png" class="full" width="1000">

ファイルサーバー側で登録解除する方法は Docs のトラブルシュートページに記載があります。

[Azure File Sync のトラブルシューティング](https://docs.microsoft.com/ja-jp/azure/storage/files/storage-sync-files-troubleshoot?tabs=portal1%2Cazure-portal)

## 解除方法手順

1. ファイルサーバーで下記のコマンドを実行します。
```powershell
Import-Module "C:\Program Files\Azure\StorageSyncAgent\StorageSync.Management.ServerCmdlets.dll"
Reset-StorageSyncServer
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzureFileSyncError/2.png" class="full" width="1000">

2. Azure Storage Sync Agent Update を実行します。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzureFileSyncError/3.png" class="full" width="500">

3. OK をクリックします。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzureFileSyncError/4.png" class="full" width="1000">

4. Server Registration が起動します。ストレージ同期サービスに登録してください。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzureFileSyncError/5.png" class="full" width="1000">
 
これで無事に登録できるようになるはすなので、試してみてください。