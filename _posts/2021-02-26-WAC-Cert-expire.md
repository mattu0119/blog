---
title: "Windows Admin Center の証明書切れによる証明書の更新"
date: 2021-02-26 22:00:00 +08:00
#last_modified_at: 2021-01-02 11:00:00 +08:00
categories: 
 - Windows Admin Center 
 - WAC
 - Certificate
 - 証明書
---
こんにちは。  
今日 Windows Admin Center を開いたら、アプリケーションをブートストラップしています の画面から遷移しない状態となりました。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/WAC/Certificate/1.png" class="full" width="600">

何度か更新したら WAC は正常に開いたのですが、よく見てみたら WAC インストール時に作成される90日間の自己証明書の有効期限が切れていました。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/WAC/Certificate/2.png" class="full" width="600">

そのため、今回は自己証明書を作成して有効期限の長い自己証明書を作成します。

手順の動画はこちらから参照ください！



## 自己証明書の作成
自己証明書の作成は下記のコマンドから実行可能です。`New-SelfSignedCertificate` の `Subject` や `DnsName` はご自身の環境や好みに合わせて修正してください。

```powershell
# Make a self signed certificate for WAC.
  $Cert = New-SelfSignedCertificate -Subject "Windows Admin Center" -DnsName "ma-wac2012","ma-wac2012.mhiro.net" -CertStoreLocation "cert:\LocalMachine\My" -KeyAlgorithm RSA -KeyLength 2048 -KeyExportPolicy Exportable -NotAfter (Get-Date).AddYears(10)
  $Certfile = "c:\temp\cert.cer"
  mkdir c:\temp
  Export-Certificate -Cert $cert -FilePath $Certfile
  Import-Certificate -FilePath $Certfile -CertStoreLocation "cert:\LocalMachine\Root"
```

このコマンドの結果の中に、証明書の `Thumbprint` が表示されますので、メモをしてください。  
<img src="{{ site.url }}{{ site.baseurl }}/assets/images/WAC/Certificate/3.png" class="full" width="600">

## WAC の証明書を変更する
WAC の証明書は、プログラムの削除と追加から変更することができます。

1. コントロールパネルからプログラムのアンインストールを開きます。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/WAC/Certificate/4.png" class="full" width="600">
1. 次に Windows Admin Center を選択し、変更をクリックします。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/WAC/Certificate/5.png" class="full" width="600">
1. 次へ を押してウィザードを進め、変更 を選択すると、証明書を指定するウィザードになります。先ほどメモした 拇印を指定します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/WAC/Certificate/6.png" class="full" width="600">
1. 変更処理が進み、セットアップウィザードが完了すれば作業は終了です。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/WAC/Certificate/7.png" class="full" width="600">
1. インターネットブラウザを更新して WAC の証明書を確認します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/WAC/Certificate/8.png" class="full" width="600">

## まとめ
今回は自己証明書を利用しましたが、CA から発行した証明書に変更する手順も同じです。証明書の期限に気を付けて、WAC を利用しましょう！

