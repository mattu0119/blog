---
title: "仮想マシンにパススルー接続した NVMe SSD の無効化"
date: 2021-02-22 14:00:00 +08:00
#last_modified_at: 2021-01-02 11:00:00 +08:00
categories: 
 - Azure Stack HCI
tags:
 - DDA
 - Discrete Device Assignment
 - 個別のデバイス割り当て
---

こんにちは。今回は DDA で仮想マシンにパススルー接続した NVMe SSD を Hyper-V ホストに接続しなおししてみます。  

<iframe width="560" height="315" src="https://www.youtube.com/embed/O2lijeRQ3g0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Hyper-V ホストに NVMeデバイスを戻す場合は、下記の順番で実施します。  
1. 仮想マシンに接続したデバイスの *場所のパス* を確認
1. 仮想マシンをシャットダウン
1. Hyper-V ホストでコマンドを実行してNVME デバイスを Hyper-V ホストに接続

## 仮想マシンに接続したデバイスの *場所のパス* の確認
仮想マシンに接続したデバイス情報を確認するには、下記のコマンドを実行します。

```powershell
Get-VMAssignableDevice -VMName <仮想マシン名>
```
このコマンド結果から、`LocationPath` を確認してください。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/DDA-Disable/1.png" class="full" width="600">

## NVMe デバイスを Hyper-V ホストに戻す
先ほど仮想マシンに接続している NVMe デバイスの `LocationPath` を確認したので、そのデバイスを Hyper-V ホストに接続しなおします。

1. 仮想マシンをシャットダウンします。
1. 仮想マシンに接続している NVMe デバイスを解除します。
    ```powershell
    Remove-VMAssignableDevice -LocationPath "PCIROOT(85)#PCI(0200)#PCI(0000)" -VMName VM1
    ```
1.  Hyper-V ホストにデバイスをアサインできるか確認します。
    ```powershell
    Get-VMHostAssignableDevice
    ```
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/DDA-Disable/2.png" class="full" width="600">
1. Hyper-V ホストに NVMe デバイスをアサインします。
    ```powershell
    Mount-VMHostAssignableDevice -LocationPath "PCIROOT(85)#PCI(0200)#PCI(0000)"
    ```
    このコマンドを実行すると、Hyper-V ホストのデバイスマネージャーから、NVMe デバイスが見えるようになります。  
        <img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/DDA-Disable/3.png" class="full" width="600">
1. アサインしなおした NVMe デバイスを有効にします。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/DDA-Disable/4.png" class="full" width="600">

これで無事に NVMe デバイスを Hyper-V ホストに接続しなおしできました。

# まとめ
DDA を利用することで、NVMe デバイスを柔軟に仮想マシンに接続/切断をできるのが便利ですね。
仮想マシンでストレージパフォーマンスを求める際の構成として、是非検討いただければと思います。








