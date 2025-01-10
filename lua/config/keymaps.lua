local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local function omap(mode, l, r, opts)
  opts = opts or {}
  vim.keymap.set(mode, l, r, opts)
end

---------------------
--- general
---------------------

map({ "n", "x" }, "y", '"+y', { noremap = true }) -- yank to clipboard implicitly
map("n", "dfi", "f{a <cr><esc>O", { noremap = true, silent = true })
map("n", "<leader>t", "<cmd>ToggleTerm size=40 direction=float name=terminal<cr>", { desc = "Terminal (root dir)" })

omap("n", "<leader>q<cr>", ":bd<cr>", { desc = "Close", remap = true, silent = true })
omap("n", "<leader>qq", ":qa<cr>", { desc = "Close all", remap = true, silent = true })
omap("n", "<leader>aq", ":qa<cr>", { desc = "Close all", remap = true, silent = true })
omap("n", "<leader>w<cr>", ":w<cr>", { desc = "Save", remap = true, silent = true })
omap("n", "<leader>w", ":w<cr>", { desc = "Save", remap = true, silent = true })
omap("n", "<leader>aw", ":wa<cr>", { desc = "Save all", remap = true, silent = true })

---------------------
--- telescope
---------------------

local builtin = require("telescope.builtin")
map("n", "<leader>sf", builtin.find_files, { desc = "Find files (telescope)" })
map("n", "<leader>sag", ":Telescope live_grep_args<cr>", { desc = "Live Grep (args)" })

-- nvim-lspconfig
map("n", "<leader>D", vim.diagnostic.open_float, { desc = "Open diagnostics" })
map("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Set loclist" })
map("n", "<leader>do", vim.lsp.buf.code_action, { desc = "Code action" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    map("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Goto Declaration" })
    map("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Goto Definition" })
    map("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Check References" })
    map("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover definition" })
    map("n", "<space>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
    map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
    map("n", "<space>fmt", function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = ev.buf, desc = "Format" })
  end,
})

---------------------
--- windows
---------------------

map("n", "<leader>pw", "<C-W>p", { desc = "Previous window", remap = true })
-- map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>\\", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>h", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("n", "<leader>j", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("n", "<leader>k", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("n", "<leader>l", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("n", "<leader>=", "<C-W>=", { desc = "Resize windows" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-k>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-l>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-h>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<F3>", "<cmd>WindowsMaximize<cr>", { desc = "Maximize window" })

---------------------
--- bufferline
---------------------

for i = 1, 9 do
  map({ "n", "i" }, "<A-" .. i .. ">", ":b " .. i .. "<CR>", { desc = "Switch to buffer " .. i })
  map(
    { "n", "i" },
    "<A-" .. i .. ">",
    '<cmd>lua require("bufferline").go_to(' .. i .. ", true)<cr>",
    { desc = "Switch to buffer " .. i }
  )
end

---------------------
--- dap
---------------------
-- persistent breakpoints https://github.com/mfussenegger/nvim-dap/issues/198
map("n", "<leader>ddb", "<cmd>lua require'dap'.clear_breakpoints()<cr>", { desc = "clear breakpoints" })
