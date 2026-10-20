-- Wrap the word under the cursor (normal mode) or the selection (visual mode)
-- in a Markdown marker, e.g. word -> **word**
local function wrap(lhs, marker, desc)
  local rhs = "`>a" .. marker .. "<Esc>`<i" .. marker .. "<Esc>"
  vim.keymap.set("n", lhs, "viw<Esc>" .. rhs, { buffer = true, desc = desc })
  vim.keymap.set("x", lhs, "<Esc>" .. rhs, { buffer = true, desc = desc })
end

wrap("<leader>fc", "`", "Format as inline code")
wrap("<leader>fb", "**", "Format as bold")
wrap("<leader>fi", "_", "Format as italic")
wrap("<leader>fs", "~~", "Format as strikethrough")

vim.cmd([[iabbrev <buffer> <expr> ttoday '==' .. strftime('%d/%m/%Y') .. '==']])

vim.keymap.set("n", "<leader>ch", "i- [ ] ", { buffer = true, desc = desc })

