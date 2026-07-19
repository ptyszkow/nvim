-- neotest: run and debug tests from Neovim
-- https://github.com/nvim-neotest/neotest
--
-- Adapters:
--   python  -> nvim-neotest/neotest-python  (pytest / unittest)
--   rust    -> rouge8/neotest-rust         (treesitter + cargo-nextest)
--   dotnet  -> nsidorenco/neotest-vstest   (VSTest / MTP)
--
-- Rust: needs `cargo install cargo-nextest`. Uses kickstart rust_analyzer + codelldb.

vim.pack.add {
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/neotest-python',
  'https://github.com/rouge8/neotest-rust',
  'https://github.com/nsidorenco/neotest-vstest',
}

-- Prefer uv / venv python when present (matches custom/plugins/debug.lua).
local function python_path()
  local uv = vim.fn.exepath 'uv'
  if uv ~= '' then
    local result = vim.system({ uv, 'run', 'python', '-c', 'import sys; print(sys.executable)' }, { text = true }):wait()
    if result.code == 0 then
      local interpreter = vim.trim(result.stdout or '')
      if interpreter ~= '' then return interpreter end
    end
  end

  local virtual_env = vim.env.VIRTUAL_ENV
  if virtual_env and virtual_env ~= '' then return virtual_env .. '/bin/python' end

  if vim.fn.exepath 'python3' ~= '' then return vim.fn.exepath 'python3' end
  return vim.fn.exepath 'python'
end

-- neotest-vstest: use the same DAP adapter name as custom/plugins/debug.lua
vim.g.neotest_vstest = {
  dap_settings = {
    type = 'coreclr',
  },
  -- Avoid freezes when Neovim is opened far above a solution root.
  broad_recursive_discovery = false,
}

require('neotest').setup {
  adapters = {
    require 'neotest-python' {
      dap = { justMyCode = false },
      runner = 'pytest',
      python = python_path,
    },
    require 'neotest-rust' {
      -- Needs: cargo install cargo-nextest
      args = { '--no-capture' },
      -- Matches custom/plugins/debug.lua codelldb adapter name.
      dap_adapter = 'codelldb',
    },
    require 'neotest-vstest',
  },
  discovery = {
    enabled = true,
  },
  summary = {
    open = 'botright vsplit | vertical resize 50',
  },
}

-- Keymaps: <leader>t is Toggle (th/tb/tw); free letters used for tests.
local neotest = require 'neotest'

vim.keymap.set('n', '<leader>tr', function() neotest.run.run() end, { desc = 'Test: run nearest' })
vim.keymap.set('n', '<leader>tf', function() neotest.run.run(vim.fn.expand '%') end, { desc = 'Test: run file' })
vim.keymap.set('n', '<leader>tA', function() neotest.run.run(vim.uv.cwd()) end, { desc = 'Test: run all (cwd)' })
vim.keymap.set('n', '<leader>td', function() neotest.run.run { strategy = 'dap' } end, { desc = 'Test: debug nearest' })
vim.keymap.set('n', '<leader>tS', function() neotest.run.stop() end, { desc = 'Test: stop' })
vim.keymap.set('n', '<leader>ta', function() neotest.run.attach() end, { desc = 'Test: attach' })
vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end, { desc = 'Test: summary' })
vim.keymap.set('n', '<leader>to', function() neotest.output.open { enter = true, auto_close = true } end, { desc = 'Test: output' })
vim.keymap.set('n', '<leader>tO', function() neotest.output_panel.toggle() end, { desc = 'Test: output panel' })
vim.keymap.set('n', '<leader>tW', function() neotest.watch.toggle(vim.fn.expand '%') end, { desc = 'Test: watch file' })
