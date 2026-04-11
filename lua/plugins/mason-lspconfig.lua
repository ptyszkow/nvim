return 
{
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = { "lua_ls", vim.g.dotnet_lsp or "omnisharp" },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
