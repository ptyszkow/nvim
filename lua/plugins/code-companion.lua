return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			-- strategies = {
			-- 	chat = {
			-- 		name = "copilot",
			-- 		model = "claude-sonnet-4",
			-- 	},
			-- 	inline = {
			-- 		name = "copilot",
			-- 		model = "claude-sonnet-4",
			-- 	},
			-- 	cmd = {
			-- 		name = "copilot",
			-- 		model = "claude-sonnet-4",
			-- 	},
			-- },
			-- opts = {
			-- 	log_level = "DEBUG", -- or "TRACE"
			-- },
      strategies = {
        chat = {
          adapter = "openai",
			 		model = "GPT-5",
        },
        inline = {
          adapter = "openai",
			 		model = "GPT-5",
        },
        cmd = {
          adapter = "openai",
			 		model = "GPT-5",
        },
      },
		}

	)

		vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true, desc = "AI Actions" })
		vim.keymap.set(
			{ "n", "v" },
			"<Leader>at",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ noremap = true, silent = true, desc = "Toggle AI Chat" }
		)
		vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true, desc = "Add to AI Chat" })

		-- Expand 'cc' into 'CodeCompanion' in the command line
		vim.cmd([[cab cc CodeCompanion]])
	end,
}
