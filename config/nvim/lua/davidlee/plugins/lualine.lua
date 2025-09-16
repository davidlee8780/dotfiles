return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local colors = {
			color0 = "#092236",
			color1 = "#ff5874",
			color2 = "#c3ccdc",
			color3 = "#1c1e26",
			color6 = "#a1aab8",
			color7 = "#828697",
			color8 = "#ae81ff",
		}
		local my_lualine_theme = {
			replace = {
				a = { fg = colors.color0, bg = colors.color1, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
			inactive = {
				a = { fg = colors.color6, bg = colors.color3, gui = "bold" },
				b = { fg = colors.color6, bg = colors.color3 },
				c = { fg = colors.color6, bg = colors.color3 },
			},
			normal = {
				a = { fg = colors.color0, bg = colors.color7, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
				c = { fg = colors.color2, bg = colors.color3 },
			},
			visual = {
				a = { fg = colors.color0, bg = colors.color8, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
			insert = {
				a = { fg = colors.color0, bg = colors.color2, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
		}

		local mode = {
			"mode",
			fmt = function(str)
				-- return ' '
				-- displays only the first character of the mode
				return " " .. str
			end,
		}

		local diff = {
			"diff",
			colored = true,
			symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
			-- cond = hide_in_width,
		}

		local filename = {
			"filename",
			file_status = true,
			path = 0,
		}

		-- xcodebuild
		local function xcodebuild_device()
			if vim.g.xcodebuild_platform == "macOS" then
				return " macOS"
			end

			local deviceIcon = ""
			if vim.g.xcodebuild_platform:match("watch") then
				deviceIcon = "􀟤"
			elseif vim.g.xcodebuild_platform:match("tv") then
				deviceIcon = "􀡴 "
			elseif vim.g.xcodebuild_platform:match("vision") then
				deviceIcon = "􁎖 "
			end

			if vim.g.xcodebuild_os then
				return deviceIcon .. " " .. vim.g.xcodebuild_device_name .. " (" .. vim.g.xcodebuild_os .. ")"
			end

			return deviceIcon .. " " .. vim.g.xcodebuild_device_name
		end

		local branch = { "branch", icon = { "", color = { fg = "#A6D4DE" } }, "|" }

		lualine.setup({
			icons_enabled = true,
			options = {
				-- theme = my_lualine_theme,
				theme = "eldritch",
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "|", right = "" },
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { branch },
				lualine_c = { diff, filename },
				lualine_x = {
					-- xcodebuild
					{ "' ' .. vim.g.xcodebuild_last_status", color = { fg = "Gray" } },
					{ "'󰙨 ' .. vim.g.xcodebuild_test_plan", color = { fg = "#a6e3a1", bg = "#161622" } },
					{ xcodebuild_device, color = { fg = "#f9e2af", bg = "#161622" } },
					{
						-- require("noice").api.statusline.mode.get,
						-- cond = require("noice").api.statusline.mode.has,
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					-- { "encoding",},
					-- { "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
