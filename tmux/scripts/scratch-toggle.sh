#!/bin/bash
set -euo pipefail

# Usa ~/.cache ao invés de /tmp para segurança
CACHE_DIR="$HOME/.cache/tmux"
mkdir -p "$CACHE_DIR"
RETURN_FILE="$CACHE_DIR/scratch_return"

CURRENT_SESSION=$(tmux display-message -p '#S')

if [ "$CURRENT_SESSION" = "scratch" ]; then
    # Estamos no scratch - mover pane de volta para origin
    if [ -f "$RETURN_FILE" ]; then
        ORIGIN=$(cat "$RETURN_FILE")
        tmux join-pane -t "$ORIGIN"
        rm -f "$RETURN_FILE"
    else
        tmux display-message "No origin saved - use break-pane (prefix+B) instead"
    fi
else
    # Estamos fora do scratch - salvar origin e mover pane
    tmux display-message -p '#S:#I' > "$RETURN_FILE"

    if ! tmux has-session -t scratch 2>/dev/null; then
        tmux new-session -d -s scratch
    fi

    tmux join-pane -t scratch:
    tmux display-popup -E -w 80% -h 80% "tmux attach -t scratch"
fi
