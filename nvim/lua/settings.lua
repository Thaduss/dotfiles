--====================================================--
--=                                                  =--
--==================--SETTINGS-MAIN--=================--


vim.opt.number = true               --Enable line numbers
vim.opt.numberwidth = 2             --Set number tab width
vim.opt.cursorline = true           --Highlight the current line
vim.cmd('syntax on')                --Enable syntax highlight
--vim.opt,mouse= 'a'                --Enable mouse support 
vim.opt.incsearch = true            --Enable incremental search 
vim.opt.hlsearch = true             --Highlight search results 
vim.opt.ignorecase = true           --Case insensitive searching unless /C or capital letter 
vim.opt.smartcase = true            --^
vim.opt.tabstop = 4                 --Set tab width 
vim.opt.shiftwidth = 4              --^
vim.opt.expandtab = true            --^
vim.opt.autoindent = true           --Enable auto-indentation
vim.opt.smartindent =  true         --Enable smart-indentation 
vim.opt.cmdheight = 2               --Set command line height
vim.opt.undofile = true             --Enable persistent undo 
vim.opt.updatetime = 300            --Set updatetime for faster completion 
vim.opt.showmatch = true            --Show maching parantheses
--colorscheme desert                --Set colorscheme 
vim.opt.termguicolors = true        --Enable 24-bit RGB color
vim.opt.scrolloff = 8               --Display line below cursor when scrolling 
vim.opt.sidescrolloff = 8           --^
vim.opt.wrap = true                 --Enable line wrapping 
vim.opt.laststatus = 2              --set status line 
vim.opt.signcolumn = "yes"          --Needed for CoC
--vim.g.loaded_perl_provider = 0      --Disable Perl not found Warning message
--vim.g.loaded_ruby_provider = 0      --Disable Ruby not found Warning message 
