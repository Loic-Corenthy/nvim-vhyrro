-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)


-- Setup lazy.nvim
require("lazy").setup({
    {
        "rebelot/kanagawa.nvim",
        config = function()
            vim.cmd.colorscheme("kanagawa")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
    },
    {
        "MeanderingProgrammer/treesitter-modules.nvim",
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
                    init_selection = "<Leader>ss",
                    node_incremental = "<Leader>si",
                    scope_incremental = "<Leader>sc",
                    node_decremental = "<Leader>sd",
                },
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        keys = {
            {"am", mode = { "x", "o"} },
            {"im", mode = { "x", "o"} },
            {"ac", mode = { "x", "o"} },
            {"ic", mode = { "x", "o"} },
            {"as", mode = { "x", "o"} },
        },
        branch = "main",
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            vim.g.no_plugin_maps = true

            -- Or, disable per filetype (add as you like)
            -- vim.g.no_python_maps = true
            -- vim.g.no_ruby_maps = true
            -- vim.g.no_rust_maps = true
            -- vim.g.no_go_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup {
                select = {
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V', -- linewise
                        -- ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true of false
                    include_surrounding_whitespace = false,
                },
            }

            -- keymaps
            -- You can use the capture groups defined in `textobjects.scm`
            local select = require("nvim-treesitter-textobjects.select").select_textobject

            vim.keymap.set({ "x", "o" }, "am", function() select("@function.outer", "textobjects") end, {desc="Select outer function"})
            vim.keymap.set({ "x", "o" }, "im", function() select("@function.inner", "textobjects") end, {desc="Select inner function"})
            vim.keymap.set({ "x", "o" }, "ac", function() select("@class.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "ic", function() select("@class.inner", "textobjects") end)
            -- You can also use captures from other query groups like `locals.scm`
            vim.keymap.set({ "x", "o" }, "as", function() select("@local.scope", "locals") end)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config("clangd", {})
            vim.lsp.enable({"clangd"})
        end
    },
    {
        "mason-org/mason.nvim",
        opts = {}
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    {
        "saghen/blink.cmp",
        event = {"InsertEnter", "CmdwinEnter" },
        --- event = { "VeryLazy" },
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*",
        opts = {
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = "super-tab" },
            appearance = {
                nerd_font_variant = "mono"
            },
            completion = { documentation = { auto_show = true } },
            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
})


