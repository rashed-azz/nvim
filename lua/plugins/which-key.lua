return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    
    wk.setup({
      disable = {
        buftypes = {},
        filetypes = {},
      },
      -- Use the new triggers format instead of deprecated triggers_blacklist
      triggers = {
        -- Only enable which-key for normal mode with leader keys
        -- This avoids the visual mode issues you were having
        { "<leader>", mode = { "n" } },
      },
      plugins = {
        presets = {
          operators = false, -- Disable for operators like d, y, c (includes v for visual)
          motions = false,   -- Disable for motions
          text_objects = false,
          windows = false,
          nav = false,
          z = false,
          g = false,
        },
      },
    })
    
    wk.add({
      { "<leader>b", group = "buffer" },
      { "<leader>f", group = "file" },
      { "<leader>g", group = "git" },
      { "<leader>d", group = "debug" },
    })
  end,
}
