return {
  "rebelot/heirline.nvim",
  config = function ()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    local colors = {
      statusline_bg = utils.get_highlight("StatusLine").bg,
      statusline_fg = utils.get_highlight("StatusLine").fg,
      default_fg = utils.get_highlight("@variable").fg,
      comments = utils.get_highlight("Comment").fg,
      statements = utils.get_highlight("Statement").fg,
      strings = utils.get_highlight("String").fg,
      functions = utils.get_highlight("Function").fg,
      specials = utils.get_highlight("Special").fg,
      types = utils.get_highlight("Type").fg,
      operators = utils.get_highlight("Operator").fg,
      identifiers = utils.get_highlight("NvimIdentifier").fg,
      numbers = utils.get_highlight("Number").fg,
      variables = utils.get_highlight("@variable.builtin").fg,
      git_add = utils.get_highlight("GitSignsAdd").fg,
      git_delete = utils.get_highlight("GitSignsDelete").fg,
      git_change = utils.get_highlight("GitSignsChange").fg,
      error = utils.get_highlight("DiagnosticError").fg,
      warning = utils.get_highlight("DiagnosticWarn").fg,
      info = utils.get_highlight("DiagnosticInfo").fg,
      hint = utils.get_highlight("DiagnosticHint").fg,
    }

    require("heirline").load_colors(colors)

    local space = {
      provider = " ",
      hl = { bg = colors.sumiInk0, }
    }

    local align = { provider = "%=" }

    local git_branch = {
      condition = conditions.is_git_repo,

      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,

      {
        condition = function (self)
          return self.has_changes
        end,
        provider = function(self)
          return " " .. self.status_dict.head .. " "
        end,
        hl = { bold = true, fg = "git_change", bg = "statusline_bg"}
      },

      {
        condition = function (self)
          return not self.has_changes
        end,
        provider = function(self)
          return " " .. self.status_dict.head .. "  "
        end,
        hl = { bold = true, fg = "default_fg", bg = "statusline_bg" }
      },
    }

    local git_status = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and (nik.icons.git.Add .. " " .. count .. " ")
        end,
        hl = { bg = "statusline_bg", fg = "git_add" },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and (nik.icons.git.Modified .. " " .. count .. " ")
        end,
        hl = { bg = "statusline_bg", fg = "git_change" },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and (nik.icons.git.Ignored .. " " .. count .. " ")
        end,
        hl = { bg = "statusline_bg", fg = "git_delete" },
      },
    }

    local function get_file_name(file)
      return file:match("^.+/(.+)$")
    end

    local file_flags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = " ",
        hl = { fg = "git_change", bg = "statusline_bg" },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "",
        hl = { fg = "git_delete", bg = "statusline_bg" },
      },
    }

    local file_path_flags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = " ",
        hl = { fg = "git_change" },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "",
        hl = { fg = "git_delete" },
      },
    }

    local file_icon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return " " .. self.icon and (" " .. self.icon .. " ")
      end,
      hl = function(self)
        return { fg = self.icon_color, bg = "statusline_bg" }
      end
    }

    local file_path_icon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return " " .. self.icon and (" " .. self.icon .. " ")
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end
    }

    local file_type = {
      provider = function()
        return string.upper(vim.bo.filetype)
      end,
      hl = { fg = utils.get_highlight("Type").fg, bg = colors.sumiInk0 },
    }

    local file_name = {
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
        if not self.once then
          vim.api.nvim_create_autocmd("ModeChanged", {
            pattern = "*:*o",
            command = 'redrawstatus'
          })
          self.once = true
        end
      end,
      static = {
        mode_colors = {
          n = "statusline_fg" ,
          i = "strings",
          v = "specials",
          V =  "specials",
          ["\22"] =  "specials",
          c =  "warning",
          s =  "statements",
          S =  "statements",
          ["\19"] =  "statements",
          R =  "warning",
          r =  "orange",
          ["!"] =  "variables",
          t =  "variables",
        },
      },
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then
          return "[No Name]"
        end
        if string.find(filename, "/") then
          filename = get_file_name(filename)
        end
        return filename .. " "
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { fg = self.mode_colors[mode], bg = "statusline_bg"}
      end,
      update = {
        "ModeChanged",
      },
    }

    local file_name_block = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
      hl = { bg = colors.sumiInk0 },
    }

    local file_name_modifier = {
      hl = function()
        if vim.bo.modified then
          return { force=true }
        end
      end,
    }

    file_name = utils.insert(file_name_block,
      file_icon,
      utils.insert(file_name_modifier, file_name),
      unpack(file_flags),
      { provider = '%<'}
    )

    local file_path_block = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }

    local file_path_modifier = {
      hl = function()
        if vim.bo.modified then
          return { force=true }
        end
      end,
    }

    local file_path = {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then
          return "[No Name]"
        end
        return filename .. " "
      end,
    }

    file_path = utils.insert(file_path_block,
      file_path_icon,
      utils.insert(file_path_modifier, file_path),
      unpack(file_path_flags),
      { provider = '%<'}
    )

    local diagnostics = {
      condition = conditions.has_diagnostics,
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,
      update = { "DiagnosticChanged", "BufEnter" },
      {
        provider = function(self)
            return self.errors > 0 and (nik.icons.diagnostics.Error .. self.errors .. " ")
        end,
        hl = { bg = "statusline_bg", fg = "error" },
      },
      {
        provider = function(self)
            return self.warnings > 0 and (nik.icons.diagnostics.Warn .. self.warnings .. " ")
        end,
        hl = { bg = "statusline_bg", fg = "warning" },
      },
      {
        provider = function(self)
            return self.info > 0 and (nik.icons.diagnostics.Info .. self.info .. " ")
        end,
        hl = { bg = "statusline_bg", fg = "info" },
      },
      {
        provider = function(self)
            return self.hints > 0 and (nik.icons.diagnostics.Hint .. self.hints .. " ")
        end,
        hl = { bg = "statusline_bg", fg = "hint" },
      },
      hl = { bg = colors.sumiInk0 }
    }

    local scroll_bar = {
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
        if not self.once then
          vim.api.nvim_create_autocmd("ModeChanged", {
            pattern = "*:*o",
            command = 'redrawstatus'
          })
          self.once = true
        end
      end,
      static = {
        -- sbar = { '█', '▇', '▆', '▅', '▄', '▃', '▂', '▁', ' ' }
        sbar = { ' ', '▁', '▂', '▃', '▄', '▆', '▆', '▇', '█' },
        mode_colors = {
          n = "statusline_fg" ,
          i = "strings",
          v = "specials",
          V =  "specials",
          ["\22"] =  "specials",
          c =  "warning",
          s =  "statements",
          S =  "statements",
          ["\19"] =  "statements",
          R =  "warning",
          r =  "orange",
          ["!"] =  "variables",
          t =  "variables",
        },
      },
      provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2)
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { fg = self.mode_colors[mode], bg = "statusline_bg"}
      end,
    }

    local lsp_active = {
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
        if not self.once then
          vim.api.nvim_create_autocmd("ModeChanged", {
            pattern = "*:*o",
            command = 'redrawstatus'
          })
          self.once = true
        end
      end,
      static = {
        -- sbar = { '█', '▇', '▆', '▅', '▄', '▃', '▂', '▁', ' ' }
        sbar = { ' ', '▁', '▂', '▃', '▄', '▆', '▆', '▇', '█' },
        mode_colors = {
          n = "statusline_fg" ,
          i = "strings",
          v = "specials",
          V =  "specials",
          ["\22"] =  "specials",
          c =  "warning",
          s =  "statements",
          S =  "statements",
          ["\19"] =  "statements",
          R =  "warning",
          r =  "orange",
          ["!"] =  "variables",
          t =  "variables",
        },
      },
      condition = conditions.lsp_attached,
      update = {"LspAttach", "LspDetach", "ModeChanged"},
      {
        provider = "  ",
        hl = { bg = "statusline_bg" }
      },
      {
        provider  = function()
          local names = {}
          for _, server in pairs(vim.lsp.buf_get_clients(0)) do
            table.insert(names, server.name)
          end
          return table.concat(names, " ")
        end,

        hl = function(self)
          local mode = self.mode:sub(1, 1)
          return { fg = self.mode_colors[mode], bg = "statusline_bg"}
        end,
      },
      {
        provider = " ",
        hl = { bg = "statusline_bg" }
      },
    }

    local navic_bar = {
      condition = require("nvim-navic").is_available,
      static = {
        type_hl = {
          File = "Directory",
          Module = "@include",
          Namespace = "@namespace",
          Package = "@include",
          Class = "@structure",
          Method = "@method",
          Property = "@property",
          Field = "@field",
          Constructor = "@constructor",
          Enum = "@field",
          Interface = "@type",
          Function = "@function",
          Variable = "@variable",
          Constant = "@constant",
          String = "@string",
          Number = "@number",
          Boolean = "@boolean",
          Array = "@field",
          Object = "@type",
          Key = "@keyword",
          Null = "@comment",
          EnumMember = "@field",
          Struct = "@structure",
          Event = "@keyword",
          Operator = "@operator",
          TypeParameter = "@type",
        },
        enc = function(line, col, winnr)
          return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
        end,
        dec = function(c)
          local line = bit.rshift(c, 16)
          local col = bit.band(bit.rshift(c, 6), 1023)
          local winnr = bit.band(c,  63)
          return line, col, winnr
        end
      },
      init = function(self)
        local data = require("nvim-navic").get_data() or {}
        local children = {}
        for i, d in ipairs(data) do
          local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
          local child = {
              {
                  provider = d.icon,
                  hl = self.type_hl[d.type],
              },
              {
                provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ''),
                on_click = {
                  minwid = pos,
                  callback = function(_, minwid)
                    local line, col, winnr = self.dec(minwid)
                    vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), {line, col})
                  end,
                  name = "heirline_navic",
                },
              },
            }
            if #data > 1 and i < #data then
              table.insert(child, {
                provider = " ",
              })
            end
            table.insert(children, child)
        end
        self.child = self:new(children, 1)
      end,
      provider = function(self)
        return self.child:eval()
      end,
      hl = { fg = colors.fujiWhite },
      update = 'CursorMoved'
    }

    local winbar = {
      {
        condition = function()
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix", "terminal" },
            filetype = { "^git.*", "fugitive" },
          })
        end,
        init = function()
          vim.opt_local.winbar = nil
        end
      },
      { navic_bar, align, file_path }
    }

    require("heirline").setup({
      statusline = { git_branch, file_name, align, lsp_active, align, git_status, diagnostics, scroll_bar },
      winbar = winbar
    })
  end
}
