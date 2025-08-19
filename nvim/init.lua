local vim = vim
local Plug = vim.fn['plug#']

-- various nvim editor settings
vim.cmd([[set mouse=]])
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
vim.o.showmode = false

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
Plug('rust-lang/rust.vim')
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ":TSUpdate"})

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

-- Lualine settings
local theme = require('lualine.themes.horizon')
theme.normal.a.bg = '#a277ff'
theme.insert.a.bg = '#61ffca'
theme.visual.a.bg = '#ffca85'
theme.replace.a.bg = '#a277ff'
theme.command.a.bg = '#61ffca'
theme.inactive.a.bg = '#f694ff'

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
vim.keymap.set('n', "<Leader>s", ':w<CR>')
vim.keymap.set('i', "<C-e>", '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', "<Leader>i", function() vim.lsp.buf.hover({ focus = false }) end)

-- Neo-tree binds
vim.keymap.set('n', "<Leader>f", ":Neotree<CR>", { silent = true })

-- requires
require('lualine').setup({
	options = {
		theme = theme
	}
})
require('render-markdown').setup()
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

-- bg and color theme
vim.cmd('silent! colorscheme aura-dark')
vim.cmd.highlight({ "Normal", "guibg=NONE" })
vim.cmd.highlight({ "Normal", "ctermbg=NONE" })
