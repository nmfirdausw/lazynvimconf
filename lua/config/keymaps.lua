local set = vim.keymap.set

set("v", "<", "<gv", { desc = "Indent line" })
set("v", ">", ">gv", { desc = "Unindent line" })
set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
set("n", "J", "mzJ`z", { desc = "Append up bottom line" })
set("n", "<C-d>", "<C-d>zz", { desc = "Jump half page up" })
set("n", "<C-u>", "<C-u>zz", { desc = "Jump half page down" })
set("n", "n", "nzzzv", { desc = "Next" })
set("n", "N", "Nzzzv", { desc = "Previous" })
set("x", "<leader>p", '"_dP', { desc = "Paste from clipboard" })
