---
title: "Azure Stack HCI のメモ"
date: 2020-12-30 20:30:00 +08:00
last_modified_at: 2020-12-31 15:00:00 +08:00
categories: 
 - Azure Stack HCI
---

+ [Azure Hybrid Operations and Management Overview](https://myignite.microsoft.com/sessions/a8e1be7f-5265-414d-b53c-aa98d02d7966)

+ [Anywhere management & infrastructure with Azure Arc and Azure Stack](https://myignite.microsoft.com/sessions/10b8eccf-d7cf-49a9-8572-88d3a5381c14)

+ [Inside Azure Datacenter Architecture with Mark Russinovich](https://myignite.microsoft.com/sessions/40aca11c-8e28-4914-a6d8-b3a7efb4eee1)

+ Disaster recovery through stretch clustering with Azure Stack HCI
<iframe width="560" height="315" src="https://www.youtube.com/embed/rYnZL1wMiqU" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

+ [XSconfig - Githu](https://github.com/comnam90/xSConfig)
+ [XSconfig - Powershell Gallery](https://www.powershellgallery.com/packages/xSConfig/0.1.3)  
    SConfig の拡張機能。Azure Stack HCI は サーバーコアと同じ CLI のため、コンソールから S2D の状態や情報を取得したいときに便利です。インストール方法は非常に簡単で、インターネット接続環境であれば下記のコマンドを実行するだけです。インターネット非接続の場合は Powershell Gallery からモジュールをダウンロードして利用できます。
    ```powershell
    Install-Module XSconfig
    Import-Module XSConfig
    # XSconfig を実行するには下記のコマンドを実行します。
    Invoke-XSconfig
    ```
    1. コマンドを実行してモジュールのインストールと実行します。   
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/XSconfig/1.png" class="full" width="600">
    1. `16` に `Exstras` が表示されるので、それを実行します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/XSconfig/2.png" class="full" width="600">
    1. S2D の3つの状態を確認できます。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/XSconfig/3.png" class="full" width="600">
    1. 1つめは Storage Pool の状態です。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/XSconfig/4.png" class="full" width="600">
    1. 2つめは Virtual Disk の状態です。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/XSconfig/5.png" class="full" width="600">
    1. 3つめは Cluster Node の状態です。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/XSconfig/6.png" class="full" width="600">
    
    XSconfig はまだ作成途中で、利用のアイディア募集中ということなので、便利な機能が追加されることを楽しみに待ちましょう。
    開発者のブログに詳細がありますので、ぜひご参照ください。  
    + [Extending SConfig in Azure Stack HCI 20H2](https://bcthomas.com/2020/09/extending-sconfig-in-azure-stack-hci-20h2/)
