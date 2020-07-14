# Windows で Jekyll をつかったブログを運用する!
Windows で Jekyll を利用するには、Ruby などのツールをインストールを必要とし、作業が煩雑になります。
WSL2 や Windows Terminal で操作性も向上していることを期待し、この構成で試してみます。
[WSL2 とは](https://forest.watch.impress.co.jp/docs/shseri/win10may2020/1250493.html)

## 1. WSL2 のインストール
WSL2 は Windows 10 バージョン2004 ビルド19041 を利用する必要があるため、手動で Windows 10 バージョン2004へアップデートします。
[Windows 10 用 Windows Subsystem for Linux のインストール ガイド](https://docs.microsoft.com/ja-jp/windows/wsl/install-win10)

1. 現在利用している Windows 10 のバージョンを確認します。
    + Windows ロゴ キー + R キーを押下
    + `winver` と入力し、OK をクリック  
    表示された情報が `バージョン 2004、ビルド 19041` より以前の場合は更新が必要です。
2. Windows アシスタントにアクセスします。
    [Windows アシスタント](https://www.microsoft.com/software-download/windows10)
3. Windows 10 May 2020 Update の下にある、「今すぐアップデート」 をクリックします。
4. ダウンロードした exe ファイルを実行します。
    + ファイル名：Windows10Upgrade9252.exe
5. Windows セットアップを実行し、バージョン2004 ビルド 19041 を適用します。
