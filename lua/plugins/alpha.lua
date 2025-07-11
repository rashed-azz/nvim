return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Figlet ansi shadow style header - centered and properly colored
    --dashboard.section.header.val = {
    --  [[                                                  ]],
    --  [[                                                  ]],
    --  [[                                                  ]],
    --  [[                                                  ]],
    --  [[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
    --  [[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
    --  [[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
    --  [[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
    --  [[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
    --  [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
    --  [[                                                  ]],
    --}

    dashboard.section.header.val = {
        [[                                 ]],
        [[                                 ]],
        [[                                 ]],
        [[           ▄ ▄                   ]],
        [[       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ]],
        [[       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ]],
        [[    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ]],
        [[  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ]],
        [[  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄]],
        [[▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █]],
        [[█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █]],
        [[    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ]],
      }
    -- Enhanced dashboard buttons with proper icons
    dashboard.section.buttons.val = {
      dashboard.button("e", "󰈔  New File", "<cmd>ene<CR>"),
      dashboard.button("f", "󰱼  Find Files", "<cmd>Telescope find_files<CR>"),
      dashboard.button("r", "󱋢  Recent Files", "<cmd>Telescope oldfiles<CR>"),
      dashboard.button("g", "󰺮  Find Text", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("p", "󰉋  Projects", "<cmd>Telescope projects<CR>"),
      dashboard.button("s", "󰒓  Settings", "<cmd>e $MYVIMRC<CR>"),
      dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
      dashboard.button("u", "󰂖  Update Plugins", "<cmd>Lazy update<CR>"),
      dashboard.button("h", "󰓙  Health Check", "<cmd>checkhealth<CR>"),
      dashboard.button("q", "󰈆  Quit", "<cmd>qa<CR>"),
    }

    -- Simple footer
    dashboard.section.footer.val = {
      os.date("%Y-%m-%d"),
    }

    -- Apply Tokyo Night gradient colors to header
    local function apply_gradient()
      -- Define Tokyo Night colors
      local colors = {
        "#7aa2f7", -- Blue
        "#73daca", -- Teal  
        "#bb9af7", -- Purple
        "#f7768e", -- Red
        "#e0af68", -- Yellow
        "#9ece6a", -- Green
      }

      -- Create highlight groups
      for i, color in ipairs(colors) do
        vim.cmd(string.format("highlight TokyoGradient%d guifg=%s gui=bold", i, color))
      end
    end

    -- Set header highlight
    dashboard.section.header.opts.hl = "TokyoGradient1"
    dashboard.section.buttons.opts.hl = "Keyword"
    dashboard.section.footer.opts.hl = "Comment"

    -- Layout configuration - reduced padding to fit screen
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    -- Apply colors after setup
    alpha.setup(dashboard.config)
    
    -- Apply gradient colors
    vim.defer_fn(function()
      apply_gradient()
      
      -- Apply gradient to each line of header
      for i = 1, #dashboard.section.header.val do
        local line_hl = "TokyoGradient" .. ((i % 6) + 1)
        vim.api.nvim_set_hl(0, "AlphaHeader" .. i, { fg = ({
          "#7aa2f7", "#73daca", "#bb9af7", "#f7768e", "#e0af68", "#9ece6a"
        })[(i % 6) + 1], bold = true })
      end
    end, 100)

    -- Clean autocmds - simplified to prevent lag
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function()
        vim.opt_local.showtabline = 0
        vim.opt_local.laststatus = 0
      end,
    })

    vim.api.nvim_create_autocmd("BufUnload", {
      buffer = 0,
      callback = function()
        vim.opt.showtabline = 2
        vim.opt.laststatus = 3
      end,
    })
  end,
}
