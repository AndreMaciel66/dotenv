#!/bin/bash
# Cheatsheet vertical (estilo which-key.nvim) — coluna estreita à esquerda.
# Invocado via `prefix + h`. Sai com `q`. Scrolla com setas/PgUp/PgDn.

# Catppuccin Mocha
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
TEXT='\033[38;2;205;214;244m'
BLUE='\033[38;2;137;180;250m'
MAUVE='\033[38;2;203;166;247m'
PEACH='\033[38;2;250;179;135m'
LAVENDER='\033[38;2;180;190;254m'
GREEN='\033[38;2;166;227;161m'
YELLOW='\033[38;2;249;226;175m'
PINK='\033[38;2;245;194;231m'
OVERLAY='\033[38;2;108;112;134m'

# Helper: linha "  key   desc"
# Largura da coluna de key fixa em 12 — alinha as descrições.
row() {
    printf "  ${GREEN}%-14s${RESET} ${TEXT}%s${RESET}\n" "$1" "$2"
}

# Helper: cabeçalho de subseção
sub() {
    printf "\n${YELLOW}  %s${RESET}\n" "$1"
}

# Helper: separador entre seções principais
sep() {
    printf "${OVERLAY}  ────────────────────────────────────────${RESET}\n"
}

render() {
    # ── Header ───────────────────────────────────────────
    printf "${BLUE}${BOLD}\n  ┃ ${LAVENDER}CHEATSHEET${RESET}${BLUE}${BOLD}                              ${RESET}\n"
    printf "${OVERLAY}  ────────────────────────────────────────${RESET}\n"
    printf "${YELLOW}  navegação vi-like ${OVERLAY}(less)${RESET}\n"
    printf "  ${GREEN}j  k${RESET}        ${DIM}${TEXT}linha down / up${RESET}\n"
    printf "  ${GREEN}d  u${RESET}        ${DIM}${TEXT}½ página down / up${RESET}\n"
    printf "  ${GREEN}f  b${RESET}        ${DIM}${TEXT}página inteira down / up${RESET}\n"
    printf "  ${GREEN}gg  G${RESET}       ${DIM}${TEXT}topo / fim${RESET}\n"
    printf "  ${GREEN}/termo${RESET}      ${DIM}${TEXT}busca (case-insensitive)${RESET}\n"
    printf "  ${GREEN}?termo${RESET}      ${DIM}${TEXT}busca pra trás${RESET}\n"
    printf "  ${GREEN}n  N${RESET}        ${DIM}${TEXT}próximo / anterior match${RESET}\n"
    printf "  ${GREEN}q${RESET}           ${DIM}${TEXT}sair${RESET}\n"

    # ── TMUX ─────────────────────────────────────────────
    printf "\n${MAUVE}${BOLD}  TMUX${RESET}${OVERLAY}  prefix = Ctrl+a${RESET}\n"

    sub "janelas / painéis"
    row "prefix |"      "split vertical"
    row "prefix -"      "split horizontal"
    row "prefix c"      "nova janela"
    row "prefix n"      "próxima janela"
    row "prefix a"      "última janela"
    row "prefix z"      "zoom toggle"
    row "prefix H/J/K/L" "resize panes (rep)"
    row "Ctrl+h/j/k/l"  "navega (nvim-aware)"
    row "Alt+setas"     "navega s/ prefix"

    sub "copy mode"
    row "prefix Esc"    "entra"
    row "v"             "seleção visual"
    row "y"             "copy (flash verde)"
    row "mouse drag"    "copy (idem)"
    row "/  ?"          "busca frente/trás"
    row "q"             "sai"

    sub "popups / fzf"
    row "prefix o / l"  "fzf abre (todos/git)"
    row "prefix O / L"  "fzf popup grande"
    row "prefix p"      "shell popup"
    row "prefix P"      "cmd popup"
    row "prefix t / T"  "scratch session"
    row "prefix h"      "este helper"
    row "prefix C-p"    "capture buffer → nvim"

    sub "reorganização / sessão"
    row "prefix J / S"  "move pane entre wins"
    row "prefix B"      "pane vira janela"
    row "prefix d"      "detach"
    row "prefix r"      "reload config"

    sep

    # ── NVIM ─────────────────────────────────────────────
    printf "\n${PEACH}${BOLD}  NVIM${RESET}${OVERLAY}  leader = Space${RESET}\n"

    sub "telescope"
    row "leader ff"     "find files"
    row "leader fg"     "live grep"
    row "leader fb"     "buffers"
    row "leader fh"     "help tags"
    row "leader fw"     "grep word"
    row "leader fd"     "diagnostics"
    row "leader fr"     "resume busca"
    row "leader fo"     "old files"
    row "leader leader" "buffers (quick)"

    sub "lsp"
    row "gd  gr  gI  gD" "def/refs/impl/decl"
    row "K"              "hover docs"
    row "leader rn"      "rename"
    row "leader ca"      "code action"
    row "leader D"       "type definition"
    row "leader ds/ws"   "doc/wks symbols"

    sub "edição / explorer"
    row "leader e"      "neo-tree toggle"
    row "leader cf"     "format (Conform)"
    row "leader /"      "term flutuante"
    row "leader ft/fT"  "term split (wd/~)"
    row "gcc / gc{m}"   "comenta linha/região"
    row "gcb"           "comenta em bloco"

    sub "autocomplete"
    row "Ctrl+n / Ctrl+p" "próx / anterior"
    row "Ctrl+y"          "confirma"
    row "Ctrl+Space"      "abre menu"
    row "Ctrl+l / Ctrl+h" "snippet next/prev"

    sub "geral"
    row "Esc"           "nohlsearch"
    row "Esc Esc"       "sai terminal mode"
    row "leader q"      "diagnostics loclist"
    row "Ctrl+h/j/k/l"  "navega splits"

    sep

    # ── GHOSTTY ──────────────────────────────────────────
    printf "\n${LAVENDER}${BOLD}  GHOSTTY${RESET}\n"
    sub "config"
    printf "  ${DIM}${TEXT}JetBrainsMono NF 14pt · catppuccin-mocha${RESET}\n"
    printf "  ${DIM}${TEXT}copy-on-select = clipboard${RESET}\n"
    sub "atalhos"
    row "(arrastar)"    "copia direto"
    row "Cmd+C / V"     "copy / paste"
    row "Cmd+T / N / W" "tab / win / close"
    row "Cmd++ / - / 0" "zoom in / out / reset"
    row "Cmd+K"         "clear scrollback"
    row "Cmd+Click"     "abre link"
    row "+list-keybinds" "lista TODOS keybinds"

    sep

    # ── CLAUDE ───────────────────────────────────────────
    printf "\n${PINK}${BOLD}  CLAUDE${RESET}\n"
    sub "cli"
    row "claude"        "nova conversa"
    row "claude -c"     "continua último"
    row "claude -r"     "retoma recente"
    row "claude -p ..." "one-shot script"
    row "cat f | claude" "arquivo como ctx"
    sub "slash"
    row "/help"         "ajuda"
    row "/clear"        "limpa contexto"
    row "/compact"      "compacta histórico"
    row "/cost"         "custo da sessão"
    row "/doctor"       "diagnóstico"
    row "/quit"         "sai"

    sep
    printf "\n${DIM}${OVERLAY}  fim — q para sair${RESET}\n\n"
}

# Pipe pro less com:
#   -R  mantém códigos ANSI (cores)
#   -X  não limpa tela ao sair
#   -F  sai sozinho se conteúdo couber inteiro
#   -i  busca case-insensitive se padrão é todo minúsculo (estilo vim smartcase)
#   -K  CTRL-C sai do less em vez de só interromper busca
# `command less` ignora qualquer alias `less=...` que possa existir.
render | command less -R -X -F -i -K
