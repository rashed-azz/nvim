-- Key mappings

-- Clear search highlighting
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Better navigation in insert mode
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-l>', '<Right>')
-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- settings shortcuts
vim.keymap.set("n", "<leader><leader>vcp", ":vs ~/.config/nvim/lua/plugins<CR>", { desc = "Open vim config plugins" })
vim.keymap.set("n", "<leader><leader>vck", ":vs ~/.config/nvim/lua/config/keymaps.lua<CR>", { desc = "Open vim config keymaps" })
vim.keymap.set("n", "<leader><leader>vcs", ":vs ~/.config/nvim/lua/config/settings.lua<CR>", { desc = "Open vim config settings" })


-- terminal settings
vim.keymap.set("n", "<leader>tv", ":vs | terminal<CR>A", { desc = "Open terminal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal" })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set('t', ':', '<C-\\><C-n>:')
vim.keymap.set('n', '<leader>trp', '<C-w>lA<C-p><CR><C-\\><C-n><C-w>h', { desc = "(t)erminal (r)un (p)revious command" })

-- tabs
vim.keymap.set("n", "<leader>tl", ":tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader>th", ":tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close Tab" })

-- Buffer management keymaps
vim.keymap.set("n", "<leader>l", ":bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>h", ":bprevious<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete!<CR>", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>ba", ":buffers<CR>", { desc = "List All Buffers" })

-- Vertical split and open file under cursor (like gf)
vim.keymap.set("n", "<leader>v", ":vsplit | normal gf<CR>", { desc = "Vertical Split to File" })

-- Horizontal split and open file under cursor (like gf)
vim.keymap.set("n", "<leader>s", ":split | normal gf<CR>", { desc = "Horizontal Split to File" })

-- For init.lua (Lua)
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true })

-- Fixing clipboard
vim.keymap.set("x", "p", '"_dP', { desc = "Paste without overwriting clipboard" })
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set("v", "P", '"_dp', { desc = "Paste before without yanking" })


--  keymap - starts search and 
vim.keymap.set('n', '<leader>r', ':%s//g<Left><Left>', { desc = 'Global search and replace' })
vim.keymap.set("n", "<leader>wdr", ":windo %s//gce<left><left><left><left>", { desc = " in file" })
vim.keymap.set("v", "<leader>r", ":s//g<left><left>", { desc = " in selection" })

-- word replace
vim.keymap.set("n", "<leader>wr", function()
  local word = vim.fn.expand("<cword>")
  local left_key = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
  vim.fn.feedkeys(":%s/" .. word .. "//g" .. left_key .. left_key, "n")
end, { desc = "Replace current word" })

-- window word replace
vim.keymap.set("n", "<leader>wdwr", function()
  local word = vim.fn.expand("<cword>")
  local left_key = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
  vim.fn.feedkeys(":windo %s/" .. word .. "//gce" .. left_key .. left_key .. left_key .. left_key, "n")
end, { desc = "Replace current word" })

-- replace all directory
vim.keymap.set("n", "<leader>adr", function()
  local word = vim.fn.expand("<cword>")
  local replacement = vim.fn.input("Replace '" .. word .. "' with: ")
  if replacement ~= "" then
    -- Save current buffer info
    local current_file = vim.fn.expand("%:p")
    local current_pos = vim.fn.getpos(".")
    
    -- Build args command with only existing file types
    local patterns = {"**/*.py", "**/*.js", "**/*.html", "**/*.css", "**/*.md", "**/*.txt"}
    local existing_patterns = {}
    
    for _, pattern in ipairs(patterns) do
      local files = vim.fn.glob(pattern, false, true)
      if #files > 0 then
        table.insert(existing_patterns, pattern)
      end
    end
    
    if #existing_patterns > 0 then
      vim.cmd("args " .. table.concat(existing_patterns, " "))
      vim.cmd("argdo %s/\\<" .. word .. "\\>/" .. replacement .. "/ge | update")
      
      -- Get list of all files that were processed
      local processed_files = {}
      for i = 1, vim.fn.argc() do
        table.insert(processed_files, vim.fn.fnamemodify(vim.fn.argv(i - 1), ":."))
      end
      
      -- Return to original file
      if current_file ~= "" then
        vim.cmd("edit " .. vim.fn.fnameescape(current_file))
        vim.fn.setpos(".", current_pos)
      end
      
      print("Replaced '" .. word .. "' with '" .. replacement .. "' - searched " .. #processed_files .. " files:")
      print("Files: " .. table.concat(processed_files, ", "))
    else
      print("No matching files found")
    end
  end
end, { desc = "Replace current word in directory" })

-- Move cursor forward/backward after search
vim.keymap.set('n', 'n', 'nzzzv', { desc = "Next search result (centered)" })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Previous search result (centered)" })

-- Toggle comment for current line in normal mode
vim.keymap.set("n", "<leader>c", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment line" })

-- Fix paste
vim.keymap.set('v', 'p', 'P', { desc = "Paste above" })
vim.keymap.set('v', 'P', 'p', { desc = "Paste below" })

-- Toggle comment for visual selection
vim.keymap.set("v", "<leader>c", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment selection" })
