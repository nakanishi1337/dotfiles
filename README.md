# dotfiles

- .zshrc: macOS ローカル環境用のシェル設定
- .bashrc: リモートサーバー接続時に使うシェル設定
- .gitconfig: Git の共通設定
- Brewfile: Homebrew で入れるツール一覧
- ghostty/config: Ghostty の表示と端末設定
- install.sh: macOS 用の自動セットアップスクリプト

## セットアップ (macOS)

```sh
git clone https://github.com/nakanishi1337/dotfiles.git
cd ./dotfiles
./install.sh
```

## セットアップ (Ubuntu / リモートサーバー)

```sh
sudo apt update
sudo apt install -y git

git clone https://github.com/nakanishi1337/dotfiles.git
cd ./dotfiles

ln -sfn "$PWD/.bashrc" "$HOME/.bashrc"
ln -sfn "$PWD/.gitconfig" "$HOME/.gitconfig"
source "$HOME/.bashrc"
```