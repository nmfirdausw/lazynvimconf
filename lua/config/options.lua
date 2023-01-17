local opt = {
  backspace = vim.opt.backspace + { "nostop" },
  clipboard = "unnamedplus",
  -- cmdheight = 0,
  completeopt = { "menu", "menuone", "noselect" },
  confirm = true,
  copyindent = true,
  cursorcolumn = true,
  cursorline = true,
  expandtab = true,
  fileencoding = "utf-8",
  fillchars = { eob = " " },
  history = 100,
  ignorecase = true,
  laststatus = 3,
  lazyredraw = true,
  mouse = "a",
  number = true,
  preserveindent = true,
  pumheight = 10,
  relativenumber = true,
  scrolloff = 10,
  shiftwidth = 2,
  sidescrolloff = 10,
  signcolumn = "yes",
  smartcase = true,
  splitbelow = true,
  splitright = true,
  tabstop = 2,
  termguicolors = true,
  timeoutlen = 300,
  undofile = true,
  updatetime = 300,
  wrap = false,
  writebackup = false,
  swapfile = false,
}

local g = {
  mapleader = " ",
}

for key, value in pairs(opt) do
	vim.opt[key] = value
end

for key, value in pairs(g) do
	vim.g[key] = value
end
