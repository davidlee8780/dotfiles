return {
  -- {
  --   "bluz71/vim-nightfly-guicolors",
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- load the colorscheme here
  --     vim.cmd([[colorscheme nightfly]])
  --   end,
  -- },
  -- {
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     local onedark = require('onedark')
  --
  --     onedark.setup {
  --       style = 'darker'
  --     }
  --
  --     vim.cmd([[colorscheme onedark]])
  --   end,
  -- },
  -- {
  --   "catppuccin/nvim",
  --   priority = 1000,
  --   -- name = 'catppuccin'
  --   config = function()
  --   --   local cat = require('catppuccin')
  --   --   cat.setup {
  --   --     flavour = 'catppuccin-mocha'
  --   --   }
  --     vim.cmd([[colorscheme catppuccin]])
  --   end,
  -- },
  {
    'rose-pine/neovim',
    config = function()
      vim.cmd([[colorscheme rose-pine]])
    end,
  }
}
