return {
	"williamboman/mason.nvim",
	lazy = false,
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local ok_mason, mason = pcall(require, "mason")
		if not ok_mason then
			return
		end
		local ok_mlsp, mason_lspconfig = pcall(require, "mason-lspconfig")
		if not ok_mlsp then
			return
		end
		local ok_tools, mason_tool_installer = pcall(require, "mason-tool-installer")
		if not ok_tools then
			return
		end

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- LSP servers (nomes seguem os servers do nvim-lspconfig)
		mason_lspconfig.setup({
			automatic_installation = false,
			ensure_installed = {
				-- Core que você usa no lspconfig.lua
				"lua_ls",
				"ts_ls", -- você está usando ts_ls no lspconfig.lua
				"denols", -- também está configurado no lspconfig.lua
				"pyright",
				"jsonls",
				"html",
				"cssls",
				"gopls",
				"rust_analyzer",
				"emmet_ls",
				"emmet_language_server",

				-- Opcionais / extras
				"bashls", -- útil mesmo sem config manual, cobre .sh
				"yamlls", -- idem p/ YAML
				"marksman", -- LSP de Markdown (se quiser diagnósticos/outline)
				-- "tailwindcss",
				-- "angularls",
				-- "clangd",             -- só se for usar C/C++
			},
		})

		-- Ferramentas (formatters/linters/etc) para o Conform e afins
		mason_tool_installer.setup({
			ensure_installed = {
				-- Web
				"prettier",
				"biome", -- para o seu "biome-check" no Conform

				-- Lua
				"stylua",

				-- Python (pipeline: ruff_fix | isort | black)
				"black",
				"isort",
				"ruff",
				"pylint",

				-- Shell
				"shfmt",
				"shellcheck",

				-- Opcionais úteis
				-- "jq",
				-- "yamlfmt",
			},
		})
	end,
}
