# AWS Network Firewall を使用した NAT Gateway アウトバウンドトラフィック制御


<p align="center">
  <img src="sources/aws.png" alt="animated" width="400">
</p>

![Git](https://img.shields.io/badge/GIT-E44C30?logo=git&logoColor=white)
![gitignore](https://img.shields.io/badge/gitignore%20io-204ECF?logo=gitignoredotio&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?logo=terraform&logoColor=white)

このリポジトリでは、AWS Network Firewall を使用して NAT Gateway 経由のアウトバウンドトラフィックを制御するためのインフラストラクチャコードとドキュメントを提供しています。
## 概要
AWS Network Firewall は、VPC トラフィックを保護するためのマネージド型のネットワークファイアウォールと侵入検知・防止サービスです。このプロジェクトでは、Network Firewall を使用して NAT Gateway 経由のアウトバウンドトラフィックをきめ細かく制御することで、セキュリティを強化します。

## 主な機能

+ 特定のドメインやIPアドレスへのアウトバウンドトラフィックの許可/拒否
+ プロトコルとポートベースのトラフィックフィルタリング
+ ステートフルおよびステートレスインスペクション

## システム構成
システムは以下の主要コンポーネントで構成されています：
### 1. ネットワーク構成
+ VPC: アプリケーションとリソースを含む仮想プライベートクラウド
+ サブネット:
    プライベートサブネット（アプリケーション用）
    ファイアウォールサブネット（Network Firewall 専用）
    パブリックサブネット（NAT Gateway 用）
+ NAT Gateway: プライベートサブネットからのアウトバウンドトラフィックを処理
+ Network Firewall: NAT Gateway を経由するトラフィックをインスペクションおよび制御
+ ルートテーブル: トラフィックを NAT Gateway と Network Firewall を介して適切にルーティング

### 2. IAM（Identity and Access Management）
Lambda 関数用の IAM ロール（最小権限の原則に基づく）

### 3. Lambda 関数
ファイアウォールルールに従属する関数
ファイアウォールルールに離反する関数

## 起動とデプロイ方法

以下のコードを実行してインフラを構築します。
```
bin/terraform_apply
```

### 停止
以下のコードを実行すると停止できます。
```
bin/terraform_destroy
```







