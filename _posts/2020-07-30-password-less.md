---
title: "パスワードレスの価値と仕組み"
date: 2020-07-30 13:00:00 -0000
categories: 
 - Azure
#tags: 
# - Passwordless
# - Azure AD
---
http://aka.ms/AzureAdWebinar

+ パスワードでは守れない
81% が盗まれたパスワードから情報漏洩している。
複雑なパスワードでも攻撃は防げない
+ https://jpazureid.github.io/azure-active-directory/your-password-doesnt-matter/
    + 防いだり時間を稼いだりするはできるが、完全ではない

+ パスワード漏洩からの影響

+ 多要素認証
多要素認証を有効化すると防げる攻撃が増える。
デバイスの管理や利便性が下がる
パスワードレスを利用すると、利便性とセキュリティが高くなる

+ パスワードレスまでの道のり
1. パスワードを利用している現状
2. 多要素認証
3. パスワードレス

+ パスワードレスとは
パスワードを利用せずに日々の業務を行うこと。シングルサインオンとは異なる。
パスワードレスにすることで、セキュリティの軽減、優れたユーザーエクスペリエンス、パスワードに関するコスト低減となる。

+ パスワードレスへの3つのオプション
Windows Hello for business
Authenticator
security auth key

+ 基本認証フロー
公開鍵ベースの仕組み
秘密鍵は常にデバイスに格納
デバイスでユーザーアクションが必要 (生体、PIN)
秘密鍵は他のデバイスと共有されない

+ Windows Hello for Business (FHFB)
FIDO2 Certfied の 1st Party サービス。
Hybrid 構成を選択するパターンが多い。
ADDC、AADC の構成
信頼の種類はキー信頼を選択するパターンが多い

+ FIDO2 Security Keys
指紋認証デバイスを利用して、指紋認証する
アプリケーションへのアクセスや、オンプレファイルサーバーへのアクセスもパスワードレスとなる。

+ Authenticator
モバイルアプリをつかって認証する

+ 使い分けをどうするか
1. ペルソナベースの方式整理
2. テクニカルシナリオベースの方式整理
3. パスワードレスウィザード
    + AAD global admin アカウントが必要 
    + http://aka.ms/passwordlesswizard 

+ パスワードレス White Paper
http://aka.ms/gopasswordless

+ PIN は特定のデバイスのみに紐づいている。PIN とデバイスが盗まれないと意味がない。
+ 生体情報はデバイスに保存されている。
+ PIN はデバイスのアンロックだけのために利用される。




 




