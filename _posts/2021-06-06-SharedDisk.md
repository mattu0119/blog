---
title: "Azure 共有ディスクの利用"
date: 2021-06-06 23:00:00 +08:00
#last_modified_at: 2021-01-02 11:00:00 +08:00
categories: 
 - Azure
#tags:
#- Managed Disks
---

## Azure 共有ディスクとは

Azure 共有ディスクは、2020年7月に GA したストレージサービスです。
> これにより、高速フェールオーバーや高可用性のために既知のデプロイ パターンを損なうことなく、クラスター化されたデータベース、並列ファイル システム、永続コンテナー、機械学習アプリケーションなどの最も要求の厳しいエンタープライズ アプリケーションをクラウドで実行することができます。

⁺ [Azure Disk Storage の共有ディスクを使用できるようになりました](https://azure.microsoft.com/ja-jp/updates/shared-disks-in-azure-disk-storage-are-now-available/)

## Azure 共有ディスクの要件
2021年6月時点では下記2種類のディスクで共有ディスクを有効にすることができます。

1. [Ultra ディスク](https://docs.microsoft.com/ja-jp/azure/virtual-machines/disks-shared#ultra-disks)
1. [Premium SSD](https://docs.microsoft.com/ja-jp/azure/virtual-machines/disks-shared#premium-ssds)

共有ディスクの利用には、サポートされるディスクの種類やパフォーマンスなどの制約事項がいくつかありますので、こちらを参照してください。

⁺ [制限事項](https://docs.microsoft.com/ja-jp/azure/virtual-machines/disks-shared#limitations)


## 共有ディスクの作成
Azure ポータルからディスクを作成します。
共有ディスクは、作成するディスクサイズにより有効にできるかどうかが決まっています。
また、リージョンによって有効にできる共有ディスクのサイズ（256GB か 512GB から）に違いがあるので注意してください。

⁺ 東日本  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/SharedDisk1/JapanEast.png" class="full" width="600">

⁺ 米国東部2  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/SharedDisk1/EastUS2.png" class="full" width="600">


共有ディスクの有効化は、**マネージドディスクの作成** ウィザードで、「共有ディスクを有効にする」を 「はい」 にするだけで利用できるようになります。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/SharedDisk1/Enable.png" class="full" width="600">

もしくは、仮想マシン作成時に新しいディスクを作成する際に、有効にすることもできます。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/SharedDisk1/VM1.png" class="full" width="600">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/SharedDisk1/VM2.png" class="full" width="600">

仮想マシン作成後、Windows Server であればディスクの管理から、接続したディスクをフォーマットして共有ディスクとして利用をすることができます。

この共有ディスクを利用して、Azure VM 上に Windows Failover Cluster をインストールし、SQL インスタンスを冗長したり、ファイルサーバーのリソースとして利用することができます。

## 既存ディスクで共有ディスクを有効にする
すでに作成したマネージドディスクに対して、共有ディスクを有効にすることもできます。

共有ディスクを有効にできるのは、Premium SSD か Ultra ディスクです。もしそれ以外の Standard HDD や SSD を利用している場合は、Premium SSD に変更してください。

既存ディスクの SKU 変更も Azure ポータルから実施できます。
1. まず、仮想マシンからディスクを切断します。  
    ※ 仮想マシンの停止では、共有ディスクを有効にできません。
1. 次に「サイズおよびパフォーマンス」 から Premium SSD に変更し、共有ディスクがサポートされているサイズとパフォーマンスを選択します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/SharedDisk1/VM3.png" class="full" width="600">
1. 念のため、ディスクサイズが変更されたことを確認します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/SharedDisk1/VM4.png" class="full" width="600">
1. Cloud Shell を Powershell で起動します。
1. このコマンドを発行し、共有ディスクが有効になっているか確認します。MaxShares の値に何もなければ、共有ディスクが有効になっていない状態です。
    ```Powershell
    Get-AzDisk -ResourceGroupName <リソースグループ名> -Name <ディスク名> | select MaxShares
    ```
    わたしの環境ではこのように確認しました。
    ```Powershell
    PS /> Get-AzDisk -ResourceGroupName Spoke01-RG -Name disk1 | select MaxShares

    MaxShares
    ---------
    ```
1. このコマンドで共有ディスクを有効にします。
    ```Powershell
    New-AzDiskUpdateConfig -MaxSharesCount 2 | Update-AzDisk -ResourceGroupName <リソースグループ名> -DiskName <ディスク名>
    ```
    わたしの環境ではこのように実行しました。
    ```Powershell
    PS /> New-AzDiskUpdateConfig -MaxSharesCount 2 | Update-AzDisk -ResourceGroupName 'spoke01-rg' -DiskName "disk1"

    DiskSizeGB                   : 512
    DiskIOPSReadWrite            : 2300
    DiskMBpsReadWrite            : 150
    DiskState                    : Unattached
    MaxShares                    : 2
    Name                         : disk1
    Location                     : japanwest
    NetworkAccessPolicy          : AllowAll
    Tier                         : P20
    ```
1. コマンドの実行結果から `MaxShares` の値が2に変更されれば、共有ディスクの有効化は完了です。
1. 仮想マシンにマネージドディスクを接続し、クラスターなどの作成に進んでください！  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/Azure/SharedDisk1/VM5.png" class="full" width="600">

## まとめ
Azure VM でクラスターを作成するには Storage Spaces Direct (S2D) を利用する必要がありましたが、共有ディスクを利用することで簡単に共有ストレージを利用することができるようになります。
Azure VM でクラスターを作成したサービスを構成したい場合、ぜひ利用してみてください！
