return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- nvim 0.11+ has built-in treesitter highlight/indent
      -- This plugin manages parser installation
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = args.match
          -- Map common filetypes to treesitter parser names
          local ft_to_lang = {
            typescript = "typescript",
            typescriptreact = "tsx",
            javascript = "javascript",
            javascriptreact = "javascript",
            python = "python",
            lua = "lua",
            bash = "bash",
            sh = "bash",
            zsh = "bash",
            json = "json",
            yaml = "yaml",
            html = "html",
            css = "css",
            markdown = "markdown",
            vim = "vim",
            help = "vimdoc",
            toml = "toml",
            rust = "rust",
            go = "go",
            c = "c",
          }
          local lang = ft_to_lang[ft] or ft
          local ok = pcall(vim.treesitter.start, 0, lang)
          if not ok then
            -- Parser not installed yet, trigger auto install
            pcall(require("nvim-treesitter").install, { lang })
          end
        end,
      })
    end,
  },
}
