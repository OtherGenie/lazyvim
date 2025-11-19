-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.cmd("set ignorecase!")
vim.cmd("set noswapfile")
-- markdown code block was invisible until hovered
vim.cmd("set conceallevel=0")

------------------------------
-- colorscheme
------------------------------

require("gruvbox").setup({
  contrast = "", -- can be "hard", "soft" or empty string
  transparent_mode = true,
  dim_inactive = false,
})
vim.cmd("colorscheme gruvbox")
require("config.remember-colorscheme").load()

vim.cmd("highlight Pmenu guibg=NONE") -- transparent completion menu
vim.opt.termguicolors = true

-- :hightlight
vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Question" })
vim.cmd("highlight! LspReferenceRead guifg=#fabd2f guibg=#101112")
vim.cmd("highlight! LspReferenceText guifg=#fabd2f guibg=#101112")

-- gray
vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" })
-- blue
vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { bg = "NONE", fg = "#569CD6" })
-- vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })
-- -- light blue
-- vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#9CDCFE" })
-- vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
-- vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
-- -- pink
-- vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })
-- vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
-- -- front
-- vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = "#D4D4D4" })
-- vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })
-- vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })

------------------------------------------------------
-- Helpers
------------------------------------------------------

-- Get repo root (as full path)
local function git_root()
  local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")
  return vim.v.shell_error == 0 and vim.fn.trim(root) or nil
end

-- Get project name = last directory of git root
local function get_project_name()
  local root = git_root()
  if not root then
    return nil
  end
  return root:match("([^/]+)$")
end

-- Repo-relative path (no project prefix)
local function get_repo_relative()
  local file = vim.fn.expand("%:p")
  local rel = vim.fn.system("git ls-files --full-name " .. vim.fn.shellescape(file))
  return vim.fn.trim(rel)
end

-- Project-relative path (projectName/file)
local function get_project_relative()
  local project = get_project_name()
  if not project then
    return nil
  end
  local rel = get_repo_relative()
  return project .. "/" .. rel
end

------------------------------------------------------
-- Keymaps
------------------------------------------------------

-- Copy project-relative path
vim.keymap.set("n", "<leader>fp", function()
  local path = get_project_relative()
  if not path then
    return print("Not a git repo")
  end
  vim.fn.setreg("+", path)
  print("Copied: " .. path)
end, { desc = "Copy project-relative path" })

-- Copy project-relative path + line number
vim.keymap.set("n", "<leader>fP", function()
  local path = get_project_relative()
  if not path then
    return print("Not a git repo")
  end
  local result = path .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", result)
  print("Copied: " .. result)
end, { desc = "Copy project-relative path + line" })
