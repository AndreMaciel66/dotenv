# dotfiles

Configuracoes pessoais de ambiente de desenvolvimento.

## Conteudo

- `ghostty/` — Configuracao do terminal Ghostty
- `nvim/` — Configuracao do Neovim (lazy.nvim + plugins)
- `tmux/` — Configuracao do tmux
- `zsh/` — Configuracao do Zsh (zshrc, zshenv)

## Instalacao

```bash
# Ghostty
ln -sf ~/dotenv/ghostty/config ~/.config/ghostty/config

# Neovim
ln -sf ~/dotenv/nvim ~/.config/nvim

# Tmux
ln -sf ~/dotenv/tmux/.tmux.conf ~/.tmux.conf

# Zsh
ln -sf ~/dotenv/zsh/.zshrc ~/.zshrc
ln -sf ~/dotenv/zsh/.zshenv ~/.zshenv
cp ~/dotenv/zsh/.zshenv.local.example ~/.zshenv.local  # editar com suas keys
```

> O lazy.nvim faz bootstrap automaticamente na primeira execucao do nvim.
> Os parsers treesitter sao instalados ao abrir arquivos de cada linguagem.
> LSP servers sao instalados via Mason na primeira execucao.

## Decisoes de customizacao

- **Zsh — cursor sempre em bloco.** Mesmo em modo insert do vi-mode, o cursor permanece bloco (`\e[1 q`). Eh preferencia pessoal: ja acostumado com o bloco do nvim/tmux, a barra fina (`\e[5 q`) padrao do insert estava incomodando.
- **Ghostty — Catppuccin Frappe (e nao Mocha).** O tmux e o nvim usam Mocha. Pra distinguir os tres contextos num piscar de olho, o Ghostty usa Frappe (base `#303446`), que eh visivelmente mais claro/aveludado que o Mocha (`#1e1e2e`) sem sair da familia Catppuccin.
- **Ghostty — fonte unica de verdade em `~/.config/ghostty/config`.** O Ghostty no macOS tambem le `~/Library/Application Support/com.mitchellh.ghostty/config` (template auto-criado). Esse arquivo esta neutralizado (so comentarios) pra evitar configs em dois lugares.
