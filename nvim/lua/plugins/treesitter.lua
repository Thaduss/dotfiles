--=========================================================--
--=                                                       =--
--==================--TREESITTER-CONFIG--==================-- 

require'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
	highlight = {enable = true}
}

