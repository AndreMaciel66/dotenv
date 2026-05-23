#!/bin/bash
set -euo pipefail

# Verificar dependências
for cmd in fzf tmux; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd não encontrado." >&2
        exit 1
    fi
done

CALLER_PANE="${1}"
MODE="${2:-all}"

# Preview: bat se disponível, senão head
PREVIEW_CMD="bat --style=numbers --color=always {} 2>/dev/null || head -20 {}"

# Listar arquivos
if [ "$MODE" = "git" ]; then
    FILES=$(git ls-files --cached --others --exclude-standard 2>/dev/null)
else
    FILES=$(find . -type f -not -path '*/\.*' | sed 's|^\./||')
fi

# Selecionar arquivo com FZF
SELECTED=$(echo "$FILES" | fzf --preview "$PREVIEW_CMD")

if [ -z "$SELECTED" ]; then
    exit 0
fi

# Selecionar tipo de split
SPLIT=$(printf 'horizontal\nvertical\nscratch' | fzf --no-preview --height 5)

if [ -z "$SPLIT" ]; then
    exit 0
fi

# Escapar nome do arquivo para prevenir injection
ESCAPED=$(printf '%q' "$SELECTED")

# Abrir arquivo
case "$SPLIT" in
    horizontal)
        tmux split-window -t "$CALLER_PANE" -v "vim -- $ESCAPED"
        ;;
    vertical)
        tmux split-window -t "$CALLER_PANE" -h "vim -- $ESCAPED"
        ;;
    scratch)
        tmux new-session -d -s scratch 2>/dev/null || true
        tmux new-window -t scratch "vim -- $ESCAPED"
        tmux display-popup -E -w 90% -h 90% "tmux attach -t scratch"
        ;;
esac
