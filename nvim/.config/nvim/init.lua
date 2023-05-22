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

local function lsp_config()
  require("mason").setup()

  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    spectral = {},
    zls = {},
    yamlls = {},
    cucumber_language_server = {},
    bashls = {},
    gopls = {},
    jsonls = {},
    terraformls = {},
    tsserver = {},

    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  local on_attach = function(_, bufnr)
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then
        desc = "LSP: " .. desc
      end

      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gr", function()
      require("telescope.builtin").lsp_references(require("telescope.themes").get_ivy({
        hidden = true,
        file_ignore_patterns = {"node_modules", ".git/"},
        prompt_prefix = "",
        results_title = "",
        sorting_strategy = "ascending",
        show_line = false
      }
      ))
    end, "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
      vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
  end
  local mason_lspconfig = require "mason-lspconfig"

  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  mason_lspconfig.setup_handlers {
    function(server_name)
      require("lspconfig")[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      }
    end,
  }
end

local function cmp_config()
  local cmp = require "cmp"
  local luasnip = require "luasnip"

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
    },
  }
end

local function treesitter_config()
  require("nvim-treesitter.configs").setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { "c", "cpp", "go", "lua", "python", "rust", "typescript", "vim", "vimdoc" },

    highlight = { enable = true },
    indent = { enable = true, disable = { "python" } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = "<c-s>",
        node_decremental = "<c-backspace>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
  }
end

local function telescope_setup()
  require("telescope").setup {
    defaults = {
      mappings = {
        i = {
          ["<C-u>"] = false,
          ["<C-d>"] = false,
        },
      },
    },
  }

  pcall(require("telescope").load_extension, "fzf")
end

local plugins = {
  {
    -- Lsp
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      config = function()
        require("mason-tool-installer").setup({})
      end,
    },
    {
      "neovim/nvim-lspconfig",
      config = lsp_config
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
    -- Completion
    {"hrsh7th/nvim-cmp",
      config = cmp_config
    },
    "hrsh7th/cmp-nvim-lsp",
    { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      config = treesitter_config
    },
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- Git
    {
      "tpope/vim-fugitive",
    },
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
        }
      end
    },
    "shumphrey/fugitive-gitlab.vim",
    {
      "dracula/vim",
      config = function()
        vim.cmd [[colorscheme dracula]]
      end
    },
    {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("lualine").setup {
          options = {
            icons_enabled = false,
            theme = "dracula",
            component_separators = "|",
            section_separators = "",
          },
        }
      end
    },
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end
    },
    "nvim-lua/plenary.nvim",
    "tpope/vim-sleuth",
    -- Telescope
    {
      "nvim-telescope/telescope.nvim",
      config = telescope_setup
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    {
      "mbbill/undotree",
      config = function ()
      end
    },
    {
      "vimwiki/vimwiki",
      config =  function()
        vim.g["vimwiki_list"] = {
          { path = "~/vimwiki/", path_html = "~/vimwiki_html/" },
          { path = "~/wikis/aws/" },
          { path = "~/wikis/blog/", syntax = "markdown", ext = ".md" },
        }
        vim.g["vimwiki_global_ext"] = 0
      end
    }
  }
}

-- Plugin setup
require("lazy").setup(plugins)

-- Settings
-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable relative line numbers
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Minimal lines to keep above or below cursor when searching
vim.o.scrolloff = 8

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Setup visual columns and cusors
vim.wo.colorcolumn = "80"
vim.wo.cursorline = true
vim.wo.cursorcolumn = true

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2

-- Set colorscheme
vim.o.termguicolors = true
-- vim.cmd [[colorscheme dracula]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.o.swapfile = false

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Save undo history
vim.o.undofile = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Terraform / HCL autocmd"s to switch terraform files to hcl
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf set filetype=terraform]])

-- https://neovim.discourse.group/t/stop-terminal-buffer-from-auto-closing-window/3849
vim.api.nvim_create_autocmd('TermClose',{callback=function()
  local buf=vim.api.nvim_get_current_buf()
  local newbuf=vim.api.nvim_create_buf(false,true)
  local windows=vim.fn.getwininfo()
  for _,i in ipairs(windows) do
    if i.bufnr==buf then
      vim.api.nvim_win_set_buf(i.winid,newbuf)
    end
  end
  vim.api.nvim_buf_delete(buf,{})
end})

-- Had to move this out here because wasn't getting picked up otherwise
local telescope_settings = {
  hidden = true,
  -- file_ignore_patterns = {"node_modules", ".git/", "coverage", "dist"},
  file_ignore_patterns = {"node_modules", ".git/"},
  prompt_prefix = "",
  results_title = "",
  no_ignore = false,
  vimgrep_arguments = {
    "rg",
    "--hidden",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case"
  }
}

vim.keymap.set("n", "<leader>?", function()
  require("telescope.builtin").oldfiles(require("telescope.themes").get_ivy(telescope_settings))
end, { desc = "[?] Find recently opened files" })

vim.keymap.set("n", "<leader><space>", function()
  require("telescope.builtin").buffers(require("telescope.themes").get_ivy(telescope_settings))
end, { desc = "[ ] Find existing buffers" })

vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_ivy {
    previewer = false,
  })
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>sf", function()
  require("telescope.builtin").find_files(require("telescope.themes").get_ivy(telescope_settings))
end, { desc = "[S]earch [F]iles" })

vim.keymap.set("n", "<leader>sh", function()
  require("telescope.builtin").help_tags(require("telescope.themes").get_ivy(telescope_settings))
end, { desc = "[S]earch [H]elp" })

vim.keymap.set("n", "<leader>sw", function()
  require("telescope.builtin").grep_string(require("telescope.themes").get_ivy(telescope_settings))
end, { desc = "[S]earch current [W]ord" })

vim.keymap.set("n", "<leader>sg", function()
  require("telescope.builtin").live_grep(require("telescope.themes").get_ivy(telescope_settings))
end, { desc = "[S]earch by [G]rep" })

vim.keymap.set("n", "<leader>sd", function()
  require("telescope.builtin").diagnostics(require("telescope.themes").get_ivy(telescope_settings))
end, { desc = "[S]earch [D]iagnostics" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Git keymaps
vim.keymap.set("n", "<leader>gb", "<cmd>GBrowse<cr>")
vim.keymap.set("v", "<leader>gb", "<cmd>GBrowse<cr>")
vim.keymap.set("n", "<leader>gg", "<cmd>Git blame<cr>")

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle [U]ndotree view for file history" })
