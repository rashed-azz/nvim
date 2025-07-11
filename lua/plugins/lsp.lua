-- lua/plugins/lsp.lua
return {
  ----------------------------------------------------------------------------
  -- 1. Mason + lspconfig -----------------------------------------------------
  ----------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      ------------------------------------------------------------------------
      -- Diagnostics look & feel ---------------------------------------------
      ------------------------------------------------------------------------
      vim.diagnostic.config({
        virtual_text = {
          spacing = 2,
          prefix = "●",      -- "■", "▎", "", "" …
          severity_sort = true,
        },
        float  = false,      -- don't auto‑show hover
        signs  = false,
        underline = true,
        update_in_insert = false,
      })
      
      ------------------------------------------------------------------------
      -- 1‑second CursorHold delay → hover float (only if diagnostic at cursor)
      ------------------------------------------------------------------------
      vim.o.updatetime = 1000   -- 1000 ms of no keys → CursorHold
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          -- Only show float if there's a diagnostic at the current cursor position
          local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
          if #line_diagnostics > 0 then
            -- Check if cursor is actually on a word with a diagnostic
            local col = vim.fn.col(".") - 1
            local has_diagnostic_at_cursor = false

            for _, diagnostic in ipairs(line_diagnostics) do
              if col >= diagnostic.col and col <= diagnostic.end_col then
                has_diagnostic_at_cursor = true
                break
              end
            end

            if has_diagnostic_at_cursor then
              vim.diagnostic.open_float(nil, {
                focus   = false,       -- don't grab cursor
                header  = "",          -- no "Diagnostics" header
                border  = "rounded",   -- "single", "double", "none", etc.
                source  = "if_many",   -- show LSP name if multiple
              })
            end
          end
        end,
      })
      
      -- ── TokyoNight diagnostic colors ─────────────────────────────────────────
      local tn = {
        error   = "#F7768E",
        warn    = "#E0AF68",
        info    = "#7AA2F7",
        hint    = "#9ECE6A",
        bg_none = "none",
      }
      
      -- Apply diagnostic colors
      local function apply_diagnostic_colors()
        for _, grp in ipairs {
          { "Error",   tn.error },
          { "Warn",    tn.warn  },
          { "Info",    tn.info  },
          { "Hint",    tn.hint  },
        } do
          local name, col = unpack(grp)
          vim.api.nvim_set_hl(0, "Diagnostic"          .. name, { fg = col })
          vim.api.nvim_set_hl(0, "DiagnosticVirtualText" .. name, { fg = col, bg = tn.bg_none })
          vim.api.nvim_set_hl(0, "DiagnosticUnderline"   .. name, { undercurl = true, sp = col })
          vim.api.nvim_set_hl(0, "DiagnosticSign"        .. name, { fg = col, bg = tn.bg_none })
        end
      end
      
      -- Apply once right now
      apply_diagnostic_colors()
      
      -- Re-apply on every colorscheme change
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = apply_diagnostic_colors,
      })
      
      ------------------------------------------------------------------------
      -- Mason & LSP setup ---------------------------------------------------
      ------------------------------------------------------------------------
      local lspconfig = require("lspconfig")
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "bashls", "jsonls" },
        automatic_installation = false,
        handlers = {
          -- Default handler
          function(server_name)
            lspconfig[server_name].setup({})
          end,
          -- Lua
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              settings = {
                Lua = {
                  workspace = {
                    checkThirdParty = false,
                  },
                  -- Enable workspace diagnostics
                  diagnostics = {
                    workspaceDelay = 1000,
                    workspaceEvent = "OnChange",
                  },
                }
              }
            })
          end,
          -- Python
          ["pyright"] = function()
            lspconfig.pyright.setup({
              settings = {
                python = {
                  analysis = {
                    -- Enable workspace-wide analysis
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace",
                  }
                }
              }
            })
          end,
        },
      })


    end,
  },
}
-- working 100%
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     event = { "BufReadPre", "BufNewFile" },
--     dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
--     config = function()
--       local lspconfig = require("lspconfig")
--       
--       -- Mason setup
--       require("mason").setup()
--       require("mason-lspconfig").setup({
--         ensure_installed = { "lua_ls", "pyright", "bashls", "jsonls" },
--         automatic_installation = false,
--         handlers = {
--           -- Default handler for all servers
--           function(server_name)
--             lspconfig[server_name].setup({})
--           end,
--           -- Custom handler for specific servers
--           ["lua_ls"] = function()
--             lspconfig.lua_ls.setup({
--               -- Add lua_ls specific settings here if needed
--             })
--           end,
--           ["pyright"] = function()
--             lspconfig.pyright.setup({
--               -- Add pyright specific settings here if needed
--             })
--           end,
--         }
--       })
--     end,
--   },
-- }
