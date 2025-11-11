return {
	"stevearc/overseer.nvim",
	opts = {
		task_list = {
			direction = "bottom",
			min_height = 25,
			max_height = 25,
			default_detail = 1
		},
	},
	config = function(_, opts)
		local overseer = require("overseer")
		overseer.setup(opts)
		
		overseer.register_template({
			name = "dotnet build",
			builder = function()
				return {
					cmd = { "dotnet" },
					args = { "build" },
					components = { "default" }
				}
			end,
			condition = {
				filetype = { "cs", "csharp" },
			},
		})

		overseer.register_template({
			name = "dotnet run",
			builder = function()
				return {
					cmd = { "dotnet" },
					args = { "run" },
					components = { "default" }
				}
			end,
			condition = {
				filetype = { "cs", "csharp" },
			},
		})

		overseer.register_template({
			name = "dotnet test",
			builder = function()
				return {
					cmd = { "dotnet" },
					args = { "test" },
					components = { "default" }
				}
			end,
			condition = {
				filetype = { "cs", "csharp" },
			},
		})

		overseer.register_template({
			name = "dotnet watch run",
			builder = function()
				return {
					cmd = { "dotnet" },
					args = { "watch", "run" },
					components = { "default" }
				}
			end,
			condition = {
				filetype = { "cs", "csharp" },
			},
		})

		overseer.register_template({
			name = "dotnet clean",
			builder = function()
				return {
					cmd = { "dotnet" },
					args = { "clean" },
					components = { "default" }
				}
			end,
			condition = {
				filetype = { "cs", "csharp" },
			},
		})
	end,
	keys = {
		{
			"<leader>rb",
			function()
				require("overseer").run_template({ name = "dotnet build" })
			end,
			mode = "n",
			desc = "Overseer: Build .NET Project",
		},
		{
			"<leader>rr",
			function()
				require("overseer").run_template({ name = "dotnet run" })
			end,
			mode = "n",
			desc = "Overseer: Run .NET Project",
		},
		{
			"<leader>rt",
			function()
				require("overseer").run_template({ name = "dotnet test" })
			end,
			mode = "n",
			desc = "Overseer: Test .NET Project",
		},
		{
			"<leader>rw",
			function()
				require("overseer").run_template({ name = "dotnet watch run" })
			end,
			mode = "n",
			desc = "Overseer: Watch Run .NET Project",
		},
		{
			"<leader>rc",
			function()
				require("overseer").run_template({ name = "dotnet clean" })
			end,
			mode = "n",
			desc = "Overseer: Clean .NET Project",
		},
		{
			"<leader>ro",
			function()
				require("overseer").toggle()
			end,
			mode = "n",
			desc = "Overseer: Toggle Task List",
		},
		{
			"<leader>rT",
			function()
				require("overseer").run_template()
			end,
			mode = "n",
			desc = "Overseer: Run Task Template",
		},
		{
			"<leader>rA",
			function()
				require("overseer").run_action()
			end,
			mode = "n",
			desc = "Overseer: Run Task Action",
		},
	},
}