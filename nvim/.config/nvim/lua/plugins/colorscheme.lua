local global = vim.g

global.dracula_colorterm = 0

-- vim.cmd [[colorscheme evening]]

return {
  {
    "dracula/vim",
    -- "kdheepak/monochrome.nvim",
    config = function()
      vim.cmd [[colorscheme dracula]]
      -- vim.cmd [[colorscheme monochrome]]
    end
  },
}
