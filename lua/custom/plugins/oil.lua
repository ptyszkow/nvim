-- oil.nvim: edit the filesystem like a Neovim buffer
-- https://github.com/stevearc/oil.nvim

vim.pack.add { 'https://github.com/stevearc/oil.nvim' }

require('oil').setup {
  -- Keep neo-tree / netrw free to own directory opens if preferred;
  -- open oil explicitly with the keymap below.
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
  },
}

vim.keymap.set('n', '<leader>oi', '<Cmd>Oil<CR>', { desc = '[O]il: open parent directory' })
