local nmap = require("rc.keymap").nmap

-- cmp keymaps
local function lspconfig_handler()
  require("mason").setup()

  local servers = {
    clangd = {},
    tsserver = {},
    pylsp = {},
    bashls = {},

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
    nmap {
      "<leader>rn",
      vim.lsp.buf.rename,
      { buffer = bufnr }
    }

    nmap {
      "<leader>ca",
      vim.lsp.buf.code_action,
      { buffer = bufnr }
    }

    nmap {
      "gd",
      vim.lsp.buf.definition,
      { buffer = bufnr }
    }

    nmap {
      "gr",
      vim.lsp.buf.references,
      { buffer = bufnr }
    }

    nmap {
      "gI",
      vim.lsp.buf.implementation,
      { buffer = bufnr }
    }

    nmap {
      "<leader>D",
      vim.lsp.buf.type_definition,
      { buffer = bufnr }
    }

    nmap {
      "K",
      vim.lsp.buf.hover,
      { buffer = bufnr }
    }

    nmap {
      "<C-k>",
      vim.lsp.buf.signature_help,
      { buffer = bufnr }
    }
  end

  local mason_lspconfig = require("mason-lspconfig")

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

local function cmp_handler()
  local cmp = require "cmp"
  local luasnip = require "luasnip"
  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
    },
    mapping = cmp.mapping.preset.insert {
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
    }
  }
end

nmap {
  "[d",
  vim.diagnostic.goto_prev
}

nmap {
  "]d",
  vim.diagnostic.goto_next
}

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        auto_update = true,
        debounce_hours = 24
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = lspconfig_handler
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate"
  },
  "williamboman/mason-lspconfig.nvim",
  {"hrsh7th/nvim-cmp",
    config = cmp_handler
  },
  "hrsh7th/cmp-nvim-lsp",
  { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
  -- { "folke/neodev.nvim",
  --   config = function()
  --     require("neodev").setup({})
  --   end
  -- }
}
