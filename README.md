# dotfiles

Configuracoes pessoais de ambiente de desenvolvimento.

## Conteudo

- `ghostty/` — Configuracao do terminal Ghostty
- `nvim/` — Configuracao do Neovim (lazy.nvim + plugins)
- `tmux/` — Configuracao do tmux

## Instalacao

```bash
# Ghostty
ln -sf ~/dotenv/ghostty/config ~/.config/ghostty/config

# Neovim
ln -sf ~/dotenv/nvim ~/.config/nvim

# Tmux
ln -sf ~/dotenv/tmux/.tmux.conf ~/.tmux.conf
```

> O lazy.nvim faz bootstrap automaticamente na primeira execucao do nvim.
> Os parsers treesitter sao instalados ao abrir arquivos de cada linguagem.
> LSP servers sao instalados via Mason na primeira execucao.
