return {
    "meanderingprogrammer/treesitter-modules.nvim",
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    opts = {
        ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "query"},
        fold = { enable = false },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            disable = false,
            -- set value to `false` to disable individual mapping
            keymaps = {
                init_selection = "<leader>ss",
                node_incremental = "<leader>si",
                scope_incremental = "<leader>sc",
                node_decremental = "<leader>sd",
            },
        },
    },
}

