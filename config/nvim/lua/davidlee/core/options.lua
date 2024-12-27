-- options.lua
-- Neovim Setup

-- Variaveis
local opt = vim.opt
local o = vim.o

-- Geral
opt.backup = false -- não faz backup dos arquivos
opt.writebackup = false -- não faz backup enquanto o arquivo está sendo editado
opt.swapfile = false -- não cria swap para novos buffers
opt.updatecount = 0 -- não salva os arquivos swap
opt.textwidth = 120 -- depois do numero de caracteres quebra a linha
opt.clipboard = "unnamedplus" -- permite neovim acessar o clipboard do sistema
opt.inccommand = "nosplit" -- TODO show the results of substitute as they're happening / But don't open a split
opt.mouse = "a" -- habilita suporte ao mouse em todos os modos
o.splitbelow = true -- novo windows abaixo
o.splitright = true -- novo windows a direita
opt.errorbells = false
opt.visualbell = true
opt.timeoutlen = 500

-- Searching
opt.ignorecase = true -- ignora case em procuras padrão
opt.smartcase = true -- case insensitive para expressões com a letra inicial alta
opt.hlsearch = true -- highlight os resultados da procura
opt.incsearch = true -- procura incremental igual navegadores modernos CTRL-G / CTRL-T
opt.lazyredraw = false -- não faz o redraw da tela enquanto executa macros

-- Aparencia
o.termguicolors = true -- habilita 24-bit RGB color
opt.number = true -- mostra numero da linha
opt.relativenumber = true -- mostra numero da linha relativo
opt.wrap = true -- habilita quebra de linha
opt.wrapmargin = 8 -- faz a quebra da linha apos passar N caracteres do limite
opt.linebreak = true -- habilita soft wrapping
opt.showbreak = "↪" -- icon para quebra de linha
opt.autoindent = true -- indenta nova linha automaticamente
opt.ttyfast = true -- redraw rápido
opt.laststatus = 3 -- mostra linha de status todo tempo
opt.scrolloff = 7 -- configura 7 linhas quando faz o scroll vertical
opt.wildmenu = true -- enhanced command line completion
opt.hidden = true -- current buffer can be put into background
opt.showcmd = true -- show incomplete commands
opt.cmdheight = 0 -- esconde command bar
opt.title = true -- configura titulo do terminal
opt.showmatch = true -- mostra fechamento dos )}]
opt.updatetime = 300 -- completion fast
opt.signcolumn = "yes"
opt.shortmess = "atToOFc" -- prompt message options

-- Tab
opt.smarttab = true -- tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
opt.tabstop = 2 -- número de espaços do tab
opt.softtabstop = 2 -- numero de espaco do tab enquanto esta editando
opt.shiftwidth = 2 -- numero de espaco para auto indentacao
opt.shiftround = true -- numero de espaco para indentacao manual

-- Mostrar Caracteres invesiveis
-- opt.list = false
-- opt.listchars = {
-- 	tab = "→ ",
-- 	eol = "¬",
-- 	trail = "⋅",
-- 	extends = "❯",
-- 	precedes = "❮",
-- }

-- Esconder o caractere ~ para linhas vazias no final do buffer
opt.fcs = "eob: "
