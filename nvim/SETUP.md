# Neovim Setup - Documentacao

## Visao Geral

Setup minimalista e moderno para Neovim 0.12+ usando **lazy.nvim** como gerenciador de plugins.
Tema **Catppuccin Mocha** consistente com a configuracao do tmux e Ghostty.

> **Nota:** Neovim 0.12 inclui `vim.pack` (gerenciador de plugins built-in), auto-completion
> nativo e LSP expandido. Este setup usa lazy.nvim por oferecer lazy-loading, UI, build steps
> e controle de dependencias que `vim.pack` ainda nao tem. Ambos coexistem sem conflito.

## Estrutura de Arquivos

```
~/.config/nvim/
├── init.lua                    # Ponto de entrada: bootstrap lazy.nvim, opcoes, keymaps globais
├── lazy-lock.json              # Lockfile dos plugins (versionamento)
├── CHEATSHEET.md               # Atalhos rapidos
├── SETUP.md                    # Este arquivo
└── lua/
    └── plugins/
        ├── colorscheme.lua     # Tema Catppuccin Mocha
        ├── treesitter.lua      # Syntax highlighting via treesitter
        ├── telescope.lua       # Fuzzy finder
        ├── lsp.lua             # LSP + Mason (language servers)
        ├── completion.lua      # Autocompletion (nvim-cmp + LuaSnip)
        ├── ui.lua              # Lualine, gitsigns, which-key, indent guides
        └── editor.lua          # Neo-tree, autopairs, comments, formatter, tmux nav
```

## Plugins Instalados (30 total)

