---
title: "Azure Stack HCI の Storage Tier の有効化"
date: 2020-11-20 15:00:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Azure Stack HCI
 - Storage Spaces Direct
---

Azure Stack HCI は Storage Spaces Direct を利用した HCI の仮想基盤です。HDD や SSD など複数の種類のディスクを搭載した構成の場合は、高速ディスクをキャッシュ、低速ディスクをキャパシティとして構成することや、ストレージ階層を利用した階層ストレージ構成にすることもできます。

* [ドライブの種類](https://docs.microsoft.com/ja-jp/windows-server/storage/storage-spaces/choosing-drives#drive-types/?WT.mc_id=WDIT-MVP-5002708)

## ディスク構成
今回は下記のディスク構成の場合、どれくらい容量の違いがあるかを比較してみました。

* 300GB SSD × 4本
* 600GB HDD × 4本
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/StorageTier/2.png" class="full" width="600"> 

## キャッシュ構成の場合
Storage Space Direct を構成するには、フェールオーバークラスター作成後に下記のコマンドを実行します。
```powershell
Enable-ClusterS2D
```
SSD 4本 をキャッシュとした構成では、2.3TB のストレージプールサイズとなりました。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/StorageTier/1.png" class="full" width="600"> 

キャパシティとしては、2Way ミラーディスク構成の場合、約1TB のキャパシティを利用できる計算になります。

## ストレージ階層の場合
ストレージ階層は、SSD を高速階層、HDD を低速階層として2つの階層をキャパシティとして利用できる構成です。ディスクが2種類の場合、キャッシュを構成することができないので、S2D を有効化するときに キャッシュ機能を無効化する必要があります。

```powershell
Enable-ClusterS2D -CacheState Disabled
```
SSD と HDD すべてのディスクをキャパシティとして利用できるため、ストレージプールは 3.2TB となります。だいたい 1TB ほどのキャパシティが増えました。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/StorageTier/5.png" class="full" width="600"> 


ストレージ階層の仮想ディスクを作成するにはこちらのコマンドを実行する必要があります。
```powershell
New-Volume -FriendlyName "Volume1" -FileSystem CSVFS_ReFS -StoragePoolFriendlyName S2D* -StorageTierFriendlyNames Performance, Capacity -StorageTierSizes 500GB,1000GB -ResiliencySettingName mirror -PhysicalDiskRedundancy 1
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/StorageTier/6.png" class="full" width="600"> 

このコマンドで、SSD の高速階層は 500GB、HDDの低速階層は 1TB、合計1.5TB のストレージが構成されたことがわかります。

SSD と HDD でどれくらい容量を消費したかは、こちらで確認できます。
```powershell
Get-StorageTier
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/StorageTier/4.png" class="full" width="800"> 

## まとめ
検証環境などで利用する場合、容量をなるべく多く確保したいですよね。既定で S2D を有効化すると、キャッシュ構成になりますので、`-CacheState Disabled` を追加して階層化ストレージを利用することも検討してみてください！
