-- Keymaps

vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<Left>", "<Cmd>bp<CR>")
vim.keymap.set("n", "<Right>", "<Cmd>bn<CR>")
vim.keymap.set("n", "<Up>", "<Cmd>tabfirst<CR>")
vim.keymap.set("n", "<Down>", "<Cmd>tablast<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set("i", "kj", "<Esc>", { desc = "Escape insert mode" })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "h", "hpp", "cpp", "c", "cmake" },
  callback = function()
    vim.keymap.set("n", "<leader>mb", ":CMakeBuild<cr>", { buffer = true, desc = "Build" })
    vim.keymap.set("n", "<leader>msc", ":CMakeSelectConfigurePreset<cr>", { buffer = true, desc = "Select Configure Preset" })
    vim.keymap.set("n", "<leader>msb", ":CMakeSelectBuildPreset<cr>", { buffer = true, desc = "Select Build Preset" })
    vim.keymap.set("n", "<leader>mst", ":CMakeSelectBuildTarget<cr>", { buffer = true, desc = "Select Build Target" })
    vim.keymap.set("n", "<leader>mrt", ":CMakeSelectLaunchTarget<cr>", { buffer = true, desc = "CMake Select Launche Target" })
    vim.keymap.set("n", "<leader>mr", ":CMakeRun<cr>", { buffer = true, desc = "CMake Run" })
  end,
})


