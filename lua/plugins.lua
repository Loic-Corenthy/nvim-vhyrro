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
        config = function()
            require("treesitter-modules").setup({
                ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "query"},
                highlight = {
                    enable = true
                },
                incremental_selection = {
                    enable = true,
                    disable = false,
                    -- set value to `false` to disable individual mapping
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        nome_decremental = "grm",
                    },
                },
            })
        end,
    }
})
