local nmap = require("rc.keymap").nmap

local function on_attach(bufnr)
	local gs = package.loaded.gitsigns

	nmap {
		"]c",
		function()
			vim.schedule(function() gs.next_hunk() end)
			return '<Ignore>'
		end,
		{ buffer = bufnr }
	}

	nmap {
		"[c",
		function()
			vim.schedule(function() gs.prev_hunk() end)
			return '<Ignore>'
		end,
		{ buffer = bufnr }
	}
end

return {
	"tpope/vim-fugitive",
	"shumphrey/fugitive-gitlab.vim",
	"tpope/vim-rhubarb",
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup {
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				signcolumn = true,
				on_attach = on_attach,
			}
		end
	},
}
