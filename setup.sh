#!/usr/bin/env bash
# Symlinks this repo's markdown files into their expected locations.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source file (relative to DOTFILES_DIR) -> target path
LINKS=(
  "AGENTS.md:$HOME/AGENTS.md"
  "AGENTS.md:$HOME/.claude/CLAUDE.md"
  "OPINIONS.md:$HOME/OPINIONS.md"
  "VOICE.md:$HOME/VOICE.md"
)

for entry in "${LINKS[@]}"; do
  src="$DOTFILES_DIR/${entry%%:*}"
  target="${entry#*:}"

  if [ ! -e "$src" ]; then
    echo "skip: source $src does not exist" >&2
    continue
  fi

  mkdir -p "$(dirname "$target")"

  if [ -L "$target" ]; then
    if [ "$(readlink "$target")" = "$src" ]; then
      echo "ok: $target already linked"
      continue
    fi
    rm "$target"
  elif [ -e "$target" ]; then
    backup="$target.bak.$(date +%Y%m%d%H%M%S)"
    echo "backing up existing $target -> $backup"
    mv "$target" "$backup"
  fi

  ln -s "$src" "$target"
  echo "linked: $target -> $src"
done
