--========================================================--
--=                                                      =--
--=====================--COC-CONFIG--=====================-- 

vim.g.coc_global_extensions = {
    'coc-json',
    'coc-tsserver',
    'coc-python',
    'coc-clangd',
    'coc-html',
    'coc-css',
    'coc-eslint'
}

--Change SugestionSelect Color
vim.cmd [[highlight PmenuSel guibg=#202020 guifg=#ffffff]]

--Confirm Sugenstion with TAB 
local opts = {silent = true, noremap = true, expr =true, replace_keycodes = false}
vim.keymap.set( "i", "<TAB>", [[coc#pum#visible() ? coc#pum#confirm() : "\<TAB>"]], opts )
