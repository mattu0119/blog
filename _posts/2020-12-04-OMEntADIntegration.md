---
title: "Dell OpenManage Enterprise と Active Directory 連携"
date: 2020-12-04 23:00:00 +08:00
last_modified_at: 2020-12-16 09:00:00 +08:00
categories: 
 - Active Directory
 - Dell OpenManage Enterprise
---
# はじめに
Dell ハードウェア監視ソフトウェアの OpenManage Enterprise と Active Directory 連携することで、AD ユーザーで OpenManage Enterprise にログインすることができます。  
今回は、OMEnt と AD を連携後に OMEnt に ADユーザーをインポートし、AD ユーザーで OMEnt へ管理者としてログインする方法をご紹介します。

## AD 連携の条件
* Active Directory で LDAPS の利用が必要
* LDAPS の利用に証明書が必要
* OpenManage Enterprise にアクセスさせたいユーザーを AD のセキュリティグループに追加
* OpenManage Enterprise は最新のバージョンを利用
 
# LDAPS の有効化
OMEnt に AD ユーザーでログインする場合、Active Directory で LDAPS を有効にする必要があります。

## 1. LDAPS の状況確認
LDAPS が有効になっているかどうかは、LDP.exe を実行することで確認できます。

1. LDP.exe を起動します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/1.png" class="full" width="600"> 
1. 「接続」でサーバー名とポート番号を入力し、SSL を選択して OK を実行します。  
     <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/2.png" class="full" width="600"> 
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/4.png" class="full" width="600">   
1. LDAPS が有効になっている場合は、接続結果が表示されます。無効の場合はエラーが表示されます。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/5.png" class="full" width="600">   

## 2. LDAPS の有効化
LDAPS を有効にするには、ADCS から発行した証明書を利用することができます。  

こちらを参考に LDAPS を有効化します。  
* [サードパーティの証明機関を使用して LDAP over SSL を有効にする](https://docs.microsoft.com/ja-jp/troubleshoot/windows-server/identity/enable-ldap-over-ssl-3rd-certification-authority#verify-an-ldaps-connection/?WT.mc_id=WDIT-MVP-5002708)  

LDAPS に関してはこちらに詳しく記載されています。  
* [LDAP over SSL (LDAPS) Certificate](https://social.technet.microsoft.com/wiki/contents/articles/2980.ldap-over-ssl-ldaps-certificate.aspx)  

INF ファイルの詳細はこちらからご確認ください。
* [How to Request a Certificate With a Custom Subject Alternative Name](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/ff625722(v=ws.10)?redirectedfrom=MSDN#BKMK_CreateInf)

今回は、 ADCA から発行した証明書を利用します。

1. 証明書要求を作成する INF ファイルを作成します。  
    INF ファイルを GIST にアップロードしましたので、参考になればと思います。Subject を AD のFQDN に書き直してください。
    * [INFファイル](https://gist.github.com/mattu0119/58785b2420923f416a0f5ac123412981)  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/5.png" class="full" width="600"> 
1. certreq コマンドで証明書要求ファイルを作成します。
    ```Powershell
    certreq -new <INFファイルパス> <証明書要求ファイルパス>
    ```
    こんな感じのコマンドを実行して証明書要求ファイルを作成します。
    ```powershell
    certreq -new c:\tmp\Request.inf c:\tmp\Request.req
    ```
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/6.png" class="full" width="600">
1. 証明機関から「すべてのタスク」―「新しい要求の送信」 を選び、さきほど作成した Request.req ファイルを送信します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/7.png" class="full" width="600">
1. 発行する証明書名を入力して、証明書ファイルを発行します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/8.png" class="full" width="600">
1. 下記のコマンドを実行して、証明書をインストールします。
    ```powershell
    certreq -accept ldaps.cer
    ```
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/9.png" class="full" width="600">
1. 証明書がインストールされたか、mmc から確認します。

## 3. LDAPS が有効の確認
LDP.exe を利用して確認します。
 
1. LDP.exe を起動します。
1. 「接続」でサーバー名とポート番号を入力し、SSL を選択して OK を実行し、LDAPS 接続できることを確認します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/9.png" class="full" width="600">

## 4. OMEnt にAD ディレクトリの追加
OMEnt に


## 5. OMEnt にインポートするセキュリティグループの作成



## 6. OMEnt にセキュリティグループをインポート




