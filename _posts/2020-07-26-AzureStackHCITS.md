---
title: "Azure Stack HCI のクラスター検証エラー"
date: 2020-07-26 00:00:00 -0000
categories: 
 - AzureStack
tags: 
 - HCI
---

# Azure Stack HCI を WAC から構成する際にクラスター検証でエラーで進めない事象

## Azure Stack HCI 20H2 について
先週開催された Micosoft Inspire 2020 で、Azure Stack HCI Version 20H2 が発表されました。
+ [ハイブリッド クラウドを可能にする次世代の Azure Stack HCI を発表](https://azure.microsoft.com/ja-jp/blog/deliver-hybrid-cloud-capabilities-with-the-next-generation-of-azure-stack-hci/?fbclid=IwAR17txajhgSvuxmB_Pb9WPh0w21BS7VsrpmVX6Pyzh64njCcud5emy36aVw)

HCI の機能に特化した新しい HCI 用の OS が Public Preview となりました。

また、同じタイミングで Windows Admin Center は **Version 2007** がリリースされました。
+ [Windows Admin Center version 2007 is now generally available!](https://techcommunity.microsoft.com/t5/windows-admin-center-blog/windows-admin-center-version-2007-is-now-generally-available/ba-p/1536215)

新しい Azure Stack HCI と Windows Admin Center は下記の評価ガイドのシナリオを参考に効率よく検証することが可能です。

+ [Azure Stack HCI Evaluation Guide](https://github.com/Azure/AzureStackHCI-EvalGuide)

評価ガイドが提供されています。Nested on Physical で構成してみましたが、クラスラー検証でエラーになりました。
同じエラーに遭遇した際に参考いただければと思います。

## クラスター検証のエラーについて
さっそく試してみたのですが、評価ガイド ステップ 4 のクラスター検証でエラーとなり次に進めない事象に遭遇しました。
+ [Create nested Azure Stack HCI cluster with Windows Admin Center](https://github.com/Azure/AzureStackHCI-EvalGuide/blob/main/nested/steps/4_AzSHCICluster.md)


+ クラスターの検証でエラー
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/azshci/1.png" alt="" class="full" width="800">


