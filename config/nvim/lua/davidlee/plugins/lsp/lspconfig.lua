return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- Função on_attach definida para configurações específicas de LSP
		local on_attach = function(client, _)
			-- Desabilitar formatação para alguns clientes se necessário
			if client.name == "ts_ls" then
				client.server_capabilities.documentFormattingProvider = false
			end
		end

		-- Configuração de keybinds automáticos quando LSP é anexado
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				-- Keymaps para navegação e funcionalidades LSP
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>ca", function()
					vim.lsp.buf.code_action()
				end, opts)

				opts.desc = "Smart rename"
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

				opts.desc = "Signature help"
				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)

				-- Navegação entre diagnósticos
				opts.desc = "Go to next diagnostic"
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Go to previous diagnostic"
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			end,
		})

		-- Configuração de ícones para diagnósticos
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		}

		-- Aplicar configuração de diagnósticos
		vim.diagnostic.config({
			signs = {
				text = signs, -- Enable signs in the gutter
			},
			virtual_text = true, -- Specify Enable virtual text for diagnostics
			underline = true, -- Specify Underline diagnostics
			update_in_insert = false, -- Keep diagnostics active in insert mode
		})

		-- Configuração base para todos os LSPs
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Melhorar capabilities para snippets
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = { "documentation", "detail", "additionalTextEdits" },
		}

		-- Configuração do Lua LSP
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim", "use" },
					},
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		-- Configuração do TypeScript/JavaScript LSP
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
			root_dir = function(fname)
				local util = lspconfig.util
				-- Não usar ts_ls se for um projeto Deno
				return not util.root_pattern("deno.json", "deno.jsonc")(fname)
					and util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
			end,
			single_file_support = false,
			init_options = {
				preferences = {
					includeCompletionsForModuleExports = true,
					includeCompletionsForImportStatements = true,
					includeCompletionsWithSnippetText = true,
				},
			},
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		})

		-- Configuração do Deno LSP
		lspconfig.denols.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
			init_options = {
				lint = true,
				unstable = true,
				suggest = {
					imports = {
						hosts = {
							["https://deno.land"] = true,
							["https://cdn.nest.land"] = true,
							["https://crux.land"] = true,
						},
					},
				},
			},
		})

		-- Configuração do Swift LSP (SourceKit)
		local sourcekit_cmd = function()
			local xcode_path =
				"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"
			local xcrun_result = vim.fn.system("xcrun --find sourcekit-lsp 2>/dev/null")

			if vim.v.shell_error == 0 then
				return { vim.trim(xcrun_result) }
			elseif vim.fn.executable(xcode_path) == 1 then
				return { xcode_path }
			else
				return { "sourcekit-lsp" } -- Fallback para PATH
			end
		end

		lspconfig.sourcekit.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = sourcekit_cmd(),
			filetypes = { "swift", "objective-c", "objective-cpp" },
		})

		-- Configuração do Go LSP
		lspconfig.gopls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
						shadow = true,
					},
					staticcheck = true,
					gofumpt = true,
					codelenses = {
						gc_details = false,
						generate = true,
						regenerate_cgo = true,
						run_govulncheck = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						vendor = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		})

		-- Configuração do Emmet LSP
		lspconfig.emmet_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
				"vue",
			},
		})

		-- Configuração alternativa do Emmet Language Server
		lspconfig.emmet_language_server.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"pug",
				"typescriptreact",
				"vue",
			},
			init_options = {
				includeLanguages = {},
				excludeLanguages = {},
				extensionsPath = {},
				preferences = {},
				showAbbreviationSuggestions = true,
				showExpandedAbbreviation = "always",
				showSuggestionsAsSnippets = false,
				syntaxProfiles = {},
				variables = {},
			},
		})

		-- Configurações adicionais para LSPs comuns (descomente conforme necessário)

		-- HTML LSP
		-- lspconfig.html.setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = on_attach,
		-- })

		-- CSS LSP
		-- lspconfig.cssls.setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = on_attach,
		-- })

		-- JSON LSP
		-- lspconfig.jsonls.setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = on_attach,
		-- 	settings = {
		-- 		json = {
		-- 			schemas = require('schemastore').json.schemas(),
		-- 			validate = { enable = true },
		-- 		},
		-- 	},
		-- })

		-- Python LSP (Pyright)
		-- lspconfig.pyright.setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = on_attach,
		-- 	settings = {
		-- 		python = {
		-- 			analysis = {
		-- 				typeCheckingMode = "basic",
		-- 				autoSearchPaths = true,
		-- 				useLibraryCodeForTypes = true,
		-- 			},
		-- 		},
		-- 	},
		-- })

		-- Rust LSP
		-- lspconfig.rust_analyzer.setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = on_attach,
		-- 	settings = {
		-- 		["rust-analyzer"] = {
		-- 			imports = {
		-- 				granularity = {
		-- 					group = "module",
		-- 				},
		-- 				prefix = "self",
		-- 			},
		-- 			cargo = {
		-- 				buildScripts = {
		-- 					enable = true,
		-- 				},
		-- 			},
		-- 			procMacro = {
		-- 				enable = true,
		-- 			},
		-- 		},
		-- 	},
		-- })
	end,
}
