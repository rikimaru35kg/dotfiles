#!/usr/bin/env bash
set -euo pipefail

mkdir -p $HOME/.config

# setting files and directories
settings=(.pythonrc.py .tmux.conf .vimrc .tigrc .config/starship.toml .config/btop/btop.conf .config/nvim)

for setting in "${settings[@]}"; do
  src="$HOME/dotfiles/$setting"  # real file
  dst="$HOME/$setting"  # symbolic link

  # delete if exists or broken link
  [[ -e "$dst" || -L "$dst" ]] && rm -rf -- "$dst"

  # make parent directory of symbolic link
  mkdir -p -- "$(dirname -- "$dst")"

  # make symbolic link
  ln -s "$src" "$dst"
done

# insert the line of reading .bashrc_ex to .bashrc
read_bashrc_ex='[ -f "$HOME/dotfiles/.bashrc_ex" ] && source "$HOME/dotfiles/.bashrc_ex"'
if ! grep -Fxq "$read_bashrc_ex" "$HOME/.bashrc"; then
  {
    echo
    echo "# Read extra bash settings"
    echo "$read_bashrc_ex"
    echo
  } >> "$HOME/.bashrc"
fi

# make symbolic links to vscode snippets
read -p "Input your username of Windows: " win_username
snippets_dirpath="/mnt/c/Users/$win_username/AppData/Roaming/Code/User/snippets"
link_path="$HOME/dotfiles/.config/nvim/snippets"
# delete if exists or broken link
[[ -e "$link_path" || -L "$link_path" ]] && rm -rf -- "$link_path"
ln -s "$snippets_dirpath" "$link_path"

