# ~/.zshrc — sourced apenas em shells interativos.
# Ambiente / PATH / secrets ficam em ~/.zshenv e ~/.zshenv.local.
# Tema: Catppuccin Mocha (combina com o tmux). Fonte: JetBrainsMono Nerd Font.

# ───────────────────────────── História ──────────────────────────────
HISTFILE="$ZSH_CACHE_DIR/history"
HISTSIZE=200000          # linhas em memória
SAVEHIST=200000          # linhas persistidas no disco
setopt EXTENDED_HISTORY        # grava timestamp + duração
setopt HIST_EXPIRE_DUPS_FIRST  # ao truncar, descarta duplicatas primeiro
setopt HIST_IGNORE_DUPS        # não grava se igual ao anterior
setopt HIST_IGNORE_ALL_DUPS    # remove versões antigas duplicadas
setopt HIST_IGNORE_SPACE       # comandos começando com espaço = privado
setopt HIST_FIND_NO_DUPS       # busca pula duplicatas
setopt HIST_SAVE_NO_DUPS       # disco também sem duplicatas
setopt HIST_REDUCE_BLANKS      # normaliza whitespace antes de gravar
setopt HIST_VERIFY             # !!  cola o comando em vez de executar direto
setopt INC_APPEND_HISTORY      # grava ao executar, não só no exit
setopt SHARE_HISTORY           # compartilha entre sessões abertas

# ───────────────────────────── Opções ─────────────────────────────────
setopt AUTO_CD                 # `cd path` opcional — só digite o path
setopt AUTO_PUSHD              # cd empilha no dirstack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt EXTENDED_GLOB           # **/*, qualifiers, etc
setopt GLOB_DOTS               # globs incluem dotfiles
setopt INTERACTIVE_COMMENTS    # # em comandos interativos
setopt NO_BEEP
setopt NO_FLOW_CONTROL         # libera Ctrl+S / Ctrl+Q
setopt COMPLETE_IN_WORD        # completa no meio da palavra
setopt ALWAYS_TO_END           # cursor pro fim após completar
setopt LONG_LIST_JOBS
setopt NOTIFY                  # avisa job em bg ao terminar
unsetopt CASE_GLOB             # glob case-insensitive (foo == FOO)

