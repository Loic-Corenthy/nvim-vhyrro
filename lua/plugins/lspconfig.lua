return {
    "neovim/nvim-lspconfig",

    dependencies = {
        { "j-hui/fidget.nvim", opts = {} },
        "saghen/blink.cmp",
    },

    config = function()
        vim.lsp.config("clangd", {})
        vim.lsp.enable({"clangd"})
    end
}

