return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    opts = {
      -- open_mapping = [[<leader>t]],
      open_mapping = [[<m-i>]],
      direction = 'float',
      float_opts = {
        border = 'rounded',
        -- width = 20,
        -- height = 20,
        -- row = 200,
        -- col = 300,
        winblend = 0,
        title_pos = 'center',
        width = function()
          return math.ceil(vim.o.columns * 0.9)
        end,
        height = function()
          return math.ceil(vim.o.lines * 0.9)
        end,
      },
    },
  },
}

