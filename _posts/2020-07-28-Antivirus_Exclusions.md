---
title: "Windows Server のアンチウイルス推奨設定"
date: 2020-07-28 00:00:00 -0000
categories: 
 - Windows Sever
tags: 
 - Antivirus Exclusions
---

#  Windows Server 2016 以降で 3rd パーティーのアンチウイルスソフトを使う
## Windows Defender のアンインストール
3rd パーティーのアンチウイルスソフトウェアを利用する際は、既定でインストールされている Microsoft Defender Antivirus をアンインストールすることが推奨されています。
+ [Microsoft Defender Antivirus on Windows Server 2016 and 2019](https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-antivirus/microsoft-defender-antivirus-on-windows-server-2016#need-to-uninstall-microsoft-defender-antivirus)

GUI から 役割と機能の削除でアンインストールすることも可能ですが、Powershell から実行すると簡単です。
+ [Uninstall Microsoft Defender Antivirus using PowerShell](https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-antivirus/microsoft-defender-antivirus-on-windows-server-2016#uninstall-microsoft-defender-antivirus-using-powershell)
+ Windows Defender をアンインストール
```powershell
Uninstall-WindowsFeature -Name Windows-Defender
```
+ Windows Defender GUI をアンインストール
```powershell
Uninstall-WindowsFeature -Name Windows-Defender-GUI

```
# Windows Server のアンチウイルス除外設定

## Windows Server
+ 2016 and 2019 
    + Microsoft Defender ATP (Advanced Threat Protection) で除外設定される項目一覧
    + [Configure Microsoft Defender Antivirus exclusions on Windows Server](https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-antivirus/configure-server-exclusions-microsoft-defender-antivirus)

## Hyper-V
+ 2019
    + [Recommended antivirus exclusions for Hyper-V hosts](https://support.microsoft.com/en-gb/help/3105657/recommended-antivirus-exclusions-for-hyper-v-hosts)

    ### Files
    All directories that contain the following files:

    + Virtual Hard Disk file (*.vhd)
    + Virtual Hard Disk v2 file (*.vhdx)
    + Virtual Hard Disk snapshot file (*.avhd)
    + Virtual Hard Disk v2 snapshot file (*.avhdx)
    + VHD Set file (*.vhds)
    + Virtual PMEM VHD file (*.vhdpmem)
    + Virtual Optical Disk images (*.iso)
    + Resilient Change Tracking file (*.rct)
    + Device state file (*.vsv)
        + Note The processes that creates, opens or updates the file: vmms.exe, vmwp.exe, vmcompute.exe.
    + Memory state file (*.bin)
        + Note The processes that creates, opens or updates the file: vmwp.exe
    + VM Configuration file (*.vmcx)
        + Note The processes that creates, opens or updates the file: vmms.exe
    + VM Runtime State file (*.vmrs)
        + Note The processes that creates, opens or updates the file: vmms.exe, vmwp.exe, vmcompute.exe.
    + VM Guest State file (*.vmgs)

    ### Directory
    + The default virtual machine configuration directory, if it's used, and any of its subdirectories: 
        + %ProgramData%\Microsoft\Windows\Hyper-V
    + The default virtual machine virtual hard disk files directory, if it's used, and any of its subdirectories: 
        + %Public%\Documents\Hyper-V\Virtual Hard Disks
    + The default snapshot files directory, if it's used, and any of its subdirectories: 
        + %SystemDrive%\ProgramData\Microsoft\Windows\Hyper-V\Snapshots
    + The default Cluster Shared Volumes path, if you're using Cluster Shared Volumes, and any of its subdirectories:
        + C:\ClusterStorage
    + Any custom virtual machine configuration directories, if applicable
    + Any custom virtual hard disk drive directories, if applicable
    + Any custom replication data directories, if you're using Hyper-V Replica
    + If antivirus software is running on your file servers, any Server Message Block protocol 3.0 (SMB 3.0) file shares on which you store virtual machine files.

    ### Process
    + Vmms.exe (%systemroot%\System32\Vmms.exe)
        + Note This file may have to be configured as a process exclusion within the antivirus software.
    + Vmwp.exe (%systemroot%\System32\Vmwp.exe)
        + Note This file may have to be configured as a process exclusion within the antivirus software.
    + Vmsp.exe (%systemroot%\System32\Vmsp.exe)
        + Note Starting with Windows Server 2016, this file may have to be configured as a process exclusion within the antivirus software.
    + Vmcompute.exe (%systemroot%\System32\Vmcompute.exe)
        + Note Starting with Windows Server 2019

## System Center
   ### Virtual Machine Manager
   + 2012R2
       + [Recommended antivirus exclusions for System Center Virtual Machine Manager and managed hosts](https://support.microsoft.com/en-us/help/3119208/recommended-antivirus-exclusions-for-system-center-virtual-machine-man)

