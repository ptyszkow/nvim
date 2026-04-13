-- Options
vim.g.active_theme = "catppuccin" -- options: tokyonight, catppuccin, kanagawa, rose-pine, cyberdream
-- vim.g.active_theme = "kanagawa"
-- vim.g.active_theme = "rose-pine"
--vim.g.active_theme = "cyberdream"
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
vim.o.clipboard = "unnamedplus"
local osc52 = require("vim.ui.clipboard.osc52")
local clipboard_cache = { ["+"] = { { "" }, "v" }, ["*"] = { { "" }, "v" } }
local function make_copy(reg)
  local inner = osc52.copy(reg)
  return function(lines, regtype)
    clipboard_cache[reg] = { lines, regtype or "v" }
    inner(lines, regtype)
  end
end
vim.g.clipboard = {
  name = "OSC 52",
  copy = { ["+"] = make_copy("+"), ["*"] = make_copy("*") },
  paste = {
    ["+"] = function() return clipboard_cache["+"] end,
    ["*"] = function() return clipboard_cache["*"] end,
  },
}
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
if vim.fn.executable("rg") == 1 then
  vim.o.grepprg = "rg --vimgrep --smart-case"
end
vim.cmd(":hi statusline guibg=NONE")

vim.keymap.set("n", "<leader>ui", ":update<CR> :source<CR>", { desc = "Update and Source Init" })
--vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>ch", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })
vim.keymap.set("n", "<leader>cL", vim.lsp.codelens.run, { desc = "Run Codelens" })

vim.keymap.set("n", "<leader>ft",
  [[:vimgrep /\v^\s*[-*]\s+\[ \]\s+.*/gj **/*.md<CR>]],
  { desc = "Find Markdown unchecked todos" }
)
vim.g.dotnet_lsp = "csharp_ls"
vim.lsp.enable({ "lua_ls", vim.g.dotnet_lsp, "basedpyright", "jsonls", "yamlls", "html", "ts_ls" })

require("config.lazy")
require("config.dap")

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,

	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})

--vim.g.python3_host_prog = "/home/peter/Projects/TestUV/.venv/bin/python"
