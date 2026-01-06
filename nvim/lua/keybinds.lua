-- lua/keymaps.lua
local map = vim.keymap.set

-- Better Esc in terminal (works for ALL terminal buffers, including :term, splits, etc.)
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape terminal mode" })
