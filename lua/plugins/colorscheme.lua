return {
  -- {
  --   "aktersnurra/no-clown-fiesta.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function ()
  --     require("no-clown-fiesta").setup({
  --       transparent = true,
  --     }) vim.cmd("colorscheme no-clown-fiesta")
  --   end
  -- },
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function ()
  --     require("kanagawa").setup({
  --       transparent = true,
  --     })
  --     vim.cmd("colorscheme kanagawa")
  --   end
  -- },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
      require("tokyonight").setup({
        transparent = true,
      })
      vim.cmd("colorscheme tokyonight-moon")
    end
  },
}
