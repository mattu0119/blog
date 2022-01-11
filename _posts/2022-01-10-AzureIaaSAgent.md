---
title: "Azure IaaS エージェントまとめ"
date: 2022-01-10 20:00:00 +08:00
#last_modified_at: 2021-11-20 09:45:00 +08:00
categories:
- Azure
---

## Hyper-V 統合サービス
Windows Server 2012 R2 以前、Windows 8.1 以前の OS を Azure IaaS に持ち込みする場合にインストールが必要。
+ [Hyper-V integration components update for Windows virtual machines](https://support.microsoft.com/en-us/topic/hyper-v-integration-components-update-for-windows-virtual-machines-8a74ffad-576e-d5a0-5a2f-d6fb2594f990)

## Azure 仮想マシンエージェント
+ [Azure 仮想マシン エージェントの概要](https://docs.microsoft.com/ja-jp/azure/virtual-machines/extensions/agent-windows)
 Azure 仮想マシンエージェントは、仮想マシンと Azure ファブリックコントローラのやりとりを管理する、セキュリティで保護された簡易プロセスです。Azure IaaS 仮想マシンを展開すると自動でインストールされるエージェントです。パッケージは、C:¥WindowsAzure\Packages フォルダに展開されます。VM 拡張機能を提供するエージェントで、Azure VM 管理者ユーザーのパスワードリセットなどのサービスを提供します。

.Net Framework 4 以降がインストールされていないと動かないので注意。.Net Framework 4 以降をインストールすると Azure 仮想マシンエージェントは自動で動き出すため、手動でインストールする必要はありません。

+ [.NET Framework 4.8 のダウンロード](https://dotnet.microsoft.com/ja-jp/download/dotnet-framework/net48)

Windows Server 2008 R2 以降の OS をサポートしています。

## Azure  Diagnostics エージェント
+ [Azure Diagnostics 拡張機能の概要](https://docs.microsoft.com/ja-jp/azure/azure-monitor/agents/diagnostics-extension-overview)
Azure Diagnostics 拡張機能は、仮想マシンを含む Azure コンピューティング リソースのゲスト オペレーティング システムから監視データを収集する、Azure Monitor のエージェントです。

1. Azure Monitor メトリックへのゲストのメトリックを収集する。
1. ゲストのログおよびメトリックをアーカイブ用に Azure Storage に送信する。
1. ゲストのログおよびメトリックを Azure の外部に送信するために Azure Event Hubs に送信する。

## Dependency エージェント

```Powershell
Set-AzVMExtension -ExtensionName "Microsoft.Azure.Monitoring.DependencyAgent" `
    -ResourceGroupName "rg-image" `
    -VMName "2008VM" `
    -Publisher "Microsoft.Azure.Monitoring.DependencyAgent" `
    -ExtensionType "DependencyAgentWindows" `
    -TypeHandlerVersion 9.5 `
    -Location swedencentral
```

