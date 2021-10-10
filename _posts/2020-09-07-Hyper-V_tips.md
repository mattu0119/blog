---
title: "Azure Stack HCI / Hyper-V 設計の Tips"
date: 2020-09-07 10:30:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Azure Stack HCI
#tags: 
# - Management
---

+ [Cluster size recommendations for ReFS and NTFS](https://techcommunity.microsoft.com/t5/storage-at-microsoft/cluster-size-recommendations-for-refs-and-ntfs/ba-p/425960)
    + CSVFS_ReFS のアロケーションユニットサイズは、4K(既定値) が推奨。

+ [Hyper-V Replica Step-By-Step: Virtual Machine Replication](https://social.technet.microsoft.com/wiki/contents/articles/36705.hyper-v-replica-step-by-step-virtual-machine-replication.aspx)

+ [Windows Server バックアップによる Hyper-V Host Component のバックアップと復元について](https://docs.microsoft.com/en-us/archive/blogs/askcorejp/windows-server-hyper-v-host-component)

+ [S2D ReadyNode - 障害ディスク交換手順](https://www.dell.com/support/article/ja-jp/sln320809/s2d-readynode-%E9%9A%9C%E5%AE%B3%E3%83%87%E3%82%A3%E3%82%B9%E3%82%AF%E4%BA%A4%E6%8F%9B%E6%89%8B%E9%A0%86?lang=ja)

+ [Volume resiliency and efficiency in Storage Spaces Direct](https://techcommunity.microsoft.com/t5/storage-at-microsoft/volume-resiliency-and-efficiency-in-storage-spaces-direct/ba-p/425831)


|Site|Condition|Scenario example|
|---|---|---|
|Primary|Modify VHD when VM is turned off|Mount/modify VHD outside the VM, Edit disk, Offline patching
Primary|Size of tracking log files > 50% of total VHD size for a VM|Network outage causes logs to accumulate|
|Primary|Write failure to tracking log file|VHD and logs are on SMB and connectivity to the SMB storage is flaky.|
|Primary|Tracking log file is not closed gracefully|Host crash with primary VM running. Applicable to VMs in a cluster also.|
|Primary|Reverting the volume to an older point in timeReverting the VM to an older snapshot|Volume/snapshot backup and restore|
|Secondary|Out-of-sequence or Invalid log file is applied|Restoring a backed-up copy of the Replica VM|


+ [Remove-VMSnapshot](https://docs.microsoft.com/en-us/powershell/module/hyper-v/remove-vmsnapshot?view=win10-ps)
BE などバックアップに失敗して Snapshot 残ってしまったときに実施。
```powershell
Get-VM <VM名> | Remove-VMSnapshot
```
