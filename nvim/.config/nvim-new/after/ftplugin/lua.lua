local exists = vim.fn.system({ "which", "lua-language-server" })

if exists == '' then
  vim.fn.system({ "brew", "install", "lua-language-server" })
end
