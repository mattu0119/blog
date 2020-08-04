---
title: "Azure Stack HCI で Persistent Memory を利用"
date: 2020-08-04 18:00:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Microsoft 
tags: 
 - Azure Stack HCI
 - Persistent Memory
 - NVDIMM
---
# Azure Stack HCI で Persistent Memory を利用する Tips 集

1. [永続的なメモリの理解とデプロイ](https://docs.microsoft.com/ja-jp/windows-server/storage/storage-spaces/deploy-pmem)
+ NVDIMM ハードウェアサポート状況  
|Persistent Memory Technology|Windows Server 2016|Windows Server 2019|
|----|----|----|
|NVDIMM-N in persistent mode|Supported|Supported|
|Intel Optane™ DC Persistent Memory in App Direct Mode|Not Supported|Supported|
|Intel Optane™ DC Persistent Memory in Memory Mode|Supported|Supported|

1. Windows Server 2019 with Intel Optane DC persistent memory | Microsoft Ignite 2018
<iframe width="560" height="315" src="https://www.youtube.com/embed/8WMXkMLJORc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

1. [Intel® Select Solutions for Microsoft Azure Stack HCI](https://builders.intel.com/docs/select-solutions-microsoft-azure-stack-hci.pdf)
+ Memory Mode
    メモリとして機能させるモード。メモリを購入するより GB 単価が下がる。また、アプリケーションも既存のまま利用できるのがメリット。
+ App Direct Mode
    In-memory database, in-memory analytics frameworks, and ultrafast storage applications が利益をえることができる。App Direct Mode はアプリケーションや OS が対応していないと利用することができなし。
+ Dual Mode
    どちらの機能も有効にできるモード。
1. [不揮発性メモリ Intel Optane DC Persistent Memory とは](https://pc.watch.impress.co.jp/docs/news/1177812.html)
    + Optane DC Persistent MemoryはDRAMと混在して利用する。同じメモリチャネルに混在させるときには、OptaneがよりCPUに近いスロットに、DRAMを遠いスロットに実装する必要がある。1つのCPUソケットに対して、最大6つまでのOptane DC Persistent Memoryのモジュールを装着できる。
1. [Configuring persistent memory for Dell EMC Azure Stack HCI](https://infohub.delltechnologies.com/l/deployment-guide-234/configuring-persistent-memory-for-azure-stack-hci-1)
1. [Boost Performance on Dell EMC Solutions for Microsoft Azure Stack HCI using Intel Optane Persistent Memory](https://infohub.delltechnologies.com/p/boost-performance-on-dell-emc-solutions-for-microsoft-azure-stack-hci-using-intel-optane-persistent-memory/)
1. Powershell コマンド
    1. [Dell EMC NVDIMM-N Persistent Memory User Guide](https://www.dell.com/support/manuals/in/en/indhs1/poweredge-r940/nvdimm-n_ug_pub/powershell-cmdlets?guid=guid-325e2516-07ae-4b68-b696-009ba6d43ca1&lang=en-us)
    1. 



