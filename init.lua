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
