---
title: "Migrating Server Infrastructure ウェビナー"
date: 2020-09-05 13:30:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Windows Server
 - Azure
tags: 
 - Migration
 - Management
---

# Migrating Server Infrastructure ウェビナー
いつまで公開されているかわかりませんが、こちらからトレーニングを参照できます。
それぞれのトレーニングは 45分程です。

[Microsoft Azure Virtual Training Day: Migrating Server Infrastructure](https://event.on24.com/eventRegistration/console/EventConsoleApollo.jsp?simulive=y&eventid=2506839&sessionid=1&username=&partnerref=&format=fhvideo1&mobile=false&flashsupportedmobiledevice=false&helpcenter=false&key=BCE0DB59439E92DAA35FE48F30C3DB7A&text_language_id=ja&playerwidth=1000&playerheight=650&overwritelobby=y&newConsole=true&nxChe=true&eventuserid=347146125&contenttype=A&mediametricsessionid=296858159&mediametricid=3530966&usercd=347146125&mode=launch#)

こちらの英語のトレーニングが情報元になっているということです。
+ aka.ms/MSI10
    + MSI10: Windows Server 2019 への移行
+ aka.ms/MSI20
    + MSI20：クラウドテクノロジの統合
+ aka.ms/MSI30
    + MSI30：IaaS ワークロードの Azure への移行

本投稿は、MSI10 の内容を簡単にまとめたものになります。

# Windows Server 2019 へ移行 のトレーニング
aka.ms/MSI10

## 古い OS を確認する方法
### 1. AD 管理センターからクエリをなげる
1. AD 管理センターを開き、グローバル検索で **LDAP に変換** を選択
1. **LDAPクエリ入力** にクエリを入力し **「適用」** をクリック  
例) OperatingSystem=*2008*
3. 結果を確認

### 2. Powershell で確認
Get-ADComputer -filter {OperationgSystem -Like "*2008*"} -properties * | ft Name, OperatingSystem

## その他の移行ツール
+ AD 関連の検索ツール
    + [Sysinternals AD Explorer ツール](https://aka.ms/sysinternalsAD)
    + [ADSI の ”Fun Stuff”](https://aka.m/ADSIsearch)
+ 無料の Migration 向けツール
    + [Microsoft Assessment and Plannint rool](https://aka.ms/AssessmentToolkit)
        + オンプレミスにインストールする必要がある。
        + オンプレミスの Windows や Linux の一覧を作成できるツール
        + AD で検索したり、IP アドレスレンジを指定して情報収集できるツール。
        + 結果は Excel に一覧で表示される。OS バージョンなども含まれる。
        + 役割が入っている内容も確認できる。
    + [Azure Migrate](https://aka.ms/CoolAzureMigrate)
+ 3rd Party ツール
    + [Microfot Migration Journey アセスメント](https://aka.ms/MigrateAssessment)

## サポート終了に対処するためのオプション
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzureMigration/MSI10/1.png" class="full" width="1000">

## AD 移行
https://aka.ms/MigrateAD

### AD の仮想化には Shielded VM
承認された Hyper-V ホストのみで稼働することができる。承認されていないホストに仮想マシンデータを移動しても起動できない、VHDファイル内のデータも見れないセキュリティの機能。
https://aka.ms/DCShieldedVM
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/AzureMigration/MSI10/2.png" class="full" width="1000">

## ストレージマイグレーションサービス (記憶域の移行サービス)
オンプレミスの古いOS などから Windows Server、Azure Stack IaaS、Azure File Sync などへ移行できるサービス。
+ ステップ
1. インベントリ：古いサーバーの情報を収集
1. 転送：インベントリからソースと宛先のペアを作成し、データを転送
1. カットオーバー：古いホスト名あら新しいホスト名に引継ぎ

WAC を利用して、GUI ベースでファイルサーバーの移行をできる。
   + [Storage Migration Service を使用してサーバーを移行する](https://docs.microsoft.com/ja-jp/windows-server/storage/storage-migration-service/migrate-data)

以上となります。

