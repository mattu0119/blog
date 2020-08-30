---
title: "Azure Stack HCI のボリュームをリサイズ"
date: 2020-08-28 23:00:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Azure Stack HCI
tags: 
 - Azure Stack HCI
---

こんにちは。Azure Stack HCI で CSV ボリュームをリサイズする方法をご紹介します。

## CSV ボリュームの拡張
ボリュームの拡張は簡単に実行できます。
順番としては、S2D の仮想ディスクを拡張した後に、パーティションを拡張します。
ストレージ階層を利用している場合は、手順が少し変わりますので、下記のご参照をお願いします。
+ [Extending volumes in Storage Spaces Direct](https://docs.microsoft.com/en-us/windows-server/storage/storage-spaces/resize-volumes)

### S2D 仮想ディスクの拡張
まず、仮想ディスクの拡張をします。

1. 現状の CSV を確認します。
```powershell
Get-VirtualDisk
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/ExpandVolume/1.png" class="full" width="1000">

2. 拡張するボリュームの空き容量や残りサイズなどを確認します。
```powershell
Get-VirtualDisk -Friendlyname Volume02 | Get-Disk | Get-Partition | Get-Volume
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/ExpandVolume/2.png" class="full" width="1000">

3. 拡張したいサイズに仮想ディスクを拡張します。拡張後に利用したいサイズを指定します。
```powershell
Get-VirtualDisk -Friendlyname Volume02 | Resize-VirtualDisk -Size 350GB
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/ExpandVolume/3.png" class="full" width="1000">

ディスクの管理を確認すると、仮想ディスクのサイズが 350GB になっていることが確認できます。  
拡張したサイズは未割当領域になっています。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/ExpandVolume/4.png" class="full" width="700">

次に、この未割当領域を既存パーティションに割り当てます。

### 未割当領域を既存パーティションに追加
未割当領域を、既存の CSV 領域に追加します。  
パーティションの拡張もオンラインで実施します。仮想マシンの動作にも影響ありません。

1. 下記のコマンドを実行します。
```powershell
$VirtualDisk = Get-VirtualDisk -FriendlyName Volume02
$Partition = $VirtualDisk | Get-Disk | Get-Partition | Where PartitionNumber -Eq 2
$Partition | Resize-Partition -Size ($Partition | Get-PartitionSupportedSize).SizeMax
```
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/ExpandVolume/5.png" class="full" width="1000">

2. ディスクの管理から確認すると未割当領域がなくなり、CSV 領域を拡張されたことが確認できます。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/ExpandVolume/6.png" class="full" width="700">

3. フェールオーバークラスターからも CSV 領域が拡張されたことが確認できます。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/ExpandVolume/7.png" class="full" width="700">

容量拡張は以上となります。

## CSV 容量の縮小について
残念ながら、CSV_ReFS ボリュームは縮小できないようです。

Resize-VirtualDisk コマンドで、既存容量よりもすくないサイズを指定するとサポートしていないというエラーで失敗します。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/ExpandVolume/8.png" class="full" width="1000">

また、パーティションを縮小しようとしても失敗します。
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/ExpandVolume/9.png" class="full" width="1000">

Azure Stack HCI で利用している CSV ボリュームは、簡単に拡張可能ですが縮小はできないみたいです。Azure Stack HCI の仮想ディスク回復性は変更できませんので、ボリュームを作成する場合はしっかり検討が必要です。そのため、CSV のサイズを小さめから作成して、必要に応じて拡張する方法も良いかもしれません。3 Way ミラーに変更したいけど空き容量がないからできないという状況にならない容器とつけて下さい！
