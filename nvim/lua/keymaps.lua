--=======================================================--
--=                                                     =--
--======================--KEYMAPS--======================--
local opts = { noremap = true, silent = true }



--Nvim_tree--
vim.api.nvim_set_keymap('n', '<A-t>', ':NvimTreeToggle<CR>', opts)
vim.api.nvim_set_keymap('n', '<A-q>', ':NvimTreeFocus<CR>', opts)
vim.api.nvim_set_keymap('n', 'o', ':call append(line(\'.\'), \'\')<CR>j', opts)
vim.api.nvim_set_keymap('n', 'O', ':call append(line(\'.\') - 1, \'\')<CR>k', opts)

