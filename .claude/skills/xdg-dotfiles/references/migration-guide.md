# dotfiles 移行ガイド

従来の `~/.*` から XDG Base Directory への移行ベストプラクティス。

## 移行前の準備

### 1. 現状の把握

```bash
# ホームディレクトリの dotfiles を確認
ls -la ~/ | grep '^\.'

# または check_xdg.sh スクリプトを使用
scripts/check_xdg.sh
```

### 2. バックアップの作成

```bash
# dotfiles のバックアップ
mkdir -p ~/dotfiles-backup
cp -r ~/.* ~/dotfiles-backup/ 2>/dev/null
```

### 3. XDG ディレクトリの作成

```bash
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}"
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}"
```

## 移行の優先順位

### Phase 1: 基盤設定（必須）

1. **シェル設定**（zsh/bash）
   - XDG 環境変数のエクスポート
   - 他のすべての設定の前提条件

2. **Git**
   - 開発ワークフローに影響
   - ネイティブ対応のため移行が容易

### Phase 2: 開発ツール

3. **エディタ**（Neovim/Vim）
4. **ターミナルマルチプレクサ**（tmux）
5. **プログラミング言語ツール**

### Phase 3: その他

6. **ユーティリティ**（wget, less, ripgrep 等）
7. **対応が難しいもの**（SSH 等）

## 移行パターン

### パターン A: ネイティブ対応

アプリケーションが XDG を標準でサポート。

```bash
# 例: Git
mv ~/.gitconfig ~/.config/git/config
mv ~/.gitignore_global ~/.config/git/ignore
```

### パターン B: 環境変数で対応

環境変数を設定することで XDG パスを使用可能。

```bash
# 例: npm
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
mv ~/.npmrc "${XDG_CONFIG_HOME}/npm/npmrc"
```

### パターン C: エイリアス/ラッパーで対応

コマンドにオプションを渡すことで対応。

```bash
# 例: wget
alias wget='wget --hsts-file="${XDG_DATA_HOME}/wget/hsts"'
mkdir -p "${XDG_CONFIG_HOME}/wget"
mv ~/.wgetrc "${XDG_CONFIG_HOME}/wget/wgetrc"
```

### パターン D: シンボリックリンク

XDG に移行不可能なアプリケーション向け。

```bash
# 例: 強制的に $HOME を参照するアプリ
mv ~/.someconfig "${XDG_CONFIG_HOME}/someapp/config"
ln -s "${XDG_CONFIG_HOME}/someapp/config" ~/.someconfig
```

## トラブルシューティング

### 環境変数が反映されない

**原因**: 環境変数の設定順序が不適切

**解決策**:
- Zsh: `.zshenv` で XDG 変数を設定（他の設定ファイルより先に読まれる）
- Bash: `.bash_profile` の最初で設定

### アプリが新しいパスを認識しない

**原因**: アプリのキャッシュ、または設定のハードコード

**解決策**:
1. アプリを完全に終了
2. キャッシュを削除
3. 再起動

### シンボリックリンクが機能しない

**原因**: 一部アプリはシンボリックリンクを実体パスに解決

**解決策**:
- ハードリンクを試す
- 環境変数での設定を優先

## 移行スクリプトの使い方

### migrate_dotfile.sh

```bash
# 単一ファイルの移行
scripts/migrate_dotfile.sh ~/.vimrc ~/.config/vim/vimrc

# ディレクトリの移行
scripts/migrate_dotfile.sh ~/.vim ~/.config/vim
```

### オプション

- `--dry-run`: 実際には移行せず、実行内容を表示
- `--no-backup`: バックアップを作成しない
- `--force`: 既存ファイルを上書き

## 移行後のクリーンアップ

### ホームディレクトリの確認

```bash
# 残っている dotfiles を確認
ls -la ~/ | grep '^\.' | grep -v -E '^\.(config|local|cache|ssh)$'
```

### 不要なシンボリックリンクの削除

移行完了後、動作確認ができたら元ファイルへのシンボリックリンクを削除。

### バックアップの保管

一定期間（1-2週間）問題なく動作することを確認してからバックアップを削除。

## 完了チェックリスト

- [ ] XDG 環境変数がシェル起動時に設定される
- [ ] 主要な設定ファイルが `~/.config` に移行済み
- [ ] 履歴ファイルが `~/.local/state` に移行済み
- [ ] キャッシュが `~/.cache` に配置されている
- [ ] ホームディレクトリに不要な dotfile が残っていない
- [ ] すべてのアプリケーションが正常に動作する
