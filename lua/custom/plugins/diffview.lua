-- diffview.nvim: single-tabpage git diff / file history UI
-- https://github.com/sindrets/diffview.nvim

vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

require('diffview').setup {
  enhanced_diff_hl = true,
  view = {
    default = {
      layout = 'diff2_horizontal',
    },
    merge_tool = {
      layout = 'diff3_horizontal',
      disable_diagnostics = true,
    },
  },
}

-- Free leader maps (no existing <leader>g* bindings in this config)
vim.keymap.set('n', '<leader>gd', '<Cmd>DiffviewOpen<CR>', { desc = 'Diffview: open' })
vim.keymap.set('n', '<leader>gh', '<Cmd>DiffviewFileHistory %<CR>', { desc = 'Diffview: file [H]istory' })
vim.keymap.set('n', '<leader>gH', '<Cmd>DiffviewFileHistory<CR>', { desc = 'Diffview: branch [H]istory' })
vim.keymap.set('n', '<leader>gq', '<Cmd>DiffviewClose<CR>', { desc = 'Diffview: close' })

