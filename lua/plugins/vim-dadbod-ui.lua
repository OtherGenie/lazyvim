return {
  "kristijanhusak/vim-dadbod-ui",
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  dependencies = "vim-dadbod",
  keys = function(_, keys)
    vim.keymap.set("n", "<leader>D", "<cmd>DBUIToggle<CR>", { silent = true, desc = "Toggle DBUI" })

    vim.keymap.set("n", "<S-CR>", function()
      vim.cmd("normal! vip") -- select inner paragraph
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(DBUI_ExecuteQuery)", true, false, true), "x", false)
    end, { silent = true, desc = "Run SQL on paragraph" })

    -- vim.keymap.set("n", "<CR>", "<Plug>(DBUI_ExecuteQuery)", { silent = true, desc = "Run SQL query" })
    -- vim.keymap.set("v", "<CR>", "<Plug>(DBUI_ExecuteQuery)", { silent = true, desc = "Run SQL query (visual)" })
  end,
  init = function()
    local data_path = vim.fn.stdpath("data")

    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
    vim.g.db_ui_use_nerd_fonts = true
    vim.g.db_ui_use_nvim_notify = true

    -- NOTE: The default behavior of auto-execution of queries on save is disabled
    -- this is useful when you have a big query that you don't want to run every time
    -- you save the file running those queries can crash neovim to run use the
    -- default keymap: <leader>S
    vim.g.db_ui_execute_on_save = false
  end,
}
