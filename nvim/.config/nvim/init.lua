-- TODO
-- Issue with treesitter hightlighting on `class.chaining`
-- get the [f and [f for files
-- plug in vimwiki
-- I need an easier way to search files from within vim
-- I need to setup lsp for vim api's
-- Issue with auto indenting, I'd like to use the default
-- Investigate the treesitter completions, current the enter one isn't great
-- There is an issue with `gqq` auto indenting
-- It would be cool to be able to set my window with transparency and a background 
-- image instead of using the desktop
require("rc.settings")
require("rc.grep")
-- require("rc.files")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local options = {
	change_detection = {
		enabled = false,
		notify = false,
	},
	install = {
		missing = true
	}
}
require("lazy").setup("plugins", options)
