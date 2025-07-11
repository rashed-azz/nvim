return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Languages to install
      ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "python",
        "bash",
        "json",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "vim",
        "vimdoc",
        "query",
      },

      -- Install languages synchronously (only on first run)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",            -- Start selection
          node_incremental = "<CR>",          -- Expand node
          scope_incremental = "<TAB>",        -- Expand to scope
          node_decremental = "<BS>",          -- Shrink node
        },
      },

      -- Optional textobjects (function/class selection)
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    })
  end,
}

