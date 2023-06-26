if true then
	return
end

local nmap = require("rc.keymap").nmap

local function P(tbl)
	print(vim.inspect(tbl))
end

local path = vim.fn.expand('%:p:h')
local cache = {}

local function get_file_name(str)
	return str:match("^.+/(.+)$")
end

local function index_of(tbl, value)
	P(tbl)
	print(value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
end

local function create_dir_file_cache()
	local dir = vim.loop.fs_scandir(path)

	local files = {}
	if dir and cache[path] == nil then
		while true do
			local file_name, _ = vim.loop.fs_scandir_next(dir)
			if file_name == nil then break end

			table.insert(files, file_name)

		end

		cache[path] = files
	end
end

-- TODO
-- nmap {
-- 	"[f",
-- 	function()
-- 		create_dir_file_cache()
-- 		local current_path = vim.fn.expand('%')
-- 		local current_file = get_file_name(current_path)
-- 		local index = index_of(cache[path], current_file)
-- 		local files = cache[path]
-- 		local new_file = files[index + 1]
-- 		local new_path = string.gsub(current_path, current_file, "") .. new_file
--
-- 		vim.api.nvim_exec("edit " .. new_path, false)
--
-- 		P(cache)
-- 	end
-- }
