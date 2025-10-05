return {
	"nvim-mini/mini.nvim",
	version = "*",
	config = function()
		require("mini.surround").setup()
		require("mini.ai").setup()
		require("mini.move").setup()
	end,
}
