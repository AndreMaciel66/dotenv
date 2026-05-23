#!/bin/bash
set -euo pipefail

# Verificar dependência
if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf não encontrado. Instale com: sudo apt install fzf" >&2
    exit 1
fi

cd "${1:-.}" || exit 1

# Preview: bat se disponível, senão head
PREVIEW_CMD="bat --style=numbers --color=always {} 2>/dev/null || head -50 {}"

if [ "${2:-}" = "git" ]; then
    SELECTED=$(git ls-files --cached --others --exclude-standard 2>/dev/null | fzf --preview "$PREVIEW_CMD")
else
    SELECTED=$(find . -type f -not -path '*/\.*' | sed 's|^\./||' | fzf --preview "$PREVIEW_CMD")
fi

if [ -n "$SELECTED" ]; then
    vim -- "$SELECTED"
fi
