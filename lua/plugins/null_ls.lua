return {

  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          -- null_ls.builtins.completion.spell,
          require("none-ls.diagnostics.eslint"),
          require("none-ls.diagnostics.flake8"),

          -- === Formatters ===
          null_ls.builtins.formatting.prettier, -- JS, TS, HTML, CSS, etc.
          null_ls.builtins.formatting.stylua,  -- Lua
          null_ls.builtins.formatting.black,   -- Python
          null_ls.builtins.formatting.shfmt,   -- Shell
          null_ls.builtins.formatting.clang_format, -- C/C++

          -- === Hover (valgfritt) ===
          null_ls.builtins.hover.printenv, -- Miljøvariabler
        },
        -- Valgfritt: integrer capabilities og on_attach fra lspconfig
        on_attach = function(client, bufnr)
          -- Eksempelvis formatter ved save:
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("Format", { clear = true }),
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })

      local h = require("null-ls.helpers")

      -- === Flake8 (Python) ===
      local flake8 = {
        name = "flake8",
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "python" },
        generator = null_ls.generator({
          command = "flake8",
          args = { "--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s", "-" },
          to_stdin = true,
          from_stderr = false,
          format = "raw",
          check_exit_code = function(code)
            return code <= 1
          end,
          on_output = function(line)
            local row, col, severity_code, code, message = line:match("^(%d+),(%d+),(%a),([^:]+): (.*)")
            if not row then
              return nil
            end

            local severity = ({
              E = 1, -- Error
              F = 1,
              W = 2, -- Warning
              C = 3, -- Info
              N = 3,
            })[severity_code] or 3

            return {
              row = tonumber(row),
              col = tonumber(col),
              end_col = tonumber(col) + 1,
              code = code,
              message = message,
              severity = severity,
            }
          end,
        }),
      }

      -- === Luacheck (Lua) ===
      local luacheck = {
        name = "luacheck",
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "lua" },
        generator = null_ls.generator({
          command = "luacheck",
          args = { "--formatter", "plain", "--codes", "--ranges", "--filename", "$FILENAME", "-" },
          to_stdin = true,
          format = "line",
          check_exit_code = function(code)
            return code <= 1
          end,
          on_output = function(line)
            local row, col, end_col, code, message = line:match("^(%d+):(%d+)-(%d+): %(([^)]+)%) (.+)")
            if not row then
              return nil
            end

            return {
              row = tonumber(row),
              col = tonumber(col),
              end_col = tonumber(end_col),
              code = code,
              message = message,
              severity = 2, -- Luacheck gir ikke nivå, så default warning
            }
          end,
        }),
      }

      -- === Shellcheck (Shell) ===
      local shellcheck = {
        name = "shellcheck",
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "sh", "bash", "zsh" },
        generator = null_ls.generator({
          command = "shellcheck",
          args = { "--format", "json1", "-" },
          to_stdin = true,
          format = "json",
          from_stderr = false,
          check_exit_code = function(code)
            return code <= 1
          end,
          on_output = function(params)
            local diagnostics = {}
            for _, result in ipairs(params.output.comments or {}) do
              table.insert(diagnostics, {
                row = result.line,
                col = result.column,
                end_col = result.endColumn,
                code = result.code,
                message = result.message,
                severity = ({
                  error = 1,
                  warning = 2,
                  info = 3,
                  style = 4,
                })[result.level] or 3,
              })
            end
            return diagnostics
          end,
        }),
      }

      -- === Stylelint (CSS/SCSS) ===
      local stylelint = {
        name = "stylelint",
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "css", "scss", "sass", "less" },
        generator = null_ls.generator({
          command = "stylelint",
          args = { "--formatter", "json", "--stdin", "--stdin-filename", "$FILENAME" },
          to_stdin = true,
          from_stderr = false,
          format = "json",
          check_exit_code = function(code)
            return code <= 2
          end,
          on_output = function(params)
            local diagnostics = {}
            local results = params.output[1]
            if not results or not results.warnings then
              return diagnostics
            end
            for _, warning in ipairs(results.warnings) do
              table.insert(diagnostics, {
                row = warning.line,
                col = warning.column,
                message = warning.text,
                code = warning.rule,
                severity = ({
                  error = 1,
                  warning = 2,
                })[warning.severity] or 2,
              })
            end
            return diagnostics
          end,
        }),
      }
    end,
  },

  {
    "nvimtools/none-ls-extras.nvim",
    dependencies = { "nvimtools/none-ls.nvim" },
  },
}
