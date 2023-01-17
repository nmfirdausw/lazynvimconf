return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree reveal<cr>", desc = "Focus File Explorer" },
    { "<leader>te", "<cmd>Neotree toggle<cr>", desc = "Toggle File Explorer" },
  },
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
  end,
  opts = {
    close_if_last_window = true,
    enable_diagnostics = true,
    popup_border_style = "single",
    default_component_configs = {
      indent = { padding = 0 },
      icon = {
        folder_closed = nik.icons.ui.FolderClosed,
        folder_open = nik.icons.ui.FolderOpen,
        folder_empty = nik.icons.ui.FolderEmpty,
        default = nik.icons.ui.DefaultFile,
      },
      modified = {
        symbol = nik.icons.ui.FileModified,
      },
      git_status = {
        symbols = {
          added = nik.icons.git.Add,
          deleted = nik.icons.git.Deleted,
          modified = nik.icons.git.Modified,
          renamed = nik.icons.git.Renamed,
          untracked = nik.icons.git.Untracked,
          ignored = nik.icons.git.Ignored,
          unstaged = nik.icons.git.Unstaged,
          staged = nik.icons.git.Staged,
          conflict = nik.icons.git.Untracked,
        },
      },
    },
    window = {
      width = 30,
      mappings = {
        ["<space>"] = false,
        o = "open",
        O = function(state) nik.system_open(state.tree:get_node():get_id()) end,
        H = "prev_source",
        L = "next_source",
      },
    },
    filesystem = {
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
      window = { mappings = { h = "toggle_hidden" } },
    },
    event_handlers = {
      { event = "file_opened", handler = function(file_path) require("neo-tree").close_all() end },
    },
  },
}
