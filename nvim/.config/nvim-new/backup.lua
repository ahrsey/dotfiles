{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp" }
		config = function() 
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			local lspconfig = require('lspconfig')

			local servers = { 'tsserver' }

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client.server_capabilities.completionProvider then
						vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
					end
					if client.server_capabilities.definitionProvider then
						vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
					end
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


			end,
		})

		for _, lsp in ipairs(servers) do
			lspconfig[lsp].setup {
				-- on_attach = my_custom_on_attach,
				capabilities = capabilities,
			}
		end
	end
}
