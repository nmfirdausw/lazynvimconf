return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  dependencies = {
    { "p00f/nvim-ts-rainbow" },
    { "windwp/nvim-ts-autotag" },
  },
  opts = {
    sync_install = false,
    highlight = { enable = true },
    context_commentstring = { enable = true, enable_autocmd = false },
    rainbow = {
      enable = true,
      disable = { },
      extended_mode = false,
      max_file_lines = nil,
    },
    autotag = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = false },
    ensure_installed = {
      "bash",
      "help",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "yaml",
      "php"
    },
  },
  config = function(plugin, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
