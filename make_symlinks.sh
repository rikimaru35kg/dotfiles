#!/usr/bin/env bash
set -euo pipefail

mkdir -p $HOME/.config

# setting files and directories
settings=(.pythonrc.py .tmux.conf .vimrc .config/starship.toml .config/bat .config/nvim)

for setting in "${settings[@]}"; do
  src="$HOME/dotfiles/$setting"  # real file
  dst="$HOME/$setting"  # symbolic link

  # delete if exists or broken
  [[ -e "$dst" || -L "$dst" ]] && rm -rf -- "$dst"

  # make symbolic link
  ln -s "$src" "$dst"
done

