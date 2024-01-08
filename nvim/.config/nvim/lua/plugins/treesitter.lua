local function handler()
	require'nvim-treesitter.configs'.setup({
		ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "typescript" },
		highlight = {
			enabled = true
		},
    -- incremental_selection = {
    --   enable = false,
    --   keymaps = {
    --     init_selection = "<cr>",
    --     node_incremental = "<tab>",
    --     scope_incremental = "<cr>",
    --     node_decremental = "<s-tab>",
    --   },
    -- },
		-- indent = {
		-- 	enable = true
		-- },
    additional_vim_regex_highlighting = false,
		-- textobjects = {
			-- TODO
      -- select = {
      --   enable = false,
      --   lookahead = true,
      --   keymaps = {
      --     ["aa"] = "@parameter.outer",
      --     ["ia"] = "@parameter.inner",
      --     ["af"] = "@function.outer",
      --     ["if"] = "@function.inner",
      --     ["ac"] = "@class.outer",
      --     ["ic"] = "@class.inner",
      --   },
      -- },
			-- move = {
   --      enable = false,
   --      set_jumps = true,
   --      goto_next_start = {
   --        ["]m"] = "@function.outer",
   --        ["]]"] = "@class.outer",
   --      },
   --      goto_next_end = {
   --        ["]m"] = "@function.outer",
   --        ["]["] = "@class.outer",
   --      },
   --      goto_previous_start = {
   --        ["[m"] = "@function.outer",
   --        ["[["] = "@class.outer",
   --      },
   --      goto_previous_end = {
   --        ["[m"] = "@function.outer",
   --        ["[]"] = "@class.outer",
   --      },
   --    },
      -- swap = {
      --   enable = false,
      --   swap_next = {
      --     ["<leader>a"] = "@parameter.inner",
      --   },
      --   swap_previous = {
      --     ["<leader>a"] = "@parameter.inner",
      --   },
      -- },
		-- }
	})
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = handler
	},
}
