--========================================================--
--=                                                      =--
--====================--NVIM-CONFIGS--====================-- 
--package.path = package.path .. ";~/dotfiles/nvim/lua/?.lua"
--package.cpath = package.cpath .. ";~/dotfiles/nvim/lua/?.so"

require('settings')
require('plugins')
require('autocmds')
require('lsp')
require('keymaps')
