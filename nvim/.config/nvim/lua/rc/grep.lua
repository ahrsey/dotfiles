-- TODO
-- highlight word that was grepped would be cool
-- look into running grep in a subshell
-- https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
local nmap = require("rc.keymap").nmap
local options = vim.opt

local ignore_folders = {
	"node_modules",
	".git",
}

local ripgrepprg = "rg --vimgrep --hidden --smart-case"

for _, value in pairs(ignore_folders) do
	ripgrepprg = ripgrepprg .. string.format(" --glob '!%s' ", value)
end

options.grepprg = ripgrepprg
options.grepformat = "%f:%l:%c:%m"

nmap {
	"<leader>sw",
	function()
		local current_word = vim.fn.expand("<cword>")
		vim.cmd("grep " .. current_word .. " .")
	end,
}

nmap {
	"[q",
	function()
		local success, _ = pcall(function()
			vim.cmd("cprev")
		end)
		if not success then
			print("No prev errors")
		end
	end,
}

nmap {
	"]q",
	function()
		local success, _ = pcall(function()
			vim.cmd("cnext")
		end)
		if not success then
			print("No next errors")
		end
	end,
}
