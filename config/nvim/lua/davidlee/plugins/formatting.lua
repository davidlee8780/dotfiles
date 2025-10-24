return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			-- Regras/condições por formatter
			formatters = {
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
				-- Ajustes finos dos formatters
				black = {
					-- use o pyproject.toml se existir; se não, esses args
					prepend_args = { "--line-length", "88" },
				},
				isort = {
					-- compatível com o style do Black
					prepend_args = { "--profile", "black" },
				},
				prettier = {
					args = {
						"--stdin-filepath",
						"$FILENAME",
						"--tab-width",
						"4",
						"--use-tabs",
						"false",
					},
				},
				shfmt = {
					prepend_args = { "-i", "4" },
				},
			},

			-- Mapeamento por filetype
			formatters_by_ft = {
				-- Web / TS
				javascript = { "biome-check" },
				typescript = { "biome-check" },
				javascriptreact = { "biome-check" },
				typescriptreact = { "biome-check" },
				css = { "biome-check" },
				html = { "biome-check" },
				svelte = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },

				-- Lua
				lua = { "stylua" },

				-- Markdown
				markdown = { "prettier", "markdown-toc" },
				-- ["markdown.mdx"] = { "prettier", "markdownlint", "markdown-toc" },

				-- Swift
				swift = { "swiftformat" },

				-- 🐍 Python (pipeline recomendada: ruff_fix → isort → black)
				python = { "ruff_fix", "isort", "black" },
				-- Alternativa: usar só o formatador do Ruff
				-- python         = { "ruff_format" },

				-- Shell
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
			},

			-- Auto format on save (com exceções)
			format_on_save = function(bufnr)
				local ignore_filetypes = { "oil" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				return { timeout_ms = 500, lsp_fallback = true }
			end,

			log_level = vim.log.levels.ERROR,
		})

		-- Keymap manual de format
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file/range with Conform" })
	end,
}
