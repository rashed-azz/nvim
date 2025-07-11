-- lua/plugins/navigation.lua
-- Lazy‑spec file that provides breadcrumbs (nvim‑navic) and a fancy winbar (barbecue.nvim).
-- Assumes you already have an LSP client (via nvim‑lspconfig + mason) running.
return {
  ----------------------------------------------------------------------------
  -- 1. nvim‑navic – LSP‑powered breadcrumbs ---------------------------------
  ----------------------------------------------------------------------------
  {
    "SmiteshP/nvim-navic",
    lazy = true, -- loaded only after an LSP attaches
    opts = function()
      -- Optional: map LSP kinds ➜ icons here. Safe to leave empty.
      -- local icons = require("barbecue.utils").kinds
      return {
        highlight = true, -- use syntax highlight groups for each breadcrumb part
        separator = "  ", -- what's between symbols
        -- icons = icons, -- table like { Class = "", Method = "", ... }
      }
    end,
    init = function()
      -- Attach navic whenever any LSP client with documentSymbolProvider starts.
      local navic = require("nvim-navic")
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local buf = args.buf
          if vim.bo[buf].filetype == "NvimTree" then
            return
          end
          if client and client.server_capabilities.documentSymbolProvider then
            navic.attach(client, buf)
          end
        end,
      })
    end,
  },
  ----------------------------------------------------------------------------
  -- 2. barbecue.nvim – pretty winbar built on top of nvim‑navic ------------
  ----------------------------------------------------------------------------
  {
    "utilyre/barbecue.nvim",
    dependencies = {
      "SmiteshP/nvim-navic", -- navic is the engine; barbecue is the UI
      "nvim-tree/nvim-web-devicons", -- optional but recommended for icons
    },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      attach_navic = false, -- we already do it above
      show_modified = true, -- add a ● if buffer is modified
      -- optional customization: let barbecue use its built‑in icon set
      -- kinds = require("barbecue.utils").kinds,
      theme = "auto",      -- inherit from your colorscheme
      create_autocmd = false, -- we'll create our own to avoid duplicates
      exclude_filetypes = { "NvimTree", "nvim-tree" },
    },
    config = function(_, opts)
      require("barbecue").setup(opts)
      
      -- Custom autocmd to handle showing/hiding barbecue
      vim.api.nvim_create_autocmd({ "BufWinEnter", "WinResized", "CursorHold", "InsertLeave" }, {
        callback = function()
          local ft = vim.bo.filetype
          local excluded = { "NvimTree", "nvim-tree" }
          
          -- Hide barbecue for excluded filetypes
          for _, exclude_ft in ipairs(excluded) do
            if ft == exclude_ft then
              vim.wo.winbar = ""
              return
            end
          end
          
          -- Show barbecue for normal files
          if package.loaded["nvim-navic"] then
            local barbecue = require("barbecue.ui")
            barbecue.update()
          end
        end,
      })
    end,
  },
}
