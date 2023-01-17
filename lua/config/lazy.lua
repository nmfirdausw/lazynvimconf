local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then

vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath }) end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    -- lazy = true,
    version = "*",
  },
  install = { colorscheme = { "melange", "habamax" } },
  checker = { enable = true },
  performance = {
    rtp = {
      paths = {
        { "/Users/nmfirdausw/.config/nvim/pack/github/start/copilot.vim" }
      },
      disabled_plugins = {

      },
    },
  },
})
