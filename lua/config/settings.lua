-- Core Neovim settings
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers
vim.opt.mouse = 'a'             -- Diable mouse
vim.opt.mousemoveevent = true   -- (optional) better UX
vim.opt.ignorecase = false      -- Case sensitive searching by default
vim.opt.smartcase = false       -- Disable smartcase
vim.opt.hlsearch = true         -- Highlight search results
vim.opt.wrap = false            -- Don't wrap lines
vim.opt.breakindent = true      -- Preserve indentation in wrapped text
vim.opt.tabstop = 4             -- Number of spaces for tab
vim.opt.shiftwidth = 4          -- Number of spaces for indentation
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.autoindent = true       -- Auto indent new lines
vim.opt.smartindent = true      -- Smart indentation
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.undofile = true         -- Persistent undo
vim.opt.updatetime = 250        -- Faster completion
vim.opt.timeoutlen = 300        -- Faster key sequence completion
vim.opt.termguicolors = true    -- True color support
vim.g.netrw_banner = 0
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.scrolloff = 6
vim.opt.signcolumn = "yes"

-- Cursor settings
vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50'

-- Set leader key
vim.g.mapleader = ' '
vim.o.showtabline = 2 -- always show tabline

vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.TabLine()"

function _G.TabLine()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local tab = (i == vim.fn.tabpagenr()) and "%#TabLineSel#" or "%#TabLine#"

    local winnr = vim.fn.tabpagewinnr(i)
    local buflist = vim.fn.tabpagebuflist(i)
    local bufnr = buflist[winnr]
    local name = vim.fn.bufname(bufnr or 0)

    local filename = vim.fn.fnamemodify(name, ":t")
    if filename == "" then filename = "[No Name]" end

    s = s .. tab .. " " .. filename .. " "
  end
  return s .. "%#TabLineFill#"
end

-- highlight cursorline 
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "LineNr", { fg = "yellow", bold = true })
-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFD700", bold = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  pattern = "*",
  command = "setlocal cursorline",
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  pattern = "*",
  command = "setlocal nocursorline",
})

-- Auto save function
local function auto_save()
  if vim.bo.modified and vim.bo.buftype == "" and vim.bo.readonly == false then
    vim.cmd("silent! write")
  end
end

-- Auto save when Neovim loses focus to another application
vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  callback = auto_save,
})

-- Auto save when switching between Neovim windows/buffers
vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
  pattern = "*",
  callback = auto_save,
})

