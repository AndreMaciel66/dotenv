#!/bin/bash
set -euo pipefail

# Cores Catppuccin Mocha
GREEN="#a6e3a1"
YELLOW="#f9e2af"
MAUVE="#cba6f7"
SUBTEXT="#a6adc8"

dir="$1"

# Se não conseguir entrar no diretório, mostra só hora
cd "$dir" 2>/dev/null || { echo "#[fg=$SUBTEXT]%H:%M "; exit 0; }

output=""

# Python venv (detecta se tem .venv ou venv no diretório)
if [ -d ".venv" ] || [ -d "venv" ]; then
    output+="#[fg=$GREEN] venv "
fi

# Git info (com timeout para não travar a status bar)
if timeout 2 git rev-parse --is-inside-work-tree &>/dev/null; then
    branch=$(timeout 2 git branch --show-current 2>/dev/null)
    [ -z "$branch" ] && branch=$(timeout 2 git rev-parse --short HEAD 2>/dev/null)

    status=""
    timeout 2 git diff --quiet 2>/dev/null || status+="*"
    timeout 2 git diff --cached --quiet 2>/dev/null || status+="+"
    [ -n "$(timeout 2 git ls-files --others --exclude-standard 2>/dev/null | head -1)" ] && status+="?"

    output+="#[fg=$MAUVE] $branch#[fg=$YELLOW]$status "
fi

# Hora
output+="#[fg=$SUBTEXT]%H:%M "

echo "$output"
