# XDG Base Directory Specification 詳細

freedesktop.org による XDG Base Directory Specification の詳細説明。

## 仕様の概要

XDG Base Directory Specification は、ユーザー固有のファイルをどこに保存すべきかを定義する標準仕様。ホームディレクトリの肥大化を防ぎ、設定・データ・キャッシュを明確に分離することを目的とする。

## 環境変数の詳細

### XDG_CONFIG_HOME

**目的**: ユーザー固有の設定ファイル

**デフォルト**: `$HOME/.config`

**配置すべきファイル**:
- アプリケーションの設定ファイル（.conf, .ini, .yaml, .toml 等）
- ユーザーがカスタマイズする設定

**配置すべきでないファイル**:
- 自動生成されるキャッシュ
- 履歴ファイル
- ソケットファイル

### XDG_DATA_HOME

**目的**: ユーザー固有のデータファイル

**デフォルト**: `$HOME/.local/share`

**配置すべきファイル**:
- プラグインやパッケージ
- データベースファイル
- 学習データ
- アイコン、テーマ

**例**:
```
~/.local/share/
├── fonts/
├── applications/  # .desktop ファイル
├── nvim/          # Neovim プラグイン
└── gnupg/
```

### XDG_CACHE_HOME

**目的**: 非必須のキャッシュデータ

**デフォルト**: `$HOME/.cache`

**特徴**:
- 削除しても再生成可能なデータ
- ディスク容量が逼迫した際に削除可能
- パフォーマンス最適化のためのデータ

**配置すべきファイル**:
- コンパイル済みバイトコード
- サムネイル
- ダウンロードキャッシュ

### XDG_STATE_HOME

**目的**: 永続的な状態データ

**デフォルト**: `$HOME/.local/state`

**特徴**:
- XDG_DATA_HOME より揮発性が高い
- アプリケーションの再起動間で保持すべき状態
- 他マシンに移植する必要のないデータ

**配置すべきファイル**:
- コマンド履歴
- 最近開いたファイルのリスト
- ログファイル
- アプリケーションの状態

**例**:
```
~/.local/state/
├── zsh/
│   └── history
├── bash/
│   └── history
├── less/
│   └── history
└── vim/
    ├── undo/
    └── viminfo
```

### XDG_RUNTIME_DIR

**目的**: ランタイム固有のファイル

**デフォルト**: `/run/user/$UID`（システムが設定）

**特徴**:
- ユーザーのみがアクセス可能（パーミッション 0700）
- ログアウト時に削除される
- tmpfs 上に配置されることが多い

**配置すべきファイル**:
- ソケットファイル
- ロックファイル
- 一時的な認証情報

### XDG_CONFIG_DIRS / XDG_DATA_DIRS

**目的**: システム全体の設定・データの検索パス

**デフォルト**:
- `XDG_CONFIG_DIRS`: `/etc/xdg`
- `XDG_DATA_DIRS`: `/usr/local/share:/usr/share`

**使用方法**:
ファイルを検索する際、まず `XDG_*_HOME` を確認し、次に `XDG_*_DIRS` を順に検索する。

## ディレクトリ構成のベストプラクティス

### 推奨構成

```
$HOME/
├── .config/                 # XDG_CONFIG_HOME
│   ├── git/
│   │   ├── config
│   │   └── ignore
│   ├── zsh/
│   │   └── .zshrc
│   ├── nvim/
│   │   └── init.lua
│   └── ...
├── .local/
│   ├── share/               # XDG_DATA_HOME
│   │   ├── fonts/
│   │   ├── nvim/
│   │   └── ...
│   └── state/               # XDG_STATE_HOME
│       ├── zsh/
│       │   └── history
│       └── ...
├── .cache/                  # XDG_CACHE_HOME
│   ├── npm/
│   ├── pip/
│   └── ...
└── .zshenv                  # ZDOTDIR を設定するため残す
```

### アプリケーション開発者向けガイドライン

1. **設定と状態を分離**: 設定（CONFIG）はユーザーが編集、状態（STATE）はアプリが管理
2. **デフォルト値を尊重**: 環境変数が未設定の場合はデフォルトパスを使用
3. **ディレクトリは自動作成**: 書き込み時にディレクトリが存在しない場合は作成
4. **パーミッション**: XDG_RUNTIME_DIR は 0700、その他は適切な権限で

## 参考リンク

- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [Arch Wiki - XDG Base Directory](https://wiki.archlinux.org/title/XDG_Base_Directory)
