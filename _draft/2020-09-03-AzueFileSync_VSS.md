---
title: "Azure File Sync で VSS (Volume Shadow Copy) を利用する"
date: 2020-09-03 13:30:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Azure
tags: 
 - Azure Files
---

こんにちは。  
ファイルサーバーで、VSS (ボリュームシャドーコピー) を設定し、ユーザー自身で以前のバージョンにファイルを回復させているかたが多いと思います。
Azure File Sync を利用した ファイルサーバーで VSS を利用する方法についてご紹介です。

+ [以前のバージョンおよび VSS (ボリューム シャドウ コピー サービス) を使用するセルフサービス復元](https://docs.microsoft.com/ja-jp/azure/storage/files/storage-sync-files-deployment-guide?tabs=azure-portal%2Cproactive-portal#self-service-restore-through-previous-versions-and-vss-volume-shadow-copy-service)

## VSS と以前のバージョンについて
VSS を利用すると、取得時点のファイルのスナップショットが作成されます。
スナップショットを取得したタイミングのファイルに戻したい場合、ユーザー自身で、ファイルのプロパティから「以前のバージョン」 を選択してファイルを回復させることができます。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzureFiles/VSS/1.png" class="full" width="750">

## VSS のサポート状況
Azure File Sync エージェント バージョン9 以降から、Azure File Sync を利用する環境で VSS がサポートされるようになりました。


## Storage Sync Management Server のコマンド
Azure File Sync エージェントは、`StorageSync.Management.ServerCmdlets` モジュールで管理することができます。

コマンドを利用するには、dll ファイルを読み込む必要があります。
エージェントをインストールしたフォルダに配置されています。
```powershell
Import-Module 'C:\Program Files\Azure\StorageSyncAgent\StorageSync.Management.ServerCmdlets.dll'
```

## このモジュールで利用できるコマンド一覧
`Get-Module` で確認するとこちらのコマンドが表示されます。

```powershell
PS C:\> Get-Command -Module StorageSync.Management.ServerCmdlets

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Disable-StorageSyncSelfServiceRestore              1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Enable-StorageSyncSelfServiceRestore               1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Get-StorageSyncAgentAutoUpdatePolicy               1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Get-StorageSyncFileAccessPattern                   1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Get-StorageSyncFileRecallResult                    1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Get-StorageSyncFileTieringResult                   1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Get-StorageSyncHeatStoreInformation                1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Get-StorageSyncNetworkLimit                        1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Get-StorageSyncOrphanedTieredFiles                 1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Get-StorageSyncProxyConfiguration                  1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Get-StorageSyncSelfServiceRestore                  1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Get-StorageSyncServer                              1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Get-StorageSyncServerEndpoint                      1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Invoke-StorageSyncCloudTiering                     1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Invoke-StorageSyncFileRecall                       1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Invoke-StorageSyncServerGarbageCollection          1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Invoke-StorageSyncServerScrubbing                  1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          New-StorageSyncNetworkLimit                        1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Remove-StorageSyncNetworkLimit                     1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Remove-StorageSyncOrphanedTieredFiles              1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Remove-StorageSyncProxyConfiguration               1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Reset-StorageSyncServer                            1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Set-StorageSyncAgentAutoUpdatePolicy               1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Set-StorageSyncProxyConfiguration                  1.0.0.0    StorageSync.Management.ServerCmdlets
Cmdlet          Test-StorageSyncNetworkConnectivity                1.0.0.0    StorageSync.Management.ServerCmdlets
```
