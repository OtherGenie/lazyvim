return {
  "akinsho/bufferline.nvim",
  optional = true,
  config = function()
    require("bufferline").setup({
      options = {
        diagnostics = "nvim_lsp",
        numbers = "ordinal",
      },
    })
  end,
}
