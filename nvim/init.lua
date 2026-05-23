-- Leader (antes de tudo)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.wrap = false

-- Autocomplete nativo (nvim 0.12)
vim.opt.autocomplete = true
vim.opt.completeopt = "menu,menuone,noinsert,nearest"

-- Keymaps globais
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics quicklist" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Terminal manager
local terminals = {} -- { { buf = N, label = "workdir" }, ... }
local term_win = nil

local function get_visible_term_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    for _, t in ipairs(terminals) do
      if t.buf == buf then return win, t end
    end
  end
  return nil, nil
end

local function clean_terminals()
  terminals = vim.tbl_filter(function(t)
    return vim.api.nvim_buf_is_valid(t.buf)
  end, terminals)
end

local function open_term_split(term)
  local h = math.max(math.floor(vim.o.lines * 0.2), 5)
  vim.cmd("botright " .. h .. "split")
  vim.api.nvim_set_current_buf(term.buf)
  vim.cmd.startinsert()
  term_win = vim.api.nvim_get_current_win()
end

-- Slots fixos que sempre aparecem na statusline
local term_slots = {
  { label = "pwd", key = "SPC ft", buf = nil },
  { label = "~",   key = "SPC fT", buf = nil },
}

local function create_terminal(label, key, cwd)
  local h = math.max(math.floor(vim.o.lines * 0.2), 5)
  vim.cmd("botright " .. h .. "split")
  if cwd then vim.cmd("lcd " .. cwd) end
  vim.cmd.terminal()
  local buf = vim.api.nvim_get_current_buf()
  term_win = vim.api.nvim_get_current_win()
  -- Associar ao slot correspondente
  for _, slot in ipairs(term_slots) do
    if slot.label == label then
      slot.buf = buf
      break
    end
  end
  table.insert(terminals, { buf = buf, label = label })
  vim.cmd.startinsert()
end

-- <leader>/ — toggle: esconde/mostra o ultimo terminal visivel
vim.keymap.set({ "n", "t" }, "<leader>/", function()
  clean_terminals()
  local win = get_visible_term_win()
  if win then
    vim.api.nvim_win_close(win, true)
    term_win = nil
    return
  end
  -- Reabrir o ultimo terminal, ou criar um novo
  if #terminals > 0 then
    open_term_split(terminals[#terminals])
  else
    create_terminal("pwd", "SPC ft")
  end
end, { desc = "Toggle terminal" })

-- <leader>ft — terminal no pwd
vim.keymap.set("n", "<leader>ft", function()
  clean_terminals()
  local win = get_visible_term_win()
  if win then vim.api.nvim_win_close(win, true) end
  for _, t in ipairs(terminals) do
    if t.label == "pwd" and vim.api.nvim_buf_is_valid(t.buf) then
      open_term_split(t)
      return
    end
  end
  create_terminal("pwd", "SPC ft")
end, { desc = "Terminal (pwd)" })

-- <leader>fT — terminal no ~
vim.keymap.set("n", "<leader>fT", function()
  clean_terminals()
  local win = get_visible_term_win()
  if win then vim.api.nvim_win_close(win, true) end
  for _, t in ipairs(terminals) do
    if t.label == "~" and vim.api.nvim_buf_is_valid(t.buf) then
      open_term_split(t)
      return
    end
  end
  create_terminal("~", "SPC fT", "~")
end, { desc = "Terminal (~)" })

-- Helper: checa se um terminal esta visivel
local function is_term_visible(t)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == t.buf then return true end
  end
  return false
end

-- Click handler pra lualine (por slot index)
function _G.term_click(idx)
  clean_terminals()
  local slot = term_slots[idx]
  if not slot then return end
  -- Se nao tem terminal nesse slot, cria
  if not slot.buf or not vim.api.nvim_buf_is_valid(slot.buf) then
    local win = get_visible_term_win()
    if win then vim.api.nvim_win_close(win, true) end
    local cwd = slot.label == "~" and "~" or nil
    create_terminal(slot.label, slot.key, cwd)
    return
  end
  -- Se ta visivel, fecha
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == slot.buf then
      vim.api.nvim_win_close(win, true)
      return
    end
  end
  -- Se ta escondido, abre
  local win = get_visible_term_win()
  if win then vim.api.nvim_win_close(win, true) end
  open_term_split({ buf = slot.buf, label = slot.label })
end

-- Highlights pro indicador de terminal
vim.api.nvim_set_hl(0, "TermActive", { fg = "#1e1e2e", bg = "#a6e3a1", bold = true })
vim.api.nvim_set_hl(0, "TermHidden", { fg = "#cdd6f4", bg = "#313244" })
vim.api.nvim_set_hl(0, "TermSlot", { fg = "#6c7086", bg = "#181825" })

-- PackChanged hooks (rodar antes do vim.pack.add)
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})

