return {
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.5',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      }
    },
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = require('telescope.actions').close,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
          }
        }
      })

      -- Load fzf extension
      require('telescope').load_extension('fzf')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find Files' })
      vim.keymap.set('n', '<leader><leader>f', builtin.live_grep, { desc = 'Grep' })

      -- Diagnostics keymap
      vim.keymap.set('n', '<leader><leader>d', builtin.diagnostics, { desc = 'Show diagnostics' })

      -- LSP keymaps
      vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'Go to definition' })
      vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'Go to references' })
      vim.keymap.set('n', 'gi', builtin.lsp_implementations, { desc = 'Go to implementation' })

    end,
  },
}
