# Chinachu with Mirakurun Sleep Scripts (β)

## Overview

Chinachu with Mirakurun なサーバ向け自動休止スクリプト群。
「Chinachu Sleep Scripts (β)」の改良 (劣化？) 版。
作成途中なので、テストはあまりしていない (できていない)。動かないかもしれない。 (作者的には、フィードバックが欲しい。)


## Description

「Chinachu Sleep Scripts (β)」と基本動作は同じ。全体的に荒削りだったスクリプトを書き直し、Mirakurun 対応部分を加えた。API を叩くスクリプトをすべてシェルスクリプトで書き直したため、Python 3 は不要となった。

そんなこんなで色々とコード的に変更点が多いので、「Chinachu Sleep Scripts (β)」とは別リポジトリとした。


## Test environment

* FUJITSU Server PRIMERGY TX1310 M1 (Pentium G3420, 4 GB RAM) + Earthsoft PT3 Rev.A

```
$ cat /etc/centos-release
CentOS Linux release 7.2.1511 (Core)
```

## Components

Chinachu with Mirakurun Sleep Script を構成ファイルたち。[] は、フォルダ内のファイルがインストール後に配置される場所を表している。

- main/
  - cron/ [/etc/cron.d]
    - chinachu-mirakurun-ss-cron (スリープ移行確認ジョブ用 cron。)
  - etc/ [/usr/local/etc/chinachu-mirakurun-ss]
    - config (設定ファイル。すべての設定はココに。各 lib 内スクリプトが読み込みに行く。)
  - lib/ [/usr/local/lib/chinachu-mirakurun-ss]
    - chinachu-api-count-connection (Chinachu WUI 接続中のユーザ数をカウントするスクリプト。)
    - chinachu-api-get-top-reserve-time (近々の録画予約開始時間出力スクリプト。)
    - chinachu-api-is-recording (Chinachu の録画状況取得スクリプト。)
    - chinachu-mirakurun-check-status (スリープ移行可能状況確認スクリプト。確認項目を増やしたい場合には、ココを編集。)
    - chinachu-mirakurun-sleep (電源管理マネージャ用のスクリプト。起動および停止移行時に実行される。次回起動タイマー設定が主な目的。)
    - mirakurun-api-sum-stream-count (Mirakurun がストリーム処理中かを確認するスクリプト。)
    - shift-to-sleep (電源管理マネージャに合わせた、休止 or シャットダウンコマンド実行スクリプト。cron のジョブで参照。)
  - install.sh (インストールスクリプト。)
  - uninstall.sh (アンインストールスクリプト。)
- extra/
  - recpt1test.sh (おまけ1。recpt1 録画テストスクリプト。)
  - rivaruntest.sh (おまけ2。rivarun 録画テストスクリプト。)
  - update-mirakurun.sh (おまけ3。Mirakurun & Rivarun 更新スクリプト。)
- README.md (このファイル。)
- LICENSE.md (ライセンスファイル。)


## Usage

pm-utils のインストール (必要であれば)

```
# yum install pm-utils
```

作業フォルダに移動。

```
# cd /usr/local/src
```

クローン。

```
# git clone --depth 1 https://github.com/gcch/Chinachu-Mirakurun-SS.git ./chinachu-mirakurun-ss
```

移動。

```
# cd chinachu-mirakurun-ss/main/
```

設定ファイルを弄る。 (詳細は中身を参照。Chinachu と Mirakurun のホスト名とポート番号は少なくとも編集が必要かと。)

```
# vi etc/config
```

インストールを開始する。

```
# chmod +x install.sh
# ./install.sh
```

で、おしまい。

設定を変えたいときは、/usr/local/etc/chinachu-mirakurun-ss/config を弄る。


## License
This script is released under the MIT license. See the LICENSE file.


## Author
* tag (Twitter: [@tag_ism](https://twitter.com/tag_ism "tag (@tag_ism) | Twitter") / Blog: http://karat5i.blogspot.jp/)