-- Plugins via vim.pack (nvim 0.12 built-in)
vim.pack.add({
  -- Fuzzy finder
  "https://github.com/nvim-lua/plenary.nvim",
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = vim.version.range("0.1.x") },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", name = "telescope-fzf-native" },
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",
  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",
  -- UI
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/folke/todo-comments.nvim",
  -- Editor
  "https://github.com/nvim-neo-tree/neo-tree.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/stevearc/conform.nvim",
  -- Snippets
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rafamadriz/friendly-snippets",
})

-- Tema (catppuccin built-in no nvim 0.12, mocha = dark)
vim.opt.background = "dark"
vim.cmd.colorscheme("catppuccin")

-- Telescope
local telescope = require("telescope")
telescope.setup({
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown() },
  },
})
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep word" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Old files" })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Buffers" })

-- LSP nativo (sem Mason — servers instalados via brew/npm)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end
    map("gd", builtin.lsp_definitions, "Goto Definition")
    map("gr", builtin.lsp_references, "Goto References")
    map("gI", builtin.lsp_implementations, "Goto Implementation")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("<leader>D", builtin.lsp_type_definitions, "Type Definition")
    map("<leader>ds", builtin.lsp_document_symbols, "Document Symbols")
    map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")
  end,
})

vim.lsp.enable({ "lua_ls", "ts_ls", "pyright" })

-- Lualine (auto detecta o colorscheme ativo)
require("lualine").setup({
  options = {
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = {
      {
        function()
          local slot = term_slots[1]
          local has_buf = slot.buf and vim.api.nvim_buf_is_valid(slot.buf)
          local icon = has_buf and (is_term_visible({ buf = slot.buf }) and " " or " ") or " "
          return "%1@v:lua.term_click@" .. icon .. slot.label .. " " .. slot.key .. "%X"
        end,
        color = function()
          local slot = term_slots[1]
          local has_buf = slot.buf and vim.api.nvim_buf_is_valid(slot.buf)
          if has_buf and is_term_visible({ buf = slot.buf }) then
            return { fg = "#1e1e2e", bg = "#a6e3a1", gui = "bold" }
          elseif has_buf then
            return { fg = "#cdd6f4", bg = "#313244" }
          end
          return { fg = "#6c7086", bg = "#181825" }
        end,
      },
      {
        function()
          local slot = term_slots[2]
          local has_buf = slot.buf and vim.api.nvim_buf_is_valid(slot.buf)
          local icon = has_buf and (is_term_visible({ buf = slot.buf }) and " " or " ") or " "
          return "%2@v:lua.term_click@" .. icon .. slot.label .. " " .. slot.key .. "%X"
        end,
        color = function()
          local slot = term_slots[2]
          local has_buf = slot.buf and vim.api.nvim_buf_is_valid(slot.buf)
          if has_buf and is_term_visible({ buf = slot.buf }) then
            return { fg = "#1e1e2e", bg = "#a6e3a1", gui = "bold" }
          elseif has_buf then
            return { fg = "#cdd6f4", bg = "#313244" }
          end
          return { fg = "#6c7086", bg = "#181825" }
        end,
      },
      "encoding", "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- Gitsigns
require("gitsigns").setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})

-- Which-key
require("which-key").setup({
  win = {
    border = "rounded",
    no_overlap = false,
    col = math.huge,
    row = 1,
    width = { min = 30, max = 50 },
    height = { min = 4, max = 25 },
    padding = { 1, 2 },
  },
  layout = {
    width = { min = 20 },
    spacing = 2,
  },
  spec = {
    { "<leader>f", group = "Find/Files" },
    { "<leader>d", group = "Document" },
    { "<leader>w", group = "Workspace" },
    { "<leader>c", group = "Code" },
    { "<leader>r", group = "Rename" },
    { "<leader>/", desc = "Toggle terminal" },
    { "<leader>e", desc = "File explorer" },
    { "<leader>q", desc = "Diagnostics quicklist" },
    { "<leader>D", desc = "Type definition" },
  },
})

-- Indent guides
require("ibl").setup()

-- Todo comments
require("todo-comments").setup()

-- Neo-tree
require("neo-tree").setup({
  filesystem = { filtered_items = { visible = true } },
})
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- Autopairs
require("nvim-autopairs").setup()

-- Comment
require("Comment").setup()

-- Conform (formatacao)
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
})
vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Snippets
require("luasnip.loaders.from_vscode").lazy_load()
