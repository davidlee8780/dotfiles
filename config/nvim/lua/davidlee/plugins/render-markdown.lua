
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "markdown.mdx" }, -- carrega só quando necessário
  enabled = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },

  -- garante TS highlight em markdown (resolve "highlighter: not enabled")
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "markdown.mdx" },
      callback = function(args)
        pcall(vim.treesitter.start, args.buf, "markdown")
      end,
    })
  end,

  opts = {
    -- use defaults para não depender de highlight groups custom
    heading = {
      sign = false,
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
      -- backgrounds/foregrounds removidos -> usa padrão do plugin
    },

    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },

    bullet = {
      enabled = true,
    },

    checkbox = {
      enabled = true,
      -- ⚠️ 'position' removido: era a causa do erro do healthcheck
      unchecked = {
        icon = "   󰄱 ",
        highlight = "RenderMarkdownUnchecked",
        scope_highlight = nil,
      },
      checked = {
        icon = "   󰱒 ",
        highlight = "RenderMarkdownChecked",
        scope_highlight = nil,
      },
    },

    -- Desliga LaTeX para evitar depender de gs/tectonic/pdflatex
    latex = { enabled = false },
  },
}
