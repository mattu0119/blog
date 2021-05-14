# 必要ファイルのダウンロード
Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/microsoft/diskspd/archive/master.zip" -OutFile c:\source\diskspdmaster.zip
Expand-Archive -Path C:\diskspdmaster.zip -DestinationPath c:\source\diskspd-master
Invoke-WebRequest -UseBasicParsing -Uri "https://aka.ms/getdiskspd" -OutFile c:\source\diskspd.zip
Expand-Archive -Path C:\source\diskspd.zip -DestinationPath c:\source\diskspd

# ボリュームの作成
Get-ClusterNode |% { New-Volume -StoragePoolFriendlyName S2D* -FriendlyName $_ -FileSystem CSVFS_ReFS -Size 1TB }
New-Volume -StoragePoolFriendlyName S2D* -FriendlyName Collect -FileSystem CSVFS_ReFS -Size 1TB

# VMFleet ファイルのコピー
C:\source\diskspd-master\diskspd-master\Frameworks\VMFleet\install-vmfleet.ps1 -source C:\source\diskspd-master\diskspd-master\Frameworks\VMFleet\
Copy-Item -Path "C:\source\diskspd\amd64\diskspd.exe" -Destination C:\ClusterStorage\Collect\control\tools\

# 仮想マシンの準備
VHDX を C:\ClusterStorage\Collect 直下にコピー

# VMFleet の実行
cd c:\clusterstorage\collect\control
.\create-vmfleet.ps1 -basevhd “C:\ClusterStorage\collect\vm.vhdx” -adminpass de11p@55 -connectpass de11p@55 -connectuser “Administrator” -vms 1