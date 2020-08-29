---
title: "Azure Stack HCI で利用できるボリューム"
date: 2020-08-28 23:00:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Azure Stack HCI
tags: 
 - Azure Stack HCI
---

こんにちは。Azure Stack HCI で利用できるボリュームの作成方法をまとめました。

また、Windows Server 2019 S2D (Storage Spaces Direct) のアップデート情報はこちらをご参照ください。
<iframe src="//www.slideshare.net/slideshow/embed_code/key/qAkyvdzsrk1KB" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/HiroshiMatsumoto1/interact2019-ws2019-s2din05" title="Interact2019 ws2019 s2d_IN05" target="_blank">Interact2019 ws2019 s2d_IN05</a> </strong> from <strong><a href="//www.slideshare.net/HiroshiMatsumoto1" target="_blank">Hiroshi Matsumoto</a></strong> </div>

## 2way Mirror 
```powershell
New-Volume -FriendlyName "Volume01-2w" -StoragePoolFriendlyName *S2D* -Size 100GB -ResiliencySettingName Mirror -PhysicalDiskRedundancy 1 -Verbose
```

## 3way mirror
```powershell
New-Volume -FriendlyName "Volume02-3w" -StoragePoolFriendlyName *S2D* -Size 100GB -ResiliencySettingName Mirror -Verbose
```

## Dual Parity
```powershell
New-Volume -FriendlyName "Volume03-dp" -StoragePoolFriendlyName *S2D* -Size 100GB -ResiliencySettingName Parity -Verbose
```

## Mirror Accelerated Parity
```powershell
New-StorageTier -StoragePoolFriendlyName S2D* -FriendlyName Performance -ResiliencySettingName Mirror -NumberOfDataCopies 2 -MediaType HDD
New-Volume -StoragePoolFriendlyName S2D* -FriendlyName Volume04-map -StorageTierFriendlyNames Performance,Capacity -StorageTierSizes 20GB,80GB
```

## Nested Mirror
```powershell
New-StorageTier -StoragePoolFriendlyName S2D* -FriendlyName NestedMirror -ResiliencySettingName Mirror -NumberOfDataCopies 4 -MediaType HDD
New-Volume -StoragePoolFriendlyName S2D* -FriendlyName Volume05-n2w -StorageTierFriendlyNames NestedMirror -StorageTierSizes 100GB -Verbose
```

## Nested Parity
```powershell
New-StorageTier -StoragePoolFriendlyName S2D* -FriendlyName NestedMirror -ResiliencySettingName Mirror -NumberOfDataCopies 4 -MediaType HDD
New-StorageTier -StoragePoolFriendlyName S2D* -FriendlyName NestedParity -ResiliencySettingName Parity -NumberOfDataCopies 2 -PhysicalDiskRedundancy 1 -NumberOfGroups 1 -FaultDomainAwareness StorageScaleUnit -ColumnIsolation PhysicalDisk -MediaType HDD
New-Volume -StoragePoolFriendlyName S2D* -FriendlyName Volume06-nmap -StorageTierFriendlyNames NestedMirror,NestedParity -StorageTierSizes 20GB,80GB
```