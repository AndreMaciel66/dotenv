# Neovim Cheatsheet

> Leader key: `Space`
> Pressione `Space` e espere para ver o which-key com todos os atalhos disponiveis.

## Navegacao Geral

| Atalho              | Acao                                    |
|---------------------|-----------------------------------------|
| `Esc`               | Limpa highlight de busca                |
| `Space q`           | Abre lista de diagnosticos (quicklist)  |
| `Esc Esc`           | Sai do modo terminal                   |
| `Ctrl+h/j/k/l`     | Navega entre paineis (nvim + tmux)      |

## Telescope (Fuzzy Finder)

| Atalho              | Acao                                    |
|---------------------|-----------------------------------------|
| `Space ff`          | Buscar arquivos                         |
| `Space fg`          | Buscar texto (live grep)                |
| `Space fb`          | Listar buffers abertos                  |
| `Space fh`          | Buscar na documentacao (help tags)      |
| `Space fw`          | Buscar palavra sob o cursor (grep)      |
| `Space fd`          | Listar diagnosticos                     |
| `Space fr`          | Retomar ultima busca                    |
| `Space fo`          | Arquivos recentes                       |
| `Space Space`       | Listar buffers (atalho rapido)          |

## LSP (Language Server Protocol)

| Atalho              | Acao                                    |
|---------------------|-----------------------------------------|
| `gd`                | Ir para definicao                       |
| `gr`                | Ver referencias                         |
| `gI`                | Ir para implementacao                   |
| `gD`                | Ir para declaracao                      |
| `K`                 | Hover - documentacao inline             |
| `Space rn`          | Renomear simbolo                        |
| `Space ca`          | Code actions                            |
| `Space D`           | Type definition                         |
| `Space ds`          | Simbolos do documento                   |
| `Space ws`          | Simbolos do workspace                   |

## File Explorer (Neo-tree)

| Atalho              | Acao                                    |
|---------------------|-----------------------------------------|
| `Space e`           | Toggle file explorer                    |

Dentro do Neo-tree:
- `a` = criar arquivo/pasta
- `d` = deletar
- `r` = renomear
- `c` = copiar
- `m` = mover
- `Enter` = abrir arquivo
- `H` = toggle arquivos ocultos
- `?` = ajuda

## Autocompletion (nvim-cmp)

| Atalho              | Acao                                    |
|---------------------|-----------------------------------------|
| `Ctrl+n`            | Proximo item                            |
| `Ctrl+p`            | Item anterior                           |
| `Ctrl+y`            | Confirmar selecao                       |
| `Ctrl+Space`        | Abrir menu de completion                |
| `Ctrl+b / Ctrl+f`   | Scroll na documentacao                  |
| `Ctrl+l`            | Pular para proximo campo do snippet     |
| `Ctrl+h`            | Voltar para campo anterior do snippet   |

## Formatacao (Conform)

| Atalho              | Acao                                    |
|---------------------|-----------------------------------------|
| `Space cf`          | Formatar buffer                         |
| (auto)              | Formata ao salvar (:w)                  |

## Comentarios (Comment.nvim)

| Atalho              | Acao                                    |
|---------------------|-----------------------------------------|
| `gcc`               | Comentar/descomentar linha              |
| `gc` (visual)       | Comentar/descomentar selecao            |
| `gcb`               | Comentar em bloco                       |

## Git (Gitsigns)

Os sinais aparecem automaticamente na coluna lateral:
- `│` = linha adicionada/modificada
- `󰍵` = linha deletada

## Comandos Uteis

| Comando             | Acao                                    |
|---------------------|-----------------------------------------|
| `:Lazy`             | Painel do gerenciador de plugins        |
| `:Lazy sync`        | Atualizar todos os plugins              |
| `:Mason`            | Painel do gerenciador de LSP servers    |
| `:TSInstall <lang>` | Instalar parser treesitter              |
| `:ConformInfo`      | Ver formatadores configurados           |
| `:checkhealth`      | Verificar saude do nvim                 |

## Todo Comments

Comentarios com prefixos especiais sao destacados automaticamente:
- `TODO:` `HACK:` `WARN:` `PERF:` `NOTE:` `FIX:`