# ───────────────────────────── Completion ────────────────────────────
# compinit é caro; cacheia dump por 24h, regen no background depois disso.
autoload -Uz compinit
_zcompdump="$ZSH_CACHE_DIR/zcompdump"
# (#qN.mh+24) = regular file existente, modificado >24h atrás
if [[ -n ${_zcompdump}(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

# Compila o dump na primeira vez (carrega ~30% mais rápido)
if [[ -s "$ZSH_CACHE_DIR/zcompdump" && (! -s "$ZSH_CACHE_DIR/zcompdump.zwc" || "$ZSH_CACHE_DIR/zcompdump" -nt "$ZSH_CACHE_DIR/zcompdump.zwc") ]]; then
  zcompile "$ZSH_CACHE_DIR/zcompdump"
fi

# Menu navegável com setas
zstyle ':completion:*' menu select
# Case-insensitive + parcial: `cd doc` casa `Documents`, `pic` casa `Pictures`
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Agrupa por categoria com cabeçalho colorido
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{#cba6f7}── %d ──%f'
zstyle ':completion:*:messages'     format '%F{#f9e2af}%d%f'
zstyle ':completion:*:warnings'     format '%F{#f38ba8}no matches: %d%f'
# Cores nos completes (usa LS_COLORS se disponível, senão fallback)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS:-di=34:ln=35:so=32:pi=33:ex=31}
# Process picker (kill <TAB>) mostra árvore colorida
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# Cache pesado de completes (ex.: apt, brew)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/compcache"

# ───────────────────────────── Vi-mode ───────────────────────────────
# Use vi keymap, mas mantém alguns conforto-emacs essenciais
bindkey -v
export KEYTIMEOUT=1  # 10ms — sem latência ao apertar Esc

# Cursor muda de forma entre modos (bar em insert, block em normal)
_set_cursor() {
  case $KEYMAP in
    vicmd)              printf '\e[1 q' ;;  # block
    main|viins|'')      printf '\e[5 q' ;;  # bar
  esac
}
zle -N zle-keymap-select _set_cursor
zle -N zle-line-init     _set_cursor
# Reset pra bar ao executar comando (caso saia em modo normal)
preexec() { printf '\e[5 q' }

# History search vim-style em modo normal
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' down-line-or-history
# Edita comando atual no $EDITOR (apertar `v` em modo normal)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Backspace/Del/seta funcionam após sair de modo normal (defaults zsh vi mode são chatos)
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line

# History incremental search (substring match)
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history

# ───────────────────────────── Prompt ────────────────────────────────
# Multi-linha: dir + git info acima, prompt char abaixo.
# Sem ícones Nerd Font pra não quebrar em terminais sem fonte (símbolos unicode comuns).
setopt PROMPT_SUBST

# Git info — rápido (não usa vcs_info). Mostra branch + indicador dirty.
_git_prompt() {
  local branch
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null) \
    || branch=$(command git rev-parse --short HEAD 2>/dev/null) \
    || return
  local dirty=''
  if ! command git diff --no-ext-diff --quiet --ignore-submodules 2>/dev/null \
     || ! command git diff --no-ext-diff --cached --quiet --ignore-submodules 2>/dev/null; then
    dirty='%F{#f9e2af} ●%f'
  fi
  print -n " %F{#a6e3a1}${branch}%f${dirty}"
}

# Duração do último comando (mostra se > 3s)
_cmd_timer_start=0
preexec_timer() { _cmd_timer_start=$EPOCHREALTIME }
precmd_timer() {
  if (( _cmd_timer_start > 0 )); then
    local elapsed=$(( EPOCHREALTIME - _cmd_timer_start ))
    _cmd_timer_start=0
    if (( elapsed >= 3 )); then
      if   (( elapsed >= 60 )); then _cmd_duration=$(printf '%dm%ds' $((elapsed/60)) $((elapsed%60)))
      else _cmd_duration=$(printf '%.1fs' $elapsed)
      fi
      return
    fi
  fi
  _cmd_duration=''
}
zmodload zsh/datetime
autoload -Uz add-zsh-hook
add-zsh-hook preexec preexec_timer
add-zsh-hook precmd  precmd_timer

# Indicador SSH (mostra user@host se conectado remotamente)
_ssh_prompt() {
  [[ -n $SSH_CONNECTION || -n $SSH_TTY ]] && print -n "%F{#fab387}%n@%m%f "
}

# Linha 1: [ssh?] path  git
# Linha 2: prompt-char (cor muda com exit code, forma muda com vi-mode)
PROMPT='
$(_ssh_prompt)%F{#cba6f7}%~%f$(_git_prompt)
%(?.%F{#89b4fa}.%F{#f38ba8})${${KEYMAP/vicmd/❮}/(main|viins)/❯}%f '

# Lado direito: duração se >3s (cor dim)
RPROMPT='%F{#6c7086}${_cmd_duration}%f'

# Redesenha prompt ao trocar de modo (pra atualizar o ❯/❮)
_zle_redraw_on_mode_change() { zle reset-prompt }
zle -N zle-keymap-select _zle_redraw_on_mode_change

# ───────────────────────────── Aliases ───────────────────────────────
# eza — ls moderno, com ícones (precisa Nerd Font)
alias ls='eza --group-directories-first --icons=auto'
alias l='eza -lh --group-directories-first --icons=auto --git'
alias ll='eza -lah --group-directories-first --icons=auto --git'
alias la='eza -a --group-directories-first --icons=auto'
alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
alias ltt='eza --tree --level=3 --icons=auto --group-directories-first'

# bat — cat com syntax highlight (--paging=never pra não abrir less)
alias cat='bat --paging=never --style=plain'
alias catt='bat'                              # com paginação + frame
export BAT_THEME='Catppuccin Mocha'

# Navegação
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Editor
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# Git
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate --all -20'
alias gco='git checkout'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull --rebase'

# Tmux
alias t='tmux'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux ls'

# Utils
alias rg='rg --smart-case --hidden --glob "!.git"'
alias mkdir='mkdir -p'
alias df='df -h'
alias du='du -h'
alias path='echo $PATH | tr ":" "\n"'
alias reload='exec zsh -l'

# macOS
alias o='open'
alias ip='curl -s ifconfig.me; echo'
alias localip="ipconfig getifaddr en0"

# ───────────────────────────── fzf integration ───────────────────────
# Ctrl+R history, Ctrl+T arquivos, Alt+C dirs (fornecidos pelo --zsh)
if command -v fzf >/dev/null; then
  source <(fzf --zsh)

  # Usa fd (mais rápido + respeita .gitignore) se disponível
  if command -v fd >/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi

  # Tema Catppuccin Mocha + preview com bat / eza
  export FZF_DEFAULT_OPTS='
    --height=60% --layout=reverse --border=rounded --margin=1 --padding=1
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
    --color=border:#585b70,label:#cdd6f4'
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range :200 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons=auto {}'"
fi

# ───────────────────────────── zoxide ────────────────────────────────
# `z foo` pula pro diretório mais usado que casa "foo"; `zi` abre fzf picker
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
fi

# ───────────────────────────── Plugins ───────────────────────────────
# zsh-autosuggestions — sugestão fish-like baseada no histórico
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#585b70'  # Catppuccin overlay0 — bem sutil
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20            # não sugere em comandos longos (perf)
  # Aceita sugestão com Ctrl+Space (em vez de seta direita, que conflita com vim-style)
  bindkey '^ ' autosuggest-accept
fi

# zsh-syntax-highlighting — DEVE ser o último source (intercepta zle final)
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  # Cores Catppuccin Mocha
  typeset -gA ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[default]='fg=#cdd6f4'
  ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1,bold'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#cdd6f4,underline'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=#fab387'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=#fab387,bold'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#6c7086,italic'
fi

# ───────────────────────────── SDKMAN (deixar no fim!) ───────────────
# SDKMAN exige ser sourced por último — manipula PATH agressivamente
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
