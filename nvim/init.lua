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
Plug('https://github.com/MeanderingProgrammer/render-markdown.nvim.git')
Plug('https://github.com/typicode/bg.nvim.git')
Plug('https://github.com/m4xshen/autoclose.nvim.git')
Plug('daltonmenezes/aura-theme', {['rtp'] = 'packages/neovim'})
Plug('datsfilipe/gruvbox.nvim')
Plug('rust-lang/rust.vim')
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ":TSUpdate"})
Plug('https://github.com/chomosuke/typst-preview.nvim')
Plug('https://github.com/ravibrock/spellwarn.nvim')
Plug('rktjmp/playtime.nvim')

vim.call('plug#end')

-- Lua settings
vim.lsp.config["luals"] = {
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

-- Typst/TinyMist settings
vim.lsp.config["tinymist"] = {
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

-- General LSP settings
if vim.lsp.inlay_hint then
  vim.keymap.set(
			'n',
			"<Leader>l",
			function()
				if vim.lsp.inlay_hint.is_enabled() then
					vim.lsp.inlay_hint.enable(false, { bufnr })
				else vim.lsp.inlay_hint.enable(true, { bufnr }) end
			end,
			{desc = "Toggle Inlay Hints"}
		)
end

-- General LSP binds
vim.keymap.set('n', "<Leader>e", function() vim.diagnostic.open_float({ focus = false }) end, {})
vim.keymap.set('n', "<Leader>j", function() vim.diagnostic.goto_next() end)
vim.keymap.set('n', "<Leader>k", function() vim.diagnostic.goto_prev() end)
vim.keymap.set('n', "<Leader>i", function() vim.lsp.buf.hover({ focus = false }) end)

-- General Neovim binds
vim.keymap.set('i', "<C-e>", '<Esc>', { noremap = true, silent = true }) -- Move to Normal mode
vim.keymap.set('i', "<C-s>", '<Esc>:w<CR>i<Right>', { noremap = true, silent = true }) -- save in Insert mode
vim.keymap.set('i', "<C-z>", '<Esc>ui', { noremap = true, silent = true }) -- Undo in Insert mode
vim.keymap.set('i', "<C-y>", '<Esc>:redo<CR>i', { noremap = true, silent = true}) -- Redo in insert mode
vim.keymap.set('n', "<C-e>", 'i<Right>', { noremap = false, silent = true }) -- Move to Insert mode

-- Neo-tree binds
vim.keymap.set('n', "<Leader>f", ":Neotree<CR>", { silent = true }) -- Open file browser window

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
require('nvim-treesitter.install').compilers = { "gcc" }
require('nvim-treesitter.configs').setup {
	ensure_installed = { "java" },

	highlight = {
		enable = true,
	},
}

-- background and color theme
vim.cmd('silent! colorscheme aura-dark')
-- vim.cmd.colorscheme('gruvbox') -- gruvbox dark theme
vim.cmd.highlight({ "Normal", "guibg=NONE" })
vim.cmd.highlight({ "Normal", "ctermbg=NONE" })
