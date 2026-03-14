local vim = vim
local Plug = vim.fn['plug#']

-- various nvim editor settings
vim.opt.spell = true
vim.opt.winborder = "rounded"
vim.opt.hlsearch = false
vim.opt.tabstop = 2
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.encoding = "utf-8"
vim.opt.fileformat = "unix"
vim.o.showmode = false
vim.opt.listchars = { tab = "| " }
vim.opt.list = true
vim.opt.shell = 'nu.exe'

vim.g.rustfmt_autosave = 1
vim.g.rustfmt_emit_files = 1
vim.g.rustfmt_fail_silently = 0

-- Plugins
vim.call('plug#begin')

Plug('MunifTanjim/nui.nvim')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-lualine/lualine.nvim')
Plug('nvim-lua/plenary.nvim')
Plug('https://github.com/nvim-neo-tree/neo-tree.nvim')
Plug('https://github.com/nvimtools/none-ls.nvim.git')
Plug('https://github.com/mfussenegger/nvim-lint')
Plug('https://github.com/MeanderingProgrammer/render-markdown.nvim.git')
Plug('https://github.com/typicode/bg.nvim.git')
Plug('https://github.com/m4xshen/autoclose.nvim.git')
Plug('daltonmenezes/aura-theme', { ['rtp'] = 'packages/neovim' })
Plug('datsfilipe/gruvbox.nvim')
Plug('rust-lang/rust.vim')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ":TSUpdate" })
Plug('https://github.com/chomosuke/typst-preview.nvim')
Plug('https://github.com/ravibrock/spellwarn.nvim')
Plug('rktjmp/playtime.nvim')
Plug('L3MON4D3/LuaSnip', { ['tag'] = 'v2.*', ['do'] = 'make install_jsregexp' })
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')
Plug('L3MON4D3/LuaSnip')
Plug('saadparwaiz1/cmp_luasnip')

vim.call('plug#end')

-- nvim-treesitter settings
local status_ok, parser_configs = pcall(require, 'nvim-treesitter.parsers')
if status_ok and parser_configs.get_parser_configs then
	parser_configs.get_parser_configs().niva = {
		install_info = {
			url = "~/tree-sitter-niva",
			files = { "src/parser.c" },
			generate_requires_npm = false,
			requires_generate_from_grammar = true
		},
		filetype = "niva",
	}
else
	vim.treesitter.language.register('niva', 'niva')
end
vim.cmd([[
augroup _niva
autocmd!
autocmd BufRead,BufEnter *.niva set filetype=niva
augroup end
]])

-- Autocomplete settings
local cmp = require 'cmp'
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' }, -- For luasnip users.
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Lua settings
vim.lsp.config["luals"] = {
	capabilities = capabilities,
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { '.luarc.json', '.luarc.jsonc' },
	settings = {
		luals = {}
	}
}

vim.lsp.enable('luals')

-- Rust settings
vim.lsp.config["rust_analyzer"] = {
	-- capabilities = capabilities,
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true
			}
		}
	},
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	single_file_support = true,
	root_markers = { ".git", "Cargo.toml" },
	settings = {
		["rust-analyzer"] = {
			check = { command = "clippy", extraArgs = { "--tests" } },
			cargo = { features = "all" },
			rustfmt = { extraArgs = { "+nightly" } },
			inlayHints = { chainingHints = { enable = false } },
		},
	},
}

vim.lsp.enable("rust_analyzer")

-- C settings
vim.lsp.enable("clangd")

-- Typst/TinyMist settings
vim.lsp.config["tinymist"] = {
	capabilities = capabilities,
	cmd = { "tinymist" },
	filetypes = { "typst" },
	settings = {}
}

vim.lsp.enable("tinymist")

vim.cmd([[
	augroup typst_entry_settings
		autocmd!
		autocmd FileType typst setlocal spell spelllang=en_us
	augroup END
]])

-- Markdown settings
vim.cmd([[
	augroup markdown_entry_settings
		autocmd!
		autocmd FileType markdown setlocal spell spelllang=en_us
	augroup END
]])

-- TCL9 settings
require('lint').linters_by_ft = {
	tcl = {'tclint'},
}

vim.api.nvim_create_autocmd({"BufWritePost", "BufReadPost", "InsertLeave"}, {
	callback = function()
		require('lint').try_lint()
	end,
})

