return {
  "rebelot/heirline.nvim",
  config = function ()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    local colors = {
      statusline_bg = utils.get_highlight("StatusLine").bg,
      statusline_fg = utils.get_highlight("StatusLine").fg,
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

    local statusline_bg = {
      provider = "status_bg",
      hl = { fg = "statusline_bg", bg = "statusline_bg", bold = true }
    }

    local statusline_fg = {
      provider = "status_fg",
      hl = { fg = "statusline_fg", bg = "statusline_fg", bold = true }
    }

    local comments = {
      provider = "comments",
      hl = { fg = "comments", bg = "comments", bold = true }
    }

    local statements = {
      provider = "statements",
      hl = { fg = "statements", bg = "statements", bold = true }
    }

    local strings = {
      provider = "strings",
      hl = { fg = "strings", bg = "strings", bold = true }
    }

    local functions = {
      provider = "functions",
      hl = { fg = "functions", bg = "functions", bold = true }
    }

    local specials = {
      provider = "specials",
      hl = { fg = "specials", bg = "specials", bold = true }
    }

    local types = {
      provider = "types",
      hl = { fg = "types", bg = "types", bold = true }
    }

    local operators = {
      provider = "operators",
      hl = { fg = "operators", bg = "operators", bold = true }
    }

    local identifiers = {
      provider = "identifiers",
      hl = { fg = "identifiers", bg = "identifiers", bold = true }
    }

    local numbers = {
      provider = "numbers",
      hl = { fg = "numbers", bg = "numbers", bold = true }
    }

    local variables = {
      provider = "variables",
      hl = { fg = "variables", bg = "variables", bold = true }
    }

    local git_add = {
      provider = "git_add",
      hl = { fg = "git_add", bg = "git_add", bold = true }
    }

    local git_delete = {
      provider = "git_delete",
      hl = { fg = "git_delete", bg = "git_delete", bold = true }
    }

    local git_change = {
      provider = "git_change",
      hl = { fg = "git_change", bg = "git_change", bold = true }
    }

    local error = {
      provider = "error",
      hl = { fg = "error", bg = "error", bold = true }
    }

    local warning = {
      provider = "warning",
      hl = { fg = "warning", bg = "warning", bold = true }
    }

    local info = {
      provider = "info",
      hl = { fg = "info", bg = "info", bold = true }
    }

    local hint = {
      provider = "hint",
      hl = { fg = "hint", bg = "hint", bold = true }
    }

    local ViMode = {
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
        mode_names = { -- change the strings if you like it vvvvverbose!
          n = "N",
          no = "N?",
          nov = "N?",
          noV = "N?",
          ["no\22"] = "N?",
          niI = "Ni",
          niR = "Nr",
          niV = "Nv",
          nt = "Nt",
          v = "V",
          vs = "Vs",
          V = "V_",
          Vs = "Vs",
          ["\22"] = "^V",
          ["\22s"] = "^V",
          s = "S",
          S = "S_",
          ["\19"] = "^S",
          i = "I",
          ic = "Ic",
          ix = "Ix",
          R = "R",
          Rc = "Rc",
          Rx = "Rx",
          Rv = "Rv",
          Rvc = "Rv",
          Rvx = "Rv",
          c = "C",
          cv = "Ex",
          r = "...",
          rm = "M",
          ["r?"] = "?",
          ["!"] = "!",
          t = "T",
        },
        mode_colors = {
          n = "variables" ,
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
        }
      },
      provider = function(self)
        return " %2("..self.mode.."%)"
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { fg = self.mode_colors[mode], bold = true, bg = "statusline_bg"}
      end,
      update = {
        "ModeChanged",
      },
    }

    local Git = {
      condition = conditions.is_git_repo,

      init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,

      hl = { fg = "orange" },


      {   -- git branch name
          provider = function(self)
              return " " .. self.status_dict.head
          end,
          hl = { bold = true }
      },
      -- You could handle delimiters, icons and counts similar to Diagnostics
      {
          condition = function(self)
              return self.has_changes
          end,
          provider = "("
      },
      {
          provider = function(self)
              local count = self.status_dict.added or 0
              return count > 0 and ("+" .. count)
          end,
          hl = { fg = "git_add" },
      },
      {
          provider = function(self)
              local count = self.status_dict.removed or 0
              return count > 0 and ("-" .. count)
          end,
          hl = { fg = "git_del" },
      },
      {
          provider = function(self)
              local count = self.status_dict.changed or 0
              return count > 0 and ("~" .. count)
          end,
          hl = { fg = "git_change" },
      },
      {
          condition = function(self)
              return self.has_changes
          end,
          provider = ")",
      },
    }


    require("heirline").setup({
      statusline = { Git, ViMode },
      winbar = { statusline_bg, statusline_fg, comments, statements, strings, functions, specials, types, operators, identifiers, numbers, variables, git_add, git_delete, git_change, error, warning, info, hint },
    })
  end
}
