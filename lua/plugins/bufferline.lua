return {
  "akinsho/bufferline.nvim",
  optional = true,
  config = function()
    require("bufferline").setup({
      options = {
        indicator = {
          style = "underline",
        },
        diagnostics = "nvim_lsp",
        numbers = "ordinal",
      },
    })
  end,
}
