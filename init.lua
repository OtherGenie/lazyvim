-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

------------------------------
-- colorscheme
------------------------------
require("gruvbox").setup({
  contrast = "", -- can be "hard", "soft" or empty string
  transparent_mode = true,
  dim_inactive = false,
})
vim.cmd("colorscheme gruvbox")
