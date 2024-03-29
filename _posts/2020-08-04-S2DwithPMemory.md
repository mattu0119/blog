---
title: "Azure Stack HCI で Persistent Memory を利用"
date: 2020-08-04 18:00:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Azure Stack HCI
tags: 
# - Azure Stack HCI
# - Persistent Memory
# - NVDIMM
---
## Hyper-V で NVDIMM

+ [Cmdlets for configuring persistent memory devices for Hyper-V VMs](https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/manage/persistent-memory-cmdlets/?WT.mc_id=WDIT-MVP-500270/)


## AzSHCI で NVDIMM 
AzSHCI で NVDIMM の技術情報リンクです。

+ [永続的なメモリの理解とデプロイ](https://docs.microsoft.com/ja-jp/windows-server/storage/storage-spaces/deploy-pmem/?WT.mc_id=WDIT-MVP-5002708)
    + NVDIMM ハードウェアサポート状況  

|Persistent Memory Technology|Windows Server 2016|Windows Server 2019|
|---|---|---|
|NVDIMM-N in persistent mode|Supported|Supported|
|Intel Optane™ DC Persistent Memory in App Direct Mode|Not Supported|Supported|
|Intel Optane™ DC Persistent Memory in Memory Mode|Supported|Supported|  
 
> Intel Optane は、メモリ(揮発性) モードとアプリダイレクト(永続的) モードの両方をサポートしています。

+ Windows Server 2019 with Intel Optane DC persistent memory : Microsoft Ignite 2018
     <iframe width="560" height="315" src="https://www.youtube.com/embed/8WMXkMLJORc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>  
+ [Intel® Select Solutions for Microsoft Azure Stack HCI](https://builders.intel.com/docs/select-solutions-microsoft-azure-stack-hci.pdf)
    + Memory Mode  
        メモリとして機能させるモード。メモリを購入するより GB 単価が下がる。また、アプリケーションも既存のまま利用できるのがメリット。
    + App Direct Mode  
        In-memory database, in-memory analytics frameworks, and ultrafast storage applications が利益をえることができる。App Direct Mode はアプリケーションや OS が対応していないと利用することができなし。
    + Dual Mode  
        どちらの機能も有効にできるモード。
+ [不揮発性メモリ Intel Optane DC Persistent Memory とは](https://pc.watch.impress.co.jp/docs/news/1177812.html)
    + Optane DC Persistent MemoryはDRAMと混在して利用する。同じメモリチャネルに混在させるときには、OptaneがよりCPUに近いスロットに、DRAMを遠いスロットに実装する必要がある。1つのCPUソケットに対して、最大6つまでのOptane DC Persistent Memoryのモジュールを装着できる。
+ [Configuring persistent memory for Dell EMC Azure Stack HCI](https://infohub.delltechnologies.com/l/deployment-guide-234/configuring-persistent-memory-for-azure-stack-hci-1)
    + 
+ [Boost Performance on Dell EMC Solutions for Microsoft Azure Stack HCI using Intel Optane Persistent Memory](https://infohub.delltechnologies.com/p/boost-performance-on-dell-emc-solutions-for-microsoft-azure-stack-hci-using-intel-optane-persistent-memory/)
+ Powershell コマンド
    + [Dell EMC NVDIMM-N Persistent Memory User Guide](https://www.dell.com/support/manuals/in/en/indhs1/poweredge-r940/nvdimm-n_ug_pub/powershell-cmdlets?guid=guid-325e2516-07ae-4b68-b696-009ba6d43ca1&lang=en-us)
+ [AX640 Dell EMC AX 640 Deplyoment Guide](https://topics-cdn.dell.com/pdf/azure-hci-deploy_en-us.pdf)
    + Persistent memory requirements
        + 2 x Intel Xeon Cascade Lake-SP Gold or Platinum CPUs (models 52xx, 62xx, or 82xx) per server
        + 12 x 32 GB RDIMMs in DIMM slots A1-A6 and B1-B6 (white slots) per server, totaling 384 GB of RAM per server
        + 12 x 128 GB Intel Optane DC Persistent DIMMs in DIMM slots A7–A12 and B7–B12 (black slots) per server, totaling 2 x 768 GB cache devices per server
        + Windows Server 2019 Datacenter
    + Mode
        + App Direct Interleaved
+ [PowerEdge R640 NVDIMM User's guide](https://topics-cdn.dell.com/pdf/poweredge-r740_users-guide3_ja-jp.pdf)