vim.filetype.add({
	extension = {
		tcl = "tcl"
	}
})

-- Lualine settings
local theme = require('lualine.themes.horizon')
theme.normal.a.bg = '#a277ff'
theme.insert.a.bg = '#61ffca'
theme.visual.a.bg = '#ffca85'
theme.replace.a.bg = '#a277ff'
theme.command.a.bg = '#61ffca'
theme.inactive.a.bg = '#f694ff'

-- Gruvbox Dark theme for lualine
-- local theme = require('lualine.themes.gruvbox_dark')

-- Spellwarn Terminal Fix
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("TerminalSettings", { clear = true }),
	callback = function ()
		vim.opt_local.spell = false
	end,
})

-- General LSP settings
if vim.lsp.inlay_hint then
	vim.keymap.set(
		'n',
		"<Leader>l",
		function()
			if vim.lsp.inlay_hint.is_enabled() then
				vim.lsp.inlay_hint.enable(false, { bufnr })
			else
				vim.lsp.inlay_hint.enable(true, { bufnr })
			end
		end,
		{ desc = "Toggle Inlay Hints" }
	)
end

-- General LSP binds
vim.keymap.set('n', "<Leader>e", function() vim.diagnostic.open_float({ focus = false }) end, {})
vim.keymap.set('n', "<Leader>j", function() vim.diagnostic.goto_next() end)
vim.keymap.set('n', "<Leader>k", function() vim.diagnostic.goto_prev() end)
vim.keymap.set('n', "<Leader>i", function() vim.lsp.buf.hover({ focus = false }) end)
vim.keymap.set('n', "<Leader>d", function() vim.lsp.buf.definition() end, { noremap = true, silent = true })
vim.keymap.set('n', "<Leader>r", function() vim.lsp.buf.rename() end, { noremap = true, silent = true })

-- General Neovim binds
vim.keymap.set('i', "<C-e>", '<Esc>', { noremap = true, silent = true })               -- Move to Normal mode
vim.keymap.set('i', "<C-s>", '<Esc>:w<CR>i<Right>', { noremap = true, silent = true }) -- save in Insert mode
vim.keymap.set('i', "<C-z>", '<Esc>ui', { noremap = true, silent = true })             -- Undo in Insert mode
vim.keymap.set('i', "<C-y>", '<Esc>:redo<CR>i', { noremap = true, silent = true })     -- Redo in insert mode
vim.keymap.set('n', "<C-e>", 'i<Right>', { noremap = false, silent = true })           -- Move to Insert mode

-- Neo-tree binds
vim.keymap.set('n', "<Leader>f", ":Neotree<CR>", { silent = true }) -- Open file browser window
vim.keymap.set('n', "<Leader>s", "<C+w>v")                          -- open vertical split

-- requires
require('gruvbox').setup({ transparent = true })
require('lualine').setup({
	options = {
		theme = theme
	}
})
require('render-markdown').setup()
require('spellwarn').setup({
	event = {
		"CursorHold",
		"InsertLeave",
		"TextChanged",
		"TextChangedI",
		"TextChangedP"
	},
	enable = true,
	ft_config = {
		alpha = false,
		help = false,
		-- iter = false,
		lazy = false,
		lspinfo = false,
		mason = false
		-- look into docs for this
	},
	ft_default = true,
	max_file_size = nil,
	severity = {
		spellbad = "WARN",
		spellcap = "HINT",
		spelllocal = "HINT",
		spellrare = "INFO"
	},
	suggest = true,
	num_suggest = 3,
	prefix = "Possible issue(s): ",
	diagnostic_opts = { severity_sort = true }
})
require('spellwarn').enable()
require('playtime').setup({
	window_border = "rounded"
})
require('autoclose').setup()
require('neo-tree').setup({})
require('nvim-treesitter.install').prefer_git = false
require('nvim-treesitter.install').compilers = { "clang" }

local treesitter_setup_data = {
	ensure_installed = { "java", "tcl", "lua", "c" },

	highlight = {
		enable = true,
	},
}

-- background and color theme
vim.cmd('silent! colorscheme aura-dark')
-- vim.cmd.colorscheme('gruvbox') -- gruvbox dark theme
vim.cmd.highlight({ "Normal", "guibg=NONE" })
vim.cmd.highlight({ "Normal", "ctermbg=NONE" })
