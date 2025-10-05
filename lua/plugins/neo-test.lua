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
			desc = "Test",
		},
		{
			"<leader>tw",
			function()
				require("neotest").watch.toggle(vim.fn.expand("%"))
			end,
			mode = {},
			desc = "Test",
		},
		{
			"<leader>trn",
			function()
				require("neotest").run.run()
			end,
			mode = {},
			desc = "Test",
		},
		{
			"<leader>tr",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			mode = {},
			desc = "Test",
		},
		{
			"<leader>tc",
			function()
				require("neotest").output_panel.clear()
			end,
			mode = {},
			desc = "Test",
		},
		{
			"<leader>tt",
			function()
				require("neotest").output_panel.toggle()
			end,
			mode = {},
			desc = "Test",
		},
	},
}