### Gerenciador de Plugins
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Gerenciador de plugins moderno | [Docs](https://lazy.folke.io/) |

### Tema e Visual
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Tema Catppuccin (flavour: mocha) | [README](https://github.com/catppuccin/nvim#readme) |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline bonita e configuravel | [README](https://github.com/nvim-lualine/lualine.nvim#readme) |
| [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | Icones para arquivos (requer Nerd Font) | [README](https://github.com/nvim-tree/nvim-web-devicons#readme) |
| [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Guias visuais de indentacao | [README](https://github.com/lukas-reineke/indent-blankline.nvim#readme) |

### Syntax e Parsing
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Gerenciador de parsers treesitter | [README](https://github.com/nvim-treesitter/nvim-treesitter#readme) |

> **Nota sobre Treesitter:** No nvim 0.11+, o highlight e indent por treesitter sao built-in.
> O plugin apenas gerencia a instalacao dos parsers. Parsers sao instalados automaticamente
> ao abrir um arquivo de cada linguagem pela primeira vez. Voce tambem pode instalar manualmente
> com `:TSInstall <linguagem>`.

### Fuzzy Finder
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder extensivel | [README](https://github.com/nvim-telescope/telescope.nvim#readme) |
| [nvim-telescope/telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Algoritmo FZF nativo (performance) | [README](https://github.com/nvim-telescope/telescope-fzf-native.nvim#readme) |
| [nvim-telescope/telescope-ui-select.nvim](https://github.com/nvim-telescope/telescope-ui-select.nvim) | Substitui vim.ui.select por telescope | [README](https://github.com/nvim-telescope/telescope-ui-select.nvim#readme) |
| [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Biblioteca de utilidades Lua (dependencia) | [README](https://github.com/nvim-lua/plenary.nvim#readme) |

### LSP (Language Server Protocol)
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Configuracoes pre-feitas para LSP servers | [Docs](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md) |
| [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim) | Instalador de LSP servers, formatadores, linters | [README](https://github.com/mason-org/mason.nvim#readme) |
| [mason-org/mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Ponte entre mason e lspconfig | [README](https://github.com/mason-org/mason-lspconfig.nvim#readme) |
| [j-hui/fidget.nvim](https://github.com/j-hui/fidget.nvim) | Indicador de progresso do LSP | [README](https://github.com/j-hui/fidget.nvim#readme) |

**LSP Servers pre-instalados:**
- `lua_ls` — Lua (configurado para entender a API do Neovim)
- `ts_ls` — TypeScript/JavaScript
- `pyright` — Python

Para adicionar mais: edite `ensure_installed` em `lua/plugins/lsp.lua` ou use `:Mason` interativamente.

### Autocompletion
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Engine de autocompletion | [Wiki](https://github.com/hrsh7th/nvim-cmp/wiki) |
| [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | Source: sugestoes do LSP | - |
| [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Source: palavras do buffer atual | - |
| [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path) | Source: caminhos de arquivos | - |
| [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Engine de snippets | [Docs](https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md) |
| [saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) | Source: snippets do LuaSnip | - |
| [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Colecao de snippets prontos (VS Code style) | [README](https://github.com/rafamadriz/friendly-snippets#readme) |

### Editor
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer em arvore | [Wiki](https://github.com/nvim-neo-tree/neo-tree.nvim/wiki) |
| [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim) | Componentes de UI (dependencia do Neo-tree) | - |
| [christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Ctrl+h/j/k/l navega entre nvim e tmux | [README](https://github.com/christoomey/vim-tmux-navigator#readme) |
| [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Fecha parenteses, colchetes, aspas | [README](https://github.com/windwp/nvim-autopairs#readme) |
| [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim) | Comentar/descomentar com gcc/gc | [README](https://github.com/numToStr/Comment.nvim#readme) |
| [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Destaca TODO, FIX, HACK nos comentarios | [README](https://github.com/folke/todo-comments.nvim#readme) |
| [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | Formatacao de codigo (format on save) | [README](https://github.com/stevearc/conform.nvim#readme) |

### Git
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Sinais de git na coluna lateral | [README](https://github.com/lewis6991/gitsigns.nvim#readme) |

### Utilidades
| Plugin | Descricao | Docs |
|--------|-----------|------|
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | Popup mostrando atalhos disponiveis | [README](https://github.com/folke/which-key.nvim#readme) |

## Opcoes do Editor (init.lua)

| Opcao | Valor | O que faz |
|-------|-------|-----------|
| `number` | true | Mostra numeros de linha |
| `relativenumber` | true | Numeros relativos (facilita movimentacao) |
| `mouse` | "a" | Mouse habilitado em todos os modos |
| `clipboard` | "unnamedplus" | Compartilha clipboard com o sistema |
| `undofile` | true | Historico de undo persiste entre sessoes |
| `ignorecase` / `smartcase` | true | Busca case-insensitive, exceto se usar maiuscula |
| `tabstop` / `shiftwidth` | 2 | Indentacao de 2 espacos |
| `expandtab` | true | Usa espacos em vez de tabs |
| `scrolloff` | 10 | Mantem 10 linhas de contexto acima/abaixo do cursor |
| `termguicolors` | true | Cores 24-bit no terminal |
| `inccommand` | "split" | Preview ao vivo de substituicoes (:%s) |
| `wrap` | false | Nao quebra linhas longas |

## Formatadores Configurados (Conform)

| Linguagem | Formatador |
|-----------|-----------|
| Lua | stylua |
| Python | black |
| JS/TS/JSX/TSX | prettierd (fallback: prettier) |

Formatacao roda automaticamente ao salvar. Para adicionar mais, edite `lua/plugins/editor.lua`.

## Dependencias Externas

Certifique-se de ter instalado:

| Ferramenta | Para que serve | Instalar |
|-----------|----------------|----------|
| Neovim >= 0.12 | Editor | `brew install neovim` |
| Git >= 2.19 | Plugins e treesitter | `brew install git` |
| ripgrep | Live grep no Telescope | `brew install ripgrep` |
| fd | Find files no Telescope | `brew install fd` |
| JetBrainsMono Nerd Font | Icones no terminal/nvim | Ja instalada em ~/Library/Fonts |
| Node.js | LSP servers (ts_ls, pyright) | `brew install node` |
| Python 3 | LSP pyright | `brew install python` |
| stylua | Formatador Lua | `brew install stylua` |
| prettierd / prettier | Formatador JS/TS | `npm i -g @fsouza/prettierd` |
| black | Formatador Python | `pip install black` |
| C compiler (cc) | Compilar parsers treesitter | Xcode Command Line Tools |

## Configuracao Relacionada

### Ghostty (`~/.config/ghostty/config`)
- Fonte: `JetBrainsMono Nerd Font Mono` tamanho 14
- Tema: catppuccin-mocha

### Tmux (`~/.tmux.conf`)
- Tema: Catppuccin Mocha (manual)
- Navegacao integrada com nvim via Ctrl+h/j/k/l
- Terminal overrides para RGB (alacritty, xterm-256color, kitty, ghostty)

## Recursos para Aprender

- [Neovim Docs](https://neovim.io/doc/) — Documentacao oficial do Neovim
- [lazy.nvim Docs](https://lazy.folke.io/) — Como configurar e usar o lazy.nvim
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — Config de referencia educativa (inspiracao deste setup)
- [Neovim from Scratch (playlist)](https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ) — Serie de videos
- [ThePrimeagen - Neovim](https://www.youtube.com/results?search_query=theprimeagen+neovim) — Videos praticos e divertidos
- [TJ DeVries (core maintainer)](https://www.youtube.com/@teej_dv) — Canal do criador do Telescope
- `:help` dentro do nvim — A melhor referencia, sempre atualizada
- `:Tutor` dentro do nvim — Tutorial interativo para iniciantes
