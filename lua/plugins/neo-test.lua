return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nsidorenco/neotest-vstest",
		"Issafalcon/neotest-dotnet",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-dotnet"),
			},
		})

		--

		-- require("neotest").output_panel.open()
	end,
	keys = {
		{
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
			mode = {},
			desc = "Toggle Test Summary",
		},
		{
			"<leader>tw",
			function()
				require("neotest").watch.toggle(vim.fn.expand("%"))
			end,
			mode = {},
			desc = "Toggle Test Watch",
		},
		{
			"<leader>trn",
			function()
				require("neotest").run.run()
			end,
			mode = {},
			desc = "Run Nearest Test",
		},
		{
			"<leader>tr",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			mode = {},
			desc = "Run Test File",
		},
		{
			"<leader>tc",
			function()
				require("neotest").output_panel.clear()
			end,
			mode = {},
			desc = "Clear Test Output",
		},
		{
			"<leader>tt",
			function()
				require("neotest").output_panel.toggle()
			end,
			mode = {},
			desc = "Toggle Test Output",
		},
	},
}
