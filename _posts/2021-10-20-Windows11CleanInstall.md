---
title: "Hyper-V 仮想マシンに Windows 11 をクリーンインストール"
date: 2021-10-20 23:00:00 +08:00
last_modified_at: 2021-10-20 09:45:00 +08:00
categories:
- Windows 11
---

こんにちは。
今回は Hyper-V 仮想マシンに Windows 11 をクリーンインストールしてみます。

Windows 11 のシステム要件に CPU や TPM2.0 などがあり、古いPC や Hyper-V ホストの仮想マシンには簡単にインストールできません。
今回は CPU や TPM のシステム要件をスキップしてインストールする方法を試してみます。

# Windows11 のシステム要件

Windows11 のシステム要件はこちらから参照できます。
+ [システム要件](https://www.microsoft.com/ja-jp/windows/windows-11-specifications)

UEFI、セキュアブートや TPM など仮想マシンで要件達成するのは結構難しいかもしれません。

# Windows11 の ISO ファイル
Windows11 の ISO ファイルはこちらで提供されています。

+ [Windows11 インストールメディア](https://www.microsoft.com/ja-jp/software-download/windows11)

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/Upgrade/5.png" class="full" width="900">

もし Visual Studio Subscription をお持ちの場合は、そちらからもダウンロードが可能になっています。

+ [My Visual Studio Subscription](https://my.visualstudio.com/)

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/Upgrade/14.png" class="full" width="900">

Github に Windows OS の ISO や USB Boot メディアを作成するための便利なスクリプトファイルが提供されています。
ぜひこちらも試してみてください。

+ [MediaCreationTool.bat](https://github.com/AveYo/MediaCreationTool.bat)

Github で公開されている MedhiaCreationTool.bat ファイルを実行することで、簡単に ISO や USB Boot イメージを作成することができます。

# Windows 11 のクリーンインストール

Windows 11 の ISO ファイルを準備したら、仮想マシンにインストールしましょう。

まず、仮想マシンを準備します。第2世代の仮想マシンを作成してください。
第2世代の仮想マシンは、UEFI、セキュアブートの要件を満たす構成となります。

仮想マシンを作成したら、Windows 11 ISO をマウントして、ISO ファイルからブートします。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/2.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/3.png" class="full" width="900">

ISO ブートが完了したら、**Shit + F10 ** を押下します。するとコマンドプロンプトが起動します。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/4.png" class="full" width="900">

コマンドプロンプトから Windows11 の要件である CPU や TPM2.0 の要件をバイパスするレジストリを追加するコマンドを実行します。
仮想マシンコンソールのクリップボードから入力をクリックすることで、コピペすることができます。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/5.png" class="full" width="900">


```Powershell
reg add HKLM\SYSTEM\Setup\MoSetup /v AllowUpgradesWithUnsupportedTPMOrCPU /t REG_DWORD /d 1 /f
reg add HKLM\SYSTEM\Setup\LabCOnfig /v BypassTPMCheck /t REG_DWORD /d 1 /f
```

なお、セキュアブートのシステム要件もバイパスしたい場合は下記のコマンドによりレジストリを追加すれば OK です。
```Powershell
reg add HKLM\SYSTEM\Setup\LabCOnfig /v BypassSecureBootCheck /t REG_DWORD /d 1 /f
```

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/6.png" class="full" width="900">

レジストリの設定確認については、こちらのコマンドで実施してください。
```Powershell
reg query HKLM\SYSTEM\Setup\MoSetup
reg query HKLM\SYSTEM\Setup\LabCOnfig
```

レジストリの追加が完了したら Windows セットアップウィザードを進めて Windows 11 をインストールします。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/7.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/8.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/9.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/10.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/11.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/12.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/13.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/14.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/15.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/16.png" class="full" width="900">

地域を選択して、

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/17.png" class="full" width="900">

キーボードレイアウトを選択して、

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/18.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/19.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/20.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/21.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/22.png" class="full" width="900">

セキュリティの質問を設定して、

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/23.png" class="full" width="900">

プライバシー設定に同意して、

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/24.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/25.png" class="full" width="900">

もう少し待てば、

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/26.png" class="full" width="900">

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/27.png" class="full" width="900">

Windows 11 のインストールが完了します。

<img src="{{ site.url }}{{ site.baseurl }}/assets/images/Windows11/CleanInstall/29.png" class="full" width="900">

Windows11 のシステム要件を満たしていないハードウェアで利用する場合は、更新プログラムやトラブル時のサポートを受けられない可能性があります。
この手順で実施する場合は、その注意点を承諾して利用するということになりますので、重要な用途で利用する場合はサポートされる構成で利用してください。

+ [最小システム要件を満たしていないデバイスに Windows 11 をインストールする](https://support.microsoft.com/ja-jp/windows/%E6%9C%80%E5%B0%8F%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E8%A6%81%E4%BB%B6%E3%82%92%E6%BA%80%E3%81%9F%E3%81%97%E3%81%A6%E3%81%84%E3%81%AA%E3%81%84%E3%83%87%E3%83%90%E3%82%A4%E3%82%B9%E3%81%AB-windows-11-%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B-0b2dc4a2-5933-4ad4-9c09-ef0a331518f1)


`この PC は、Windows 11 を実行するための最小システム要件を満たしていません。これらの要件は、より信頼性が高く、より高品質のエクスペリエンスを保証するのに役立ちます。 この PC に Windows 11 をインストールすることはお勧めできません。互換性の問題が発生する可能性があります。 Windows 11 のインストールを続行すると、PC はサポートされなくなり、更新プログラムを受け取る資格がなくなります。 互換性の欠如による PC の損傷は、製造元の保証の対象外です。`


# まとめ
Hyper-V 仮想マシンにも問題なくWindows 11 をインストールできることを確認できました。CPU や TPM がサポートされない構成の場合に試してみてください。
試してみた手順は Youtube で紹介されている手順を参考に実施しました！

<iframe width="560" height="315" src="https://www.youtube.com/embed/_-b4oVF_ny0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


