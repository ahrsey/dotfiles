local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

--[[
-- Settings
--]]
vim.g.mapleader = " "

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.wo.relativenumber = true
vim.wo.number = true

vim.opt.breakindent = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 250
vim.wo.signcolumn = "yes"

vim.wo.cursorcolumn = true
vim.wo.cursorline = true

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1

vim.wo.wrap = true

vim.cmd [[colorscheme torte]]

--[[
-- Hightlight text on jank
--]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

--[[
-- Load plugins
--]]
local options = {
	change_detection = {
		enabled = false,
		notify = false,
	},
	install = {
		missing = true
	}
}

--[[
-- Grep
--]]
-- https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
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

vim.keymap.set("n",
	"<leader>sw",
	function()
		local current_word = vim.fn.expand("<cword>")
		vim.cmd("grep " .. current_word .. " .")
    vim.cmd("cwindow")
	end
)

local plugins = {
  --[[
  -- Completion and snippets
  --]]
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-path"
    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert {
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete {},
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },
      }
    end,
  },
  --[[
  -- Lsp
  --]]
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {},
      },
    },
    config = function()
      local lspconfig = require("lspconfig")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
          vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = event.buf })
          vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = event.buf })
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = event.buf })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf })
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, { buffer = event.buf })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf })
        end,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })

      lspconfig.tsserver.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace"
            },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
                globals = {'vim'},
            },
          }
        },
        capabilities = capabilities
      })

      --[[
      -- Display lsp diganositics on cursor
      --]]
      -- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      --   group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
      --   callback = function ()
      --     vim.diagnostic.open_float()
      --   end
      -- })

      --[[
      -- Disable inline diagnostics
      --]]
      -- vim.diagnostic.config({ virtual_text = false, })
    end
  },
  --[[
  -- Git
  --]]
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
        on_attach = function (bufnr)
          local gs = package.loaded.gitsigns

          vim.keymap.set("n", "]c", function()
            vim.schedule(gs.next_hunk)
            return "<Ignore>"
          end, { buffer = bufnr })

          vim.keymap.set("n", "[c", function()
            vim.schedule(gs.prev_hunk)
            return "<Ignore>"
          end, { buffer = bufnr })

        end
			}
		end,
	},
	"tpope/vim-fugitive",
	"shumphrey/fugitive-gitlab.vim",
	"tpope/vim-rhubarb",
  --[[
  -- Other plugins
  --]]
  {"numToStr/Comment.nvim", opt = {}},
	{
		"mbbill/undotree", config = function()
      if vim.fn.has("persistent_undo") == 1 then
        local target_path = vim.fn.expand('~/.undodir')

        if vim.fn.isdirectory(target_path) == 0 then
          vim.fn.mkdir(target_path, "p", 0700)
        end

        options.undofile = true
        options.undodir = target_path

        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
      end
    end
	},
	"vimwiki/vimwiki",
	config =  function()
    vim.g["vimwiki_list"] = {
      { path = "~/vimwiki/" },
      { path = "~/wikis/aws/" },
      { path = "~/Repos/blog/posts/", syntax = "markdown", ext = ".md" },
    }
	end
}

require("lazy").setup(plugins, options)

--[[
-- Keybinds
--]]
vim.keymap.set("n", "[b", function() vim.cmd 'bp' end)
vim.keymap.set("n", "]b", function() vim.cmd 'bn' end)
vim.keymap.set("n", "[t", function() vim.cmd 'tabprev' end)
vim.keymap.set("n", "]t", function() vim.cmd 'tabnext' end)

-- vim.keymap.set("n", "]f", function()
--   local file = function ()
--     local ls = vim.fn.system({"ls"})
--     print(ls)
--   end
--
--   vim.schedule(file)
-- end)
--
-- vim.keymap.set("n", "<leader>gb", vim.cmd.gitsigns.blame)
