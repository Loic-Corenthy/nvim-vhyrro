return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
    -- "mfussenegger/nvim-dap-python", -- Optional: for debugger support
  },
  ft = "python",
  keys = {
    { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Virtual Environment" },
  },
  opts = {
    auto_refresh = true,
  },
}
