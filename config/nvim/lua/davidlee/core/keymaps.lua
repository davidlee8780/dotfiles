-- Keymaps

-- Variaveis
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local g = vim.g

-- Remap SPACE para tecla líder
keymap("n", "<Space>", "", opts)
g.mapleader = " "
g.maplocalleader = " "

-- Melhorar a indentação
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Sair do Buffer atual sem fechar a janela sem salvar
keymap("v", "Q", "<cmd>bdelete!<cr>", opts)

-- Cancelar highlight
keymap("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", opts)

-- Highlight quando copiar - yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			timeout = 40,
		})
	end,
	group = highlight_group,
	pattern = "*",
})

-- Flutter Telescope
-- keymap("n", "<Leader>q", "<Cmd>Telescope flutter commands<cr>", opts)
keymap("n", "<leader>cc", "<Cmd>Telescope flutter commands<CR>", opts)
keymap("n", "<leader>dd", "<Cmd>FlutterDevices<CR>", opts)
keymap(
	"n",
	"<leader>db",
	"<cmd>TermExec cmd='flutter pub run build_runner build --delete-conflicting-outputs'<CR>",
	opts
)
keymap("n", "<leader>de", "<Cmd>FlutterEmulators<CR>", opts)
keymap("n", "<leader>ti", "<Cmd>FlutterOutline<CR>", opts)
keymap("n", "<leader>dq", "<Cmd>FlutterQuit<CR>", opts)
keymap("n", "<leader>drn", "<Cmd>FlutterRun<CR>", opts)
keymap("n", "<leader>drs", "<Cmd>FlutterRestart<CR>", opts)

-- LSP Lines Keymap
-- keymap("n", "<Leader>l", "<cmd>lua require('lsp_lines').toggle()<cr>", opts)

-- LSP Saga keymap
-- keymap("n", "<C-j>", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
-- keymap("n", "ca", "<Cmd>Lspsaga code_action<CR>", opts)
-- keymap("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
-- keymap("n", "gd", "<Cmd>Lspsaga lsp_finder<CR>", opts)
-- keymap("i", "<C-k>", "<Cmd>Lspsaga signature_help<CR>", opts)
-- keymap("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", opts)
-- keymap("n", "gr", "<Cmd>Lspsaga rename<CR>", opts)
