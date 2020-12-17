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
OMEnt と AD を連携する場合、以下の環境が必要です。
* Active Directory で LDAPS の利用が必要
* LDAPS の利用に証明書が必要
* OpenManage Enterprise にアクセスさせたいユーザーを AD のセキュリティグループに追加
* OpenManage Enterprise は最新のバージョンを利用
 
# LDAPS の有効化
OMEnt に AD ユーザーでログインする場合、Active Directory で LDAPS を有効にする必要があります。そのため、ご利用の Active Directory で LDAPS が有効になっていない場合は、こちらの手順から LDAPS を有効にしてください。

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
* [How to Request a Certificate With a Custom Subject Alternative Name](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/ff625722(v=ws.10)?redirectedfrom=MSDN#BKMK_CreateInf/?WT.mc_id=WDIT-MVP-5002708)

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
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/10.png" class="full" width="600">

## 4. OMEnt にインポートするセキュリティグループの作成
OMEnt にログインを許可するセキュリティグループを作成します。Active Directory ユーザーとコンピューターから作成してください。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/11.png" class="full" width="600">

私の環境では、`OMEAdmins` というセキュリティーグループに `User1` というユーザーを所属させました。

## 5. OMEnt にAD ディレクトリの追加
AD に OMEnt に追加するユーザーやグループを準備したら、OMEntに AD の情報を登録します。

1. OMEnt にローカルユーザーでログインします。
1. OMEnt のアプリケーション設定から操作します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/12.png" class="full" width="600">
1. ユーザータブからディレクトリサービスを選択し、追加をクリックします。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/13.png" class="full" width="600">
1. AD の情報を記入し、テスト接続を選択します。
    LDAPSで Active Directory にアクセスするため、ポート番号は 636 に変更してください。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/14.png" class="full" width="600">
1. テスト接続する AD のユーザー情報を指定し、テスト接続を実行します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/15.png" class="full" width="600">
1. `テスト接続は正常に完了しました。` と表示されれば、OMEnt から AD に接続できる状態と確認できます。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/16.png" class="full" width="600">
1. テスト接続が完了したら、「完了」 をクリックしてAD の接続情報を登録します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/17.png" class="full" width="600">
1. ディレクトリが登録されたことが確認できます。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/18.png" class="full" width="600">

## 6. OMEnt にセキュリティグループをインポート
最後に、AD に作成した AD ユーザーを OMEnt にインポートします。ユーザーをインポートすることで、OMEnt に ADユーザーでログインできるようになります。

1. ユーザータブからディレクトリグループのインポートをクリックします。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/19.png" class="full" width="600">
1. ディレクトリのインポートで、先ほど追加したディレクトリを選択します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/20.png" class="full" width="600">
1. AD にアクセスする資格情報を求められますので、ユーザー情報を入力します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/21.png" class="full" width="600">
1. OMEnt にインポートするユーザーやグループ名を検索し、矢印をクリックして インポートするグループに追加します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/22.png" class="full" width="600">  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/23.png" class="full" width="600">
1. インポートするグループに割り当てる役割を選択し、割り当てをクリックすることで選択した権限が付与されます。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/24.png" class="full" width="600">
1. インポートをクリックして指定したユーザーやグループがインポートされたことを確認します。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/25.png" class="full" width="600">
1. OMEnt にAD ユーザーでログインできるか確認してください。  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/26.png" class="full" width="600">  
    <img src="{{ site.url }}{{ site.baseurl }}/assets/images/OMEnt/ADIntegration/27.png" class="full" width="600">  

#  まとめ
OMEnt に AD ユーザーでログインさせるには、LDAPS の有効化など実施する必要があるためすこし難しいです。
ただ、ユーザー管理をシンプルにできるため便利かもしれないですね。




