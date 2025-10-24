return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- on_attach
		local on_attach = function(client, _)
			if client.name == "ts_ls" then
				client.server_capabilities.documentFormattingProvider = false
			end
		end

		-- Keybinds quando LSP anexa
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

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

				opts.desc = "Show documentation (hover)"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

				opts.desc = "Signature help"
				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)

				opts.desc = "Next diagnostic"
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Prev diagnostic"
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			end,
		})

		-- Ícones/estilo de diagnósticos
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		}

		for severity, icon in pairs(signs) do
			local name = vim.diagnostic.severity[severity]:lower()
			vim.fn.sign_define("DiagnosticSign" .. name, {
				text = icon,
				texthl = "DiagnosticSign" .. name,
				numhl = "",
			})
		end

		vim.diagnostic.config({
			signs = { text = signs },
			virtual_text = true,
			underline = true,
			update_in_insert = false,
		})

		-- Capabilities (cmp)
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = { "documentation", "detail", "additionalTextEdits" },
		}

		-- Utilidades de root_pattern
		local util = require("lspconfig.util")

		-- Helper para configurar + habilitar servidores na nova API
		local function setup(server, opts)
			vim.lsp.config(server, opts or {})
			vim.lsp.enable(server)
		end

		---------------------------------------------------------------------------
		-- Servidores
		---------------------------------------------------------------------------

		-- Lua
		setup("lua_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim", "use" } },
					completion = { callSnippet = "Replace" },
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		})

		-- TypeScript / JavaScript (ts_ls)
		setup("ts_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			root_dir = function(fname)
				-- Se for projeto Deno, não usar ts_ls
				if util.root_pattern("deno.json", "deno.jsonc")(fname) then
					return nil
				end
				return util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
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

		-- Deno
		setup("denols", {
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = util.root_pattern("deno.json", "deno.jsonc"),
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

		-- Swift (SourceKit)
		local function sourcekit_cmd()
			local xcode_path =
				"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"
			local xcrun_result = vim.fn.system("xcrun --find sourcekit-lsp 2>/dev/null")
			if vim.v.shell_error == 0 then
				return { vim.trim(xcrun_result) }
			elseif vim.fn.executable(xcode_path) == 1 then
				return { xcode_path }
			else
				return { "sourcekit-lsp" }
			end
		end

		setup("sourcekit", {
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = sourcekit_cmd(),
			filetypes = { "swift", "objective-c", "objective-cpp" },
		})

		-- Go
		setup("gopls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				gopls = {
					analyses = { unusedparams = true, shadow = true },
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

		-- Emmet (node)
		setup("emmet_ls", {
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

		-- Emmet (alternativo)
		setup("emmet_language_server", {
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

		-- HTML
		setup("html", {
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- CSS
		setup("cssls", {
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- JSON (com schemastore se disponível)
		local has_schemastore, schemastore = pcall(require, "schemastore")
		setup("jsonls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				json = {
					schemas = has_schemastore and schemastore.json.schemas() or nil,
					validate = { enable = true },
				},
			},
		})

		-- Python (Pyright)
		setup("pyright", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic", -- "off" | "basic" | "strict"
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		-- Rust
		setup("rust_analyzer", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				["rust-analyzer"] = {
					imports = {
						granularity = { group = "module" },
						prefix = "self",
					},
					cargo = { buildScripts = { enable = true } },
					procMacro = { enable = true },
				},
			},
		})

		-- (Opcional) Você poderia habilitar vários de uma vez:
		-- vim.lsp.enable({ "lua_ls","ts_ls","denols","sourcekit","gopls","emmet_ls","emmet_language_server","html","cssls","jsonls","pyright","rust_analyzer" })
	end,
}
