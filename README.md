# lnxd's Oh My Zsh setup

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/lnxd/ohmyzsh/main/tools/install.sh)"
```

This is **not** a fork of Oh My Zsh that you install instead of the real thing. It installs
**stock Oh My Zsh straight from upstream**, using upstream's own current installer, and then
layers two things on top:

| | |
|---|---|
| `custom/themes/lnxd.zsh-theme` | the prompt, dropped into `$ZSH_CUSTOM/themes/` |
| `templates/zshrc.*.zsh-template` | `~/.zshrc`, picked by OS |

Nothing inside the Oh My Zsh clone is modified, so `omz update` keeps working indefinitely.

## OS detection

`uname -s` selects the template:

| OS | Template | PATH notes |
|---|---|---|
| `Darwin` | `zshrc.macos.zsh-template` | Homebrew at `/opt/homebrew` (Apple Silicon), plus GNU userland via `gnubin` for whichever formulae are installed |
| anything else | `zshrc.linux.zsh-template` | `~/.local/bin` first, so self-updating tools beat image-baked copies |

## Machine-specific config

The templates are deliberately generic — no hostnames, IPs, tokens or per-machine wrappers.
Anything specific to one box goes in `~/.zshrc.local`, which is sourced at the end of both
templates and is not tracked here. Secrets go in `~/.env`, which is auto-exported if present.

## Environment variables

| Variable | Default | Purpose |
|---|---|---|
| `ZSH` | `$HOME/.oh-my-zsh` | Where Oh My Zsh is installed |
| `ZSH_CUSTOM` | `$ZSH/custom` | Where the theme lands |
| `BASE` | this repo on `main` | Override to install from a branch or mirror |

To learn more about Oh My Zsh itself, visit [ohmyz.sh](https://ohmyz.sh).
