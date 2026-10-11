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

      on_open = function(term)
        local opts = { buffer = term.bufnr, silent = true }

        -- Remove buffer change when in terminal
        vim.keymap.set("n", "<Left>", "<Nop>", opts)
        vim.keymap.set("n", "<Right>", "<Nop>", opts)
        vim.keymap.set("i", "<Left>", "<Nop>", opts)
        vim.keymap.set("i", "<Right>", "<Nop>", opts)
      end,

      },
    },
  },
}

