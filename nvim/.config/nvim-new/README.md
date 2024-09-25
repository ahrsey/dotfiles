# Nvim config

1. [x] Load plugins in a way that I can update from cmd
2. [ ] Setting up lsp and using ft plugin to manage different file types
2. [ ] Neodev

# 1. Updating plugins
- Run install, clean and update
- Might be interesting to make a command to group other updates lazy,
  treesitter and language server installation or updates
```
nvim --headless "+Lazy! sync" +qa
```

# 2. Lsp
- See if I can get ftplugin to manage loading each file types lsp requirements.
- Control installing language servers if they're not installed this way too
https://github.com/tjdevries/config.nvim/blob/master/after/ftplugin/c.lua
