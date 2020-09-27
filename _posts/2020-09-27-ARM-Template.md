---
title: "Azure Resource Manager Template の構成"
date: 2020-09-27 15:30:00 +08:00
# last_modified_at: 2020-08-03 09:00:00 +08:00
categories: 
 - Azure
tags: 
 - ARM Template
---

## ARM テンプレートの内容
JSON 形式で、アプリケーションやインフラストラクチャの構成方法を記述する方法です。
```json
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "",
    "parameters": {  },
    "variables": {  },
    "functions": [  ],
    "resources": [  ],
    "outputs": {  }
}
```
## ARM Template のセクション

### パラメーター
VM のユーザー名とパスワードのパラメーター
```json
"parameters": {
  "adminUsername": {
    "type": "string",
    "metadata": {
      "description": "Username for the Virtual Machine."
    }
  },
  "adminPassword": {
    "type": "securestring",
    "metadata": {
      "description": "Password for the Virtual Machine."
    }
  }
}
```
### 変数
VM のネットワーク機能を記述するいくつかの変数
```json
"variables": {
  "nicName": "myVMNic",
  "addressPrefix": "10.0.0.0/16",
  "subnetName": "Subnet",
  "subnetPrefix": "10.0.0.0/24",
  "publicIPAddressName": "myPublicIP",
  "virtualNetworkName": "MyVNET"
}
```
### 関数
グローバルに一意である必要がある名前を持つリソースを作成するときに、使用できる一意の名前が作成されます。
```json
"functions": [
  {
    "namespace": "contoso",
    "members": {
      "uniqueName": {
        "parameters": [
          {
            "name": "namePrefix",
            "type": "string"
          }
        ],
        "output": {
          "type": "string",
          "value": "[concat(toLower(parameters('namePrefix')), uniqueString(resourceGroup().id))]"
        }
      }
    }
  }
],
```
### リソース
デプロイを構成する Azure リソースを定義
```json
"resources": [
{
  "type": "Microsoft.Network/publicIPAddresses",
  "name": "[variables('publicIPAddressName')]",
  "location": "[parameters('location')]",
  "apiVersion": "2018-08-01",
  "properties": {
    "publicIPAllocationMethod": "Dynamic",
    "dnsSettings": {
      "domainNameLabel": "[parameters('dnsLabelPrefix')]"
    }
  }
}
],
```
### 出力
テンプレートの実行時に受け取りたいすべての情報を定義します
```json
"outputs": {
  "hostname": {
    "type": "string",
    "value": "[reference(variables('publicIPAddressName')).dnsSettings.fqdn]"
  }
}
```
