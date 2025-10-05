-- Options
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.winborder = "rounded"
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Performance
vim.opt.updatetime = 250 -- Faster completion
vim.opt.timeoutlen = 500 -- Shorter mapped sequence wait
-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.cmd(":hi statusline guibg=NONE")
-- LSP utils
local map = vim.keymap.set
vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
--vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[G]oto Code [A]ction" })

vim.lsp.enable({ "lua_ls", "csharp_ls" })
require("config.lazy")
require("config.dap")
require("config.terminal")

vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- could be "■", "▎", "x"
		spacing = 4,
	},
	signs = true, -- show signs in the gutter
	underline = true,
	update_in_insert = false, -- don't update diagnostics while typing
	severity_sort = true, -- order by severity (errors first)

	float = {
		border = "rounded", -- nice borders around floating windows
		source = "always", -- show the source of the diagnostic
		header = "",
		prefix = "",
	},
})
