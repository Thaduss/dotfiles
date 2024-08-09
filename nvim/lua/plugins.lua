--=======================================================--
--=                                                     =--
--======================--PLUGINS--======================-- 


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { 
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
        { 'neoclide/coc.nvim', branch = 'release'},
        { 'nvim-tree/nvim-tree.lua', version = "*", dependencies = { 'nvim-tree/nvim-web-devicons' } },
        { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
        { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },
        { 'goolord/alpha-nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
        { 'windwp/nvim-autopairs', event = "InsertEnter", config = true},
        { 'nvim-lua/plenary.nvim' },
        { 'Shatur/neovim-session-manager' },
        { 'lervag/vimtex' },
        { 'Mofiqul/vscode.nvim' },
    },
    defaults = { lazy = false, version = false },
    install = { colorscheme = { "vscode" } },
    checker = {
        enabled = true,
        notify = false,
    },
})


--load plugings config here--
require( 'plugins.treesitter' )
require( 'plugins.coc' )
require( 'plugins.nvim-tree' )
require( 'plugins.lualine' )
require( 'plugins.telescope' )
require( 'plugins.alpha-nvim' )
require( 'plugins.session-manager' )
require( 'plugins.vimtex' )
