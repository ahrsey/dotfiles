local exists = vim.fn.system({ "which", "typescript-language-server" })

if exists == '' then
  vim.fn.system({ "brew", "install", "typescript-language-server" })
end
