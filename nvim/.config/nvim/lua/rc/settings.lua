local nmap = require("rc.keymap").nmap

local options = vim.opt
local global = vim.g
local window = vim.wo

global.mapleader = " "

options.tabstop = 2
options.softtabstop = 2
options.shiftwidth = 2
options.expandtab = true

options.swapfile = false

options.hlsearch = true
options.smartcase = true
options.ignorecase = true

window.relativenumber = true
window.number = true

options.mouse = ""
options.breakindent = true

options.scrolloff = 8

options.updatetime = 250
window.signcolumn = "yes"

-- window.colorcolumn = "80"
window.cursorline = true
window.cursorcolumn = true

options.completeopt = "menuone,noselect"

-- disable unused plugins
global.loaded_getscript = 1
global.loaded_getscriptPlugin = 1
global.loaded_vimball = 1
global.loaded_vimballPlugin = 1
global.loaded_2html_plugin = 1
global.loaded_matchit = 1
global.loaded_matchparen = 1
global.loaded_logiPat = 1

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- highlight yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Additional shortcuts
nmap {
	"[t",
	function()
		vim.cmd 'tabprev'
	end
}

nmap {
	"]t",
	function()
		vim.cmd 'tabnext'
	end
}

nmap {
	"[b",
	function()
		vim.cmd 'bp'
	end
}

nmap {
	"]b",
	function()
		vim.cmd 'bn'
	end
}
