#!/bin/sh
# lnxd's oh-my-zsh setup: stock Oh My Zsh + personal template & theme.
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/lnxd/ohmyzsh/main/tools/install.sh)"
#
# Picks the macOS or Linux .zshrc automatically. Respects $ZSH and $ZSH_CUSTOM.
set -eu

BASE="${BASE:-https://raw.githubusercontent.com/lnxd/ohmyzsh/main}"
ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

case "$(uname -s)" in
  Darwin) template=zshrc.macos.zsh-template ;;
  *)      template=zshrc.linux.zsh-template ;;
esac

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# -f so a 404 aborts instead of writing "404: Not Found" into your config
fetch() {
  curl -fsSL "$1" -o "$2.part"
  mv -f "$2.part" "$2"
}

if [ -e "$HOME/.zshrc" ]; then had_zshrc=yes; else had_zshrc=no; fi

# 1. Stock Oh My Zsh, via upstream's own current installer (never a stale copy).
if [ -d "$ZSH" ]; then
  echo "==> $ZSH exists, skipping Oh My Zsh install"
else
  echo "==> Installing Oh My Zsh"
  fetch "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" "$tmp/omz.sh"
  sh "$tmp/omz.sh" --unattended --keep-zshrc
fi

# 2. Customisations go only under $ZSH_CUSTOM, which Oh My Zsh gitignores,
#    so the clone stays clean and `omz update` can never conflict.
echo "==> Installing lnxd theme"
mkdir -p "$ZSH_CUSTOM/themes"
fetch "$BASE/custom/themes/lnxd.zsh-theme" "$ZSH_CUSTOM/themes/lnxd.zsh-theme"

# 3. ~/.zshrc from the template for this OS, preserving any pre-existing config.
if [ "$had_zshrc" = yes ] && [ ! -e "$HOME/.zshrc.pre-oh-my-zsh" ]; then
  echo "==> Backing up ~/.zshrc to ~/.zshrc.pre-oh-my-zsh"
  mv "$HOME/.zshrc" "$HOME/.zshrc.pre-oh-my-zsh"
fi
echo "==> Writing ~/.zshrc from $template"
fetch "$BASE/templates/$template" "$tmp/zshrc"
sed "s|^export ZSH=.*$|export ZSH=\"$ZSH\"|" "$tmp/zshrc" > "$HOME/.zshrc"

case "${SHELL:-}" in
  */zsh) ;;
  *) echo "==> Your login shell isn't zsh. Run: chsh -s \"\$(command -v zsh)\"" ;;
esac

echo "==> Done. Machine-specific config goes in ~/.zshrc.local. Run 'exec zsh' to reload."
