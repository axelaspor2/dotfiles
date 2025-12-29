---
name: xdg-dotfiles
description: XDG Base Directory Specification に基づいた dotfiles の管理を支援するスキル。以下の場合に使用：(1) dotfiles を XDG 準拠のディレクトリ構成に移行したい、(2) 新規に XDG 準拠の設定ファイルを作成したい、(3) アプリケーションの XDG 対応方法を知りたい、(4) ホームディレクトリをクリーンに保ちたい。dotfiles、設定ファイル、XDG、$HOME のクリーンアップに関する質問でトリガー。
---

# XDG Dotfiles Manager

XDG Base Directory Specification に基づいた dotfiles 管理を支援するスキル。

## XDG Base Directory の基本

| 環境変数 | デフォルト値 | 用途 |
|---------|-------------|------|
| `XDG_CONFIG_HOME` | `~/.config` | ユーザー固有の設定ファイル |
| `XDG_DATA_HOME` | `~/.local/share` | ユーザー固有のデータファイル |
| `XDG_CACHE_HOME` | `~/.cache` | キャッシュデータ |
| `XDG_STATE_HOME` | `~/.local/state` | 永続的な状態データ（ログ、履歴） |
| `XDG_RUNTIME_DIR` | `/run/user/$UID` | ランタイムファイル（ソケット等） |

## ワークフロー

### 1. 既存 dotfiles の移行

```
1. 対象アプリの XDG 対応状況を確認 → references/app-configs.md
2. 移行スクリプトを実行 → scripts/migrate_dotfile.sh
3. シェル設定に環境変数を追加
4. 元ファイルのバックアップを確認後、削除
```

### 2. 新規 XDG 準拠設定の作成

```
1. アプリの設定ファイル配置場所を確認 → references/app-configs.md
2. XDG_CONFIG_HOME 配下に設定ファイルを作成
3. 必要に応じて環境変数をエクスポート
```

### 3. 現状チェック

```
scripts/check_xdg.sh を実行して、ホームディレクトリの dotfiles を確認
```

## シェル設定の基本テンプレート

`.zshenv` または `.bash_profile` に追加:

```bash
# XDG Base Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# ディレクトリ作成
mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"
```

## リファレンス

- **アプリケーション別設定**: [references/app-configs.md](references/app-configs.md) - 各アプリの XDG 対応方法
- **XDG 仕様詳細**: [references/xdg-spec.md](references/xdg-spec.md) - XDG 仕様の詳細説明
- **移行ガイド**: [references/migration-guide.md](references/migration-guide.md) - 移行のベストプラクティス

## スクリプト

- `scripts/migrate_dotfile.sh` - dotfile を XDG ディレクトリに移行
- `scripts/check_xdg.sh` - XDG 準拠状況をチェック
- `scripts/setup_xdg_env.sh` - XDG 環境変数を設定
