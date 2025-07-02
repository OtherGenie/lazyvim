local M = {}

local colorscheme_file = vim.fn.stdpath("cache") .. "/colorscheme.txt"

function M.set(scheme)
  -- trick
  vim.schedule(function()
    vim.cmd.colorscheme(scheme)
  end)

  local f = io.open(colorscheme_file, "w")
  if f then
    f:write(scheme)
    f:close()
  end
end

function M.load()
  local f = io.open(colorscheme_file, "r")
  if f then
    local scheme = f:read("*l")
    f:close()
    if scheme and scheme ~= "" then
      vim.cmd.colorscheme(scheme)
    end
  else
    vim.cmd("colorscheme gruvbox") -- default fallback
  end
end

return M
