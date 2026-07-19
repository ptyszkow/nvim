-- Telescope extension: pass ripgrep arguments from the live-grep prompt.

vim.pack.add { 'https://github.com/nvim-telescope/telescope-live-grep-args.nvim' }

local telescope = require 'telescope'
local live_grep_args_actions = require 'telescope-live-grep-args.actions'

telescope.setup {
  extensions = {
    live_grep_args = {
      -- Parse the prompt as ripgrep arguments directly, so you can type:
      -- TODO --iglob **/*.py
      auto_quoting = false,
      mappings = {
        i = {
          -- Search for a term, press Ctrl-I, then enter a glob.
          -- Example result: "TODO" --iglob **/*.py
          ['<C-i>'] = live_grep_args_actions.quote_prompt { postfix = ' --iglob ' },
        },
      },
    },
  },
}

telescope.load_extension 'live_grep_args'

vim.keymap.set(
  'n',
  '<leader>sg',
  telescope.extensions.live_grep_args.live_grep_args,
  { desc = '[S]earch by [G]rep with file globs' }
)
