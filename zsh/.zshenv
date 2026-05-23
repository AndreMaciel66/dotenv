# ~/.zshenv — sourced em TODOS shells (login, interactive, scripts).
# Aqui vão variáveis que subprocessos (nvim, tmux panes, scripts) precisam ver.
# Configuração interativa (prompt, aliases, completion) fica em ~/.zshrc.

# Homebrew (Apple Silicon) — precisa vir antes do resto pra PATH ficar correto
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Editores
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export MANPAGER='nvim +Man!'

# Locale
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# less — raw colors, quit-if-one-screen, no init/deinit junk, case-insensitive search
export LESS='-R -F -X -i -M -W'
export LESSHISTFILE='-'

# Cache dir pro zsh (compinit, etc)
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p "$ZSH_CACHE_DIR"

# Java (Microsoft JDK 25) — mantido do setup original
export JAVA_HOME='/Library/Java/JavaVirtualMachines/microsoft-25.jdk/Contents/Home'
[[ -d $JAVA_HOME/bin ]] && path=("$JAVA_HOME/bin" $path)

# uv / pipx / cargo binaries
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# Docker CLI completions
fpath=("$HOME/.docker/completions" $fpath)

# SDKMAN — só a var, init real fica no .zshrc (precisa de shell interativo)
export SDKMAN_DIR="$HOME/.sdkman"

# Secrets locais (API keys, tokens) — arquivo NÃO versionado
[[ -f "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"
