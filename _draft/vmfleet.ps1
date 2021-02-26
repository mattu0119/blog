# 必要ファイルのダウンロード
Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/microsoft/diskspd/archive/master.zip" -OutFile c:\source\diskspdmaster.zip
Expand-Archive -Path C:\diskspdmaster.zip -DestinationPath c:\source\diskspd-master
Invoke-WebRequest -UseBasicParsing -Uri "https://aka.ms/getdiskspd" -OutFile c:\source\diskspd.zip
Expand-Archive -Path C:\source\diskspd.zip -DestinationPath c:\source\diskspd


# ボリュームの作成
Get-ClusterNode |% { New-Volume -StoragePoolFriendlyName S2D* -FriendlyName $_ -FileSystem CSVFS_ReFS -Size 1TB }
New-Volume -StoragePoolFriendlyName S2D* -FriendlyName Collect -FileSystem CSVFS_ReFS -Size 1TB


# VMFleet ファイルのコピー

# 仮想マシンの準備

# 