return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    -- 0. Nice breakpoint glyph
    vim.fn.sign_define("DapBreakpoint", {text = "", texthl = "DiagnosticError"})
    -- 1. UI
    dapui.setup({
      layouts = { { elements = { "scopes", "breakpoints", "stacks" }, size = 40, position = "right" } },
    })
    -- 2. Python adapter - Use debug virtual environment
    local debug_python = vim.fn.expand("~/.nvim-debug-env/bin/python")
    require("dap-python").setup(debug_python)
    -- 3. Open/close UI automatically
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    for _, e in ipairs({ "event_terminated", "event_exited" }) do
      dap.listeners.before[e]["dapui_config"] = function() dapui.close() end
    end
    -- 4. Keymaps for Debugging
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP continue" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP step over" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP step into" })
    vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "DAP step out" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "DAP conditional breakpoint" })
    vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP REPL" })
    vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "DAP run last" })
  end,
}
