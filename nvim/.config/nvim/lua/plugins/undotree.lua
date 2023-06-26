local nmap = require("rc.keymap").nmap
local options = vim.opt

if vim.fn.has("persistent_undo") == 1 then
	local target_path = vim.fn.expand('~/.undodir')

	if vim.fn.isdirectory(target_path) == 0 then
		vim.fn.mkdir(target_path, "p", 0700)
	end

	options.undofile = true
	options.undodir = target_path

	nmap {
		"<leader>u",
		vim.cmd.UndotreeToggle
	}
end


return {
	{
		"mbbill/undotree",
	},
}
