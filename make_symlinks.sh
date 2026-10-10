#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.config"

# function of making a symbolic link
# USE ABSOLUTE PATHS FOR SAFETY!!
make_symlink() {
  local src="$1" dst="$2"
  # check existence of src file/directory
  if [[ ! -e "$src" ]]; then
    echo "${src} doesn't exists, so a symbolic link wasn't made"
    return 0
  fi
  # delete if exists or broken link
  [[ -e "$dst" || -L "$dst" ]] && rm -rf -- "$dst"
  # make parent directory of symbolic link
  mkdir -p -- "$(dirname -- "$dst")"
  # make symbolic link
  ln -s "$src" "$dst"
}

# make symbolic links of files and directories
settings=(.pythonrc.py .tmux.conf .vimrc .tigrc .config/starship.toml .config/btop/btop.conf .config/nvim .config/opencode/opencode.jsonc)
for setting in "${settings[@]}"; do
  make_symlink "$HOME/dotfiles/$setting" "$HOME/$setting"
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

# make symbolic links/copies to some files in windows' directories (for MSYS2)
if [[ ${MSYSTEM-} == "UCRT64" ]]; then
  settings=(.wezterm.lua .vimrc .config/starship.toml)  # files for windows' home
  for setting in "${settings[@]}"; do
    make_symlink "$HOME/dotfiles/$setting" "/c/Users/$USER/$setting"
  done
  # wezterm pictures directory
  mkdir -p "/c/Users/$USER/dotfiles/pictures"
  cp "$HOME"/dotfiles/pictures/* "/c/Users/$USER/dotfiles/pictures/"
  # powershell profile
  make_symlink "$HOME/dotfiles/Microsoft.PowerShell_profile.ps1" \
    "/c/Users/$USER/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
fi

# make symbolic links to vscode snippets (for WSL2)
if [[ -n "${WSL_INTEROP-}" ]]; then
  read -p "Enter your Windows username: " win_username
  if [[ ! -d "/mnt/c/Users/${win_username}" ]]; then
    echo "The specified Windows username (${win_username}) is incorrect."
    echo "Skipping creation of symbolic links to Windows directories."
  else
    # make symbolink links to vscode snippets
    src="/mnt/c/Users/${win_username}/AppData/Roaming/Code/User/snippets"
    dst="$HOME/dotfiles/.config/nvim/snippets"
    make_symlink "$src" "$dst"
    # make symbolic links to windows desktop (for WSL2)
    src="/mnt/c/Users/${win_username}/Desktop"
    dst="$HOME/desk"
    make_symlink "$src" "$dst"
  fi
fi

