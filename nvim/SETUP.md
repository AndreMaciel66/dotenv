# Neovim Setup - Documentacao

## Visao Geral

Setup minimalista para Neovim 0.12+ usando recursos nativos:
- **vim.pack** — gerenciador de plugins built-in (substituiu lazy.nvim)
- **vim.lsp.enable()** — LSP nativo (substituiu Mason + lspconfig)
- **vim.opt.autocomplete** — completion nativo (substituiu nvim-cmp)
- **Catppuccin Mocha** — colorscheme built-in (ships com nvim 0.12)

## Estrutura de Arquivos

```
~/.config/nvim/
├── init.lua          # Tudo: options, plugins (vim.pack), configs, keymaps
├── lsp/
│   ├── lua_ls.lua    # Config Lua Language Server
│   ├── ts_ls.lua     # Config TypeScript Language Server
│   └── pyright.lua   # Config Python (Pyright)
├── CHEATSHEET.md     # Atalhos rapidos
└── SETUP.md          # Este arquivo
```

## Plugins (19 total via vim.pack)

### Fuzzy Finder
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder extensivel | [README](https://github.com/nvim-telescope/telescope.nvim#readme) |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Algoritmo FZF nativo (performance) | [README](https://github.com/nvim-telescope/telescope-fzf-native.nvim#readme) |
| [telescope-ui-select.nvim](https://github.com/nvim-telescope/telescope-ui-select.nvim) | Substitui vim.ui.select por telescope | [README](https://github.com/nvim-telescope/telescope-ui-select.nvim#readme) |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Biblioteca Lua (dependencia) | [README](https://github.com/nvim-lua/plenary.nvim#readme) |

### Syntax
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Gerenciador de parsers treesitter | [README](https://github.com/nvim-treesitter/nvim-treesitter#readme) |

### UI
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline com indicadores de terminal clicaveis | [README](https://github.com/nvim-lualine/lualine.nvim#readme) |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | Icones para arquivos (requer Nerd Font) | [README](https://github.com/nvim-tree/nvim-web-devicons#readme) |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Sinais de git na coluna lateral | [README](https://github.com/lewis6991/gitsigns.nvim#readme) |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Popup mostrando atalhos disponiveis | [README](https://github.com/folke/which-key.nvim#readme) |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Guias visuais de indentacao | [README](https://github.com/lukas-reineke/indent-blankline.nvim#readme) |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Destaca TODO, FIX, HACK nos comentarios | [README](https://github.com/folke/todo-comments.nvim#readme) |

### Editor
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer em arvore | [Wiki](https://github.com/nvim-neo-tree/neo-tree.nvim/wiki) |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | Componentes de UI (dependencia) | - |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Ctrl+h/j/k/l navega entre nvim e tmux | [README](https://github.com/christoomey/vim-tmux-navigator#readme) |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Fecha parenteses, colchetes, aspas | [README](https://github.com/windwp/nvim-autopairs#readme) |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Comentar/descomentar com gcc/gc | [README](https://github.com/numToStr/Comment.nvim#readme) |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatacao de codigo (format on save) | [README](https://github.com/stevearc/conform.nvim#readme) |

### Snippets
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Engine de snippets | [Docs](https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md) |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Colecao de snippets VS Code style | [README](https://github.com/rafamadriz/friendly-snippets#readme) |

## LSP (nativo, sem Mason)

Servers instalados no sistema via brew/npm:

| Server | Linguagem | Instalar | Config |
|--------|-----------|----------|--------|
| lua-language-server | Lua | `brew install lua-language-server` | `lsp/lua_ls.lua` |
| typescript-language-server | JS/TS | `npm i -g typescript-language-server typescript` | `lsp/ts_ls.lua` |
| pyright | Python | `brew install pyright` | `lsp/pyright.lua` |

Para adicionar um novo LSP: crie `lsp/<nome>.lua` retornando `{ cmd, filetypes, root_markers }` e adicione o nome em `vim.lsp.enable()` no init.lua.

## Terminal Manager

Dois slots fixos de terminal aparecem na statusline (lualine):

| Atalho | Acao |
|--------|------|
| `SPC /` | Toggle: esconde/mostra o terminal ativo |
| `SPC ft` | Terminal no diretorio atual (pwd) |
| `SPC fT` | Terminal no home (~) |

Indicadores na statusline (clicaveis):
- **Cinza escuro** — slot vazio, nenhum terminal criado
- **Cinza claro** — terminal minimizado, processo vivo
- **Verde** — terminal ativo na tela

## Formatadores (Conform)

| Linguagem | Formatador |
|-----------|-----------|
| Lua | stylua |
| Python | black |
| JS/TS/JSX/TSX | prettierd (fallback: prettier) |

Formata automaticamente ao salvar. Edite `require("conform").setup()` no init.lua para adicionar mais.

## Dependencias Externas

| Ferramenta | Para que serve | Instalar |
|-----------|----------------|----------|
| Neovim >= 0.12 | Editor | `brew install neovim` |
| Git >= 2.19 | Plugins e treesitter | `brew install git` |
| ripgrep | Live grep no Telescope | `brew install ripgrep` |
| fd | Find files no Telescope | `brew install fd` |
| JetBrainsMono Nerd Font | Icones no terminal/nvim | Ja instalada em ~/Library/Fonts |
| Node.js | LSP ts_ls | `brew install node` |
| Python 3 | LSP pyright | `brew install python` |
| lua-language-server | LSP Lua | `brew install lua-language-server` |
| typescript-language-server | LSP JS/TS | `npm i -g typescript-language-server typescript` |
| pyright | LSP Python | `brew install pyright` |
| stylua | Formatador Lua | `brew install stylua` |
| prettierd / prettier | Formatador JS/TS | `npm i -g @fsouza/prettierd` |
| black | Formatador Python | `pip install black` |
| C compiler (cc) | Compilar parsers treesitter | Xcode Command Line Tools |

## Recursos para Aprender

- [Neovim 0.12 News](https://neovim.io/doc/user/news-0.12/) — O que mudou no 0.12
- [vim.pack Guide](https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack) — Guia completo do vim.pack
- [Native LSP in Neovim 0.12](https://dotfiles.substack.com/p/native-lsp-in-neovim-012) — LSP sem plugins
- [Neovim Docs](https://neovim.io/doc/) — Documentacao oficial
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — Config de referencia educativa
- [TJ DeVries](https://www.youtube.com/@teej_dv) — Canal do criador do Telescope
- `:help` dentro do nvim — A melhor referencia, sempre atualizada
- `:Tutor` dentro do nvim — Tutorial interativo para iniciantes
