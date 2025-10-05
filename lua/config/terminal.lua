-- Minimal, robust floating terminal toggle (drop in init.lua)
local floatterm = (function()
	local buf, win

	local function cfg()
		local ui = vim.api.nvim_list_uis()[1]
		local w, h = math.floor(ui.width * 0.9), math.floor(ui.height * 0.9)
		return {
			relative = "editor",
			width = w,
			height = h,
			col = math.floor((ui.width - w) / 2),
			row = math.floor((ui.height - h) / 2),
			border = "rounded",
			style = "minimal",
		}
	end

	local function job_running()
		if not (buf and vim.api.nvim_buf_is_valid(buf)) then
			return false
		end
		if vim.bo[buf].buftype ~= "terminal" then
			return false
		end
		local ok, id = pcall(vim.api.nvim_buf_get_var, buf, "terminal_job_id")
		if not ok then
			return false
		end
		return vim.fn.jobwait({ id }, 0)[1] == -1 -- -1 == running
	end

	local function fresh_buf()
		buf = vim.api.nvim_create_buf(false, true) -- scratch, nofile
		vim.bo[buf].bufhidden = "hide"
	end

	local function ensure_buf()
		if not (buf and vim.api.nvim_buf_is_valid(buf)) then
			fresh_buf()
			return
		end
		if vim.bo[buf].buftype ~= "" then
			-- If it’s a terminal (finished) or any special buftype, start fresh
			if vim.bo[buf].buftype ~= "terminal" or not job_running() then
				fresh_buf()
			end
		end
	end

	return function()
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
			return
		end
		ensure_buf()
		win = vim.api.nvim_open_win(buf, true, cfg())
		if not job_running() then
			-- Only spawn in a brand-new, unmodified buffer
			vim.api.nvim_set_current_buf(buf)
			vim.fn.termopen(vim.o.shell)
		end
		vim.cmd.startinsert()
	end
end)()

-- Keys: toggle from normal or terminal mode
-- vim.keymap.set({ "n", "t" }, "<leader>t", floatterm, { desc = "Toggle floating terminal" })
vim.keymap.set({ "n", "t" }, "<C-\\>", floatterm, { desc = "Toggle floating terminal" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal: normal mode" })
