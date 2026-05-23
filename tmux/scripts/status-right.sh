#!/bin/bash
# status-right.sh — gera a parte direita da statusbar do tmux.
# Espelha o vocabulário visual do prompt do zsh:
#   path  → mauve     branch → green     dirty (●) → yellow     hora → overlay0
# Otimizado: 1 chamada `git status` em vez de 4-5 sub-comandos com timeout.

set -euo pipefail

# Cores Catppuccin Mocha
MAUVE="#cba6f7"
GREEN="#a6e3a1"
YELLOW="#f9e2af"
OVERLAY0="#6c7086"
SUBTEXT="#a6adc8"

dir="${1:-$PWD}"

# Se o diretório sumiu, mostra só hora.
cd "$dir" 2>/dev/null || { printf '#[fg=%s] %%H:%%M ' "$OVERLAY0"; exit 0; }

out=""

# venv ativo (.venv ou venv local)
if [ -d ".venv" ] || [ -d "venv" ]; then
    out+="#[fg=$GREEN] venv  "
fi

# Git: 1 invocação (`status --porcelain=v2 --branch`), parse local.
# Timeout global de 2s — em repo muito grande, melhor sumir do que travar.
if git_out=$(timeout 2 git -c color.ui=false status --porcelain=v2 --branch 2>/dev/null); then
    branch=""
    dirty=""

    while IFS= read -r line; do
        case "$line" in
            "# branch.head "*)
                branch="${line#\# branch.head }"
                ;;
            "1 "*|"2 "*|"u "*)
                dirty="●"
                ;;
            "? "*)
                # untracked — marca dirty também, mesmo símbolo do prompt zsh.
                dirty="●"
                ;;
        esac
    done <<< "$git_out"

    # Detached HEAD aparece como "(detached)" — troca por sha curto.
    if [ "$branch" = "(detached)" ]; then
        branch=$(timeout 1 git rev-parse --short HEAD 2>/dev/null || echo "detached")
    fi

    if [ -n "$branch" ]; then
        out+="#[fg=$GREEN] $branch"
        [ -n "$dirty" ] && out+=" #[fg=$YELLOW]$dirty"
        out+="  "
    fi
fi

# Diretório atual (basename) em mauve, igual o %~ do prompt zsh.
# (Hora vem depois, inserida diretamente pelo tmux via format %H:%M no .tmux.conf —
#  tmux não re-interpreta formats dentro do output de #(...), então tem que ficar fora.)
base=$(basename "$dir")
[ "$base" = "$HOME" ] && base="~"
out+="#[fg=$MAUVE] $base  "

printf '%s' "$out"
