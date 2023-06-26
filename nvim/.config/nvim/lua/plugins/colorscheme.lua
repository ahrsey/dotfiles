local global = vim.g

global.dracula_colorterm = 0

return {
	{
		"dracula/vim",
		config = function()
			vim.cmd [[colorscheme dracula]]
		end
	},
}
