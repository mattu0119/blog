---
title: "クラウドエンドポイントの変更を直ちに検出"
date: 2020-09-01 13:30:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Azure
tags: 
 - Azure Files
---
+ [Invoke-AzStorageSyncChangeDetection](https://docs.microsoft.com/ja-jp/powershell/module/az.storagesync/invoke-azstoragesyncchangedetection?view=azps-4.6.1)


Login-AzAccount -Subscription "Microsoft Azure スポンサー プラン"

## cloudendpointname の確認
Get-AzStorageSyncCloudEndpoint -ResourceGroupName "storage-rg" `
-StorageSyncServiceName publicsync1 `
-SyncGroupName publicsync1

## 差分チェックジョブの実行
Invoke-AzStorageSyncChangeDetection -ResourceGroupName "storage-rg" `
-StorageSyncServiceName "publicsync1" `
-SyncGroupName "publicsync1" `
-CloudEndpointName "ff53158f-f744-4e4e-a3d7-bba5d1730fcb" `
-Path "00_Everyone"
