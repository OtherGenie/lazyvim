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

omap("n", "<leader>q<cr>", ":bd<cr>", { desc = "Close", noremap = true, silent = true })
omap("n", "<leader>qq", ":qa<cr>", { desc = "Close all", noremap = true, silent = true })
-- omap("n", "<leader>aq", ":qa<cr>", { desc = "Close all", noremap = true, silent = true })
omap("n", "<leader>w<cr>", ":w<cr>", { desc = "Save", noremap = true, silent = true })
omap("n", "<leader>w", ":w<cr>", { desc = "Save", noremap = true, silent = true })
omap("n", "<leader>aw", ":wa<cr>", { desc = "Save all", noremap = true, silent = true })
omap("n", "<leader>fn", ":e %:h/", { desc = "New file", noremap = true })

---------------------
--- telescope
---------------------

local builtin = require("telescope.builtin")
map("n", "<leader>sf", builtin.find_files, { desc = "Find files (telescope)" })
map("n", "<leader>gd", builtin.lsp_definitions, { desc = "Goto Definition (Telescope)" })
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
    -- map("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Goto Definition" })
    -- map("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Check References" }) -- TELESCOPED
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

---------------------
--- gitsigns
---------------------
omap("n", "<leader>gtb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Gitsigns Toggle current line blame" })

---------------------
--- gitsigns
---------------------

remote_patterns = {
  { "^git@(.+)-(.+):(.+)%.git$", "https://%1/%3" }, -- git@github.com-some:some/some.git
  { "^(https?://.*)%.git$", "%1" },
  { "^git@(.+):(.+)%.git$", "https://%1/%2" },
  { "^git@(.+):(.+)$", "https://%1/%2" },
  { "^git@(.+)/(.+)$", "https://%1/%2" },
  { "^org%-%d+@(.+):(.+)%.git$", "https://%1/%2" },
  { "^ssh://git@(.*)$", "https://%1" },
  { "^ssh://([^:/]+)(:%d+)/(.*)$", "https://%1/%3" },
  { "^ssh://([^/]+)/(.*)$", "https://%1/%2" },
  { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
  { "^https://%w*@(.*)", "https://%1" },
  { "^git@(.*)", "https://%1" },
  { ":%d+", "" },
  { "%.git$", "" },
}
url_patterns = {
  ["github%.com"] = {
    branch = "/tree/{branch}",
    file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
    permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
    commit = "/commit/{commit}",
  },
}

-- master branch
omap({ "n", "x", "v" }, "<leader>gBm", function()
  -- Get the default branch name using git remote show origin
  local handle =
    io.popen("grep '^\\[branch' .git/config | sed -n 's/.*branch[[:space:]]*//p' | head -n 1 | sed 's/]//g'")
  local default_branch = handle:read("*a"):gsub("\n", "") -- Remove trailing newline
  handle:close()

  -- If the default branch is empty or not found, fallback to 'master'
  if default_branch == "" then
    default_branch = "master"
  end

  -- Ensure there are no quotes around the branch name
  default_branch = default_branch:gsub('"', "")

  local cfg = {
    branch = default_branch,
    remote_patterns = remote_patterns,
  }
  Snacks.gitbrowse(cfg)
end, { desc = "Git Browse default branch (open)" })

-- current branch
omap({ "n", "x", "v" }, "<leader>gBb", function()
  local cfg = {
    branch = nil,
    remote_patterns = remote_patterns,
  }
  Snacks.gitbrowse(cfg)
end, { desc = "Git Browse current branch (open)" })

-- TODO: just like lazygit reflog + O
--
-- -- current line commit hash branch
-- local function get_current_line_git_hash()
--   local line = vim.fn.line(".")
--   local file = vim.fn.expand("%")
--
--   -- Run the git blame command
--   local cmd = string.format("git blame -L %d,%d %s", line, line, file)
--   local handle = io.popen(cmd)
--   if not handle then
--     print("Failed to run git blame")
--     return
--   end
--
--   local result = handle:read("*a")
--   handle:close()
--   print("OI:", result)
--
--   local hash = result:match("^(%S+)")
--   if hash then
--     print("Commit hash:", hash)
--     vim.fn.setreg("+", hash) -- copy to clipboard
--     return hash
--   else
--     print("Could not find commit hash")
--     return nil
--   end
-- end
-- omap("n", "<leader>gBl", function()
--   local commit_hash = get_current_line_git_hash()
--
--   local cfg = {
--     what = "commit",
--     commit = commit_hash,
--     remote_patterns = remote_patterns,
--     url_patterns = url_patterns,
--   }
--   Snacks.gitbrowse(cfg)
-- end, { desc = "Get Git hash for current line" })

---------------------
--- luasnip
---------------------
local ls = require("luasnip")
map({ "i" }, "<M-e>", function()
  ls.expand()
end, { desc = "expand snippet", noremap = true })

---------------------
--- colorscheme
---------------------

-- map("n", "<leader>rcs", function()
--   local scheme = vim.fn.input("Colorscheme: ")
--   require("config.remember-colorscheme").set(scheme)
-- end, { desc = "Remember Colorscheme", noremap = true })

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local remember = require("config.remember-colorscheme")

vim.keymap.set("n", "<leader>uC", function()
  builtin.colorscheme({
    enable_preview = true,
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        if entry then
          remember.set(entry.value) -- Save the choice
        end
        actions.close(prompt_bufnr)
      end)

      return true
    end,
  })
end, { desc = "Colorscheme with remember" })

---------------------
--- neotree
---------------------

vim.keymap.set("n", "<leader>ng", function()
  require("neo-tree.command").execute({ source = "git_status", toggle = true })
end, { desc = "NeoTree (git)" })
