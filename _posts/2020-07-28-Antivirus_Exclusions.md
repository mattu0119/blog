---
title: "Hyper-V 関連のアンチウイルス推奨設定"
date: 2020-07-28 00:00:00 -0000
last_modified_at: 2020-12-23 11:00:00 +08:00
categories: 
 - Windows Server
tags: 
 - Antivirus Exclusions
 - Windows Server
---

# はじめに
Windows Server を利用する際に注意すべきアンチウイルスの除外設定についてまとめました。
本投稿では Hyper-V や SCVMM の除外設定しか記載していないですが、TechNet に Microsoft Anti-Virus Exclusion List をまとめたページがありますので、利用する製品の除外設定を確認したい場合に参照してください！
* [Microsoft Anti-Virus Exclusion List](https://social.technet.microsoft.com/wiki/contents/articles/953.microsoft-anti-virus-exclusion-list.aspx)

## Windows Defender のアンインストール
3rd パーティーのアンチウイルスソフトウェアと既定でインストールされている Microsoft Defender Antivirus のアンチウイルスで問題が起きている場合は、Microsoft Defender をアンインストールすることも検討してください。
+ [Microsoft Defender Antivirus on Windows Server 2016 and 2019](https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-antivirus/microsoft-defender-antivirus-on-windows-server-2016#need-to-uninstall-microsoft-defender-antivirus/?WT.mc_id=WDIT-MVP-5002708)

GUI から 役割と機能の削除でアンインストールすることも可能ですが、Powershell から実行すると簡単です。
+ [Uninstall Microsoft Defender Antivirus using PowerShell](https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-antivirus/microsoft-defender-antivirus-on-windows-server-2016#uninstall-microsoft-defender-antivirus-using-powershell/?WT.mc_id=WDIT-MVP-5002708)
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
    + [Configure Microsoft Defender Antivirus exclusions on Windows Server](https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-antivirus/configure-server-exclusions-microsoft-defender-antivirus/?WT.mc_id=WDIT-MVP-5002708)

## Hyper-V
+ 2019
    + [Recommended antivirus exclusions for Hyper-V hosts](https://support.microsoft.com/en-gb/help/3105657/recommended-antivirus-exclusions-for-hyper-v-hosts//?WT.mc_id=WDIT-MVP-5002708)

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
        + 	ファイルを作成、開く、または更新するプロセス: vmms.exe, vmwp.exe, vmcompute.exe.
    + Memory state file (*.bin)
        + 	ファイルを作成、開く、または更新するプロセス: vmwp.exe
    + VM Configuration file (*.vmcx)
        + 	ファイルを作成、開く、または更新するプロセス: vmms.exe
    + VM Runtime State file (*.vmrs)
        + 	ファイルを作成、開く、または更新するプロセス: vmms.exe, vmwp.exe, vmcompute.exe.
    + VM Guest State file (*.vmgs)

    ### Directory
    + 既定の仮想マシン構成ディレクトリ (使用されている場合) とそのサブディレクトリ
        + %ProgramData%\Microsoft\Windows\Hyper-V
    + デフォルトの仮想マシン仮想ハードディスクファイルディレクトリ(使用されている場合)、およびそのサブディレクトリ
        + %Public%\Documents\Hyper-V\Virtual Hard Disks
    + デフォルトのスナップショットファイルディレクトリ(使用されている場合)とそのサブディレクトリ 
        + %SystemDrive%\ProgramData\Microsoft\Windows\Hyper-V\Snapshots
    + クラスター共有ボリュームを使用している場合のデフォルトのクラスター共有ボリュームパス、およびそのサブディレクト
        + C:\ClusterStorage
    + 仮想マシン構成ファイルのカスタムディレクトリ (該当する場合)
    + 仮想ハードディスクドライブのカスタムディレクトリ(該当する場合)
    + レプリケーションデータのカスタム ディレクトリ(Hyper-V レプリカを使用している場合)
    + ウイルス対策ソフトウェアがファイルサーバー上で実行されている場合、仮想マシンファイルを保存する SMB 3.0ファイル共有

    ### Process
    + Vmms.exe (%systemroot%\System32\Vmms.exe)
        + このファイルは、ウイルス対策ソフトウェア内でプロセスの除外として構成する必要があります。
    + Vmwp.exe (%systemroot%\System32\Vmwp.exe)
        + このファイルは、ウイルス対策ソフトウェア内でプロセスの除外として設定する必要があります。
    + Vmsp.exe (%systemroot%\System32\Vmsp.exe)
        + Windows Server 2016 以降、このファイルは、ウイルス対策ソフトウェア内のプロセスの除外として構成する必要があります。
    + Vmcompute.exe (%systemroot%\System32\Vmcompute.exe)
        + Windows サーバー 2019 以降

## System Center
   ### Virtual Machine Manager
   + 2012R2
       + [Recommended antivirus exclusions for System Center Virtual Machine Manager and managed hosts](https://support.microsoft.com/en-us/help/3119208/recommended-antivirus-exclusions-for-system-center-virtual-machine-man/?WT.mc_id=WDIT-MVP-5002708)

