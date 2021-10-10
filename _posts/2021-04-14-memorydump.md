---
title: "メモリダンプ取得のテスト"
date: 2021-04-14 23:00:00 +08:00
#last_modified_at: 2021-01-02 11:00:00 +08:00
categories: 
 - Azure Stack HCI
#tags:
# - BSOD
# - Memory Dump
---

+ ブルースクリーンの強制実行
https://jpwinsup.github.io/blog/2021/02/15/Performance/Hang_BSOD/ForcingSystemCrash/

+ 仮想マシンで強制的にブルースクリーンを実行するコマンド
```powershell
Debug-VM -name "ダンプを取得する仮想マシン名" -InjectNonMaskableInterrupt -Confirm:$false -Force
# 仮想マシン名にスペースを含む場合はダブル コーテーションで括ってください。
```

