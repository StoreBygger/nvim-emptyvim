local popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local files_len = 5
local lines_len = 5
local git_url = "https://github.com/StoreBygger"

vim.api.nvim_set_hl(0, "dashboardBG", { bg = "#260130", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "dashboardBorder", { fg = "#ffffff" })

local dashboard = popup({
  position = "50%",
  size = {
    width = "99%",
    height = "99%",
  },
  border = {
    style = "rounded",
    text = {
      -- top = " My custom dashboard",
      top_align = "center",
    },
  },

  win_options = {
    winhighlight = "Normal:dashboardBG,FloatBorder:dashboardBorder",
  },
})

dashboard:mount()
vim.api.nvim_set_current_win(dashboard.winid)

vim.schedule(function()
  local popup_width = vim.api.nvim_win_get_width(dashboard.winid)

  local function center_line(line)
    if not line then
      line = ""
    end

    local padding = math.floor((popup_width - #line) / 2)
    local remaining = popup_width - padding - #line

    return string.rep(" ", padding) .. line .. string.rep(" ", remaining)
  end

  local function equalize_line(line, w_len)
    local l_len = string.len(line)
    local d_len = math.abs(w_len - l_len)
    return "\t" .. line .. string.rep(" ", d_len)
  end

  local function format_recent_file(filepath)
    local filename = vim.fn.fnamemodify(filepath, ":t")
    local parent = vim.fn.fnamemodify(filepath, ":h:t")
    return string.format("%s/%s", parent, filename)
  end

  -- Hent files_len nylige filer
  local recent_files = {}
  for _, file in ipairs(vim.v.oldfiles) do
    if vim.fn.filereadable(file) == 1 then
      table.insert(recent_files, vim.fn.fnamemodify(file, ":~"))
    end
    if #recent_files == files_len then
      break
    end
  end

  local custom_header = require("custom.header_ascii")
  local header_length = #custom_header
  -- Bygg linjene for dashboard
  local lines = {
    "",
    "  [f]ind file\t\t󱏒 open [t]ree\t\t  [l]oad session\t\t󰩈 [q]uit",
    "",
    "Recent Files:",
    "",
  }

  local lines_after = {
    "",
    "Made by: StoreBygger",
    " [g]it",
  }

  local max_file_len = 0
  for i, v in ipairs(recent_files) do
    local line = format_recent_file(v)
    if string.len(line) > max_file_len then
      max_file_len = string.len(line)
    end
  end
  for i, v in ipairs(custom_header) do
    table.insert(lines, i, v)
  end

  for i, file in ipairs(recent_files) do
    table.insert(lines, string.format("[%d] %s", i, equalize_line(format_recent_file(file), max_file_len)))
  end

  for i, v in ipairs(lines_after) do
    table.insert(lines, v)
  end

  local total_line_height = vim.api.nvim_win_get_height(dashboard.winid)
  for i = 0, (total_line_height - #lines) do
    table.insert(lines, "")
  end
  -- Midtstill alle linjer
  for i, line in ipairs(lines) do
    lines[i] = center_line(line)
  end

  vim.api.nvim_set_hl(0, "dashboardTitle", {
    fg = "#f707ef",
    bold = true,
  })

  vim.api.nvim_set_hl(0, "dashboardText", {
    fg = "#05fc1a",
  })

  vim.api.nvim_set_hl(0, "dashboardFiles", {
    fg = "#05f4fc",
  })

  -- Vis i dashboard
  vim.api.nvim_buf_set_lines(dashboard.bufnr, 0, -1, false, lines)

  for i = 0, total_line_height do
    vim.api.nvim_buf_add_highlight(dashboard.bufnr, 0, "dashboardText", i, 0, -1)
  end

  for i = 0, header_length do
    vim.api.nvim_buf_add_highlight(dashboard.bufnr, 0, "dashboardTitle", i, 0, -1)
  end

  for i = (header_length + lines_len), lines_len + header_length + files_len do
    vim.api.nvim_buf_add_highlight(dashboard.bufnr, 0, "dashboardFiles", i, 0, -1)
  end

  -- Tastemapping
  vim.keymap.set("n", "f", function()
    dashboard:unmount()
    vim.cmd("Telescope find_files")
  end, { buffer = dashboard.bufnr, nowait = true, noremap = true, silent = true })

  vim.keymap.set("n", "t", function()
    dashboard:unmount()
    vim.cmd("NvimTreeOpen")
  end, { buffer = dashboard.bufnr, nowait = true, noremap = true, silent = true })

  vim.keymap.set("n", "q", function()
    dashboard:unmount()
    vim.cmd("qa")
  end, { buffer = dashboard.bufnr, nowait = true, noremap = true, silent = true })

  vim.keymap.set("n", "l", function()
    dashboard:unmount()
    vim.cmd("SessionManager load_session")
  end, { buffer = dashboard.bufnr, nowait = true, noremap = true, silent = true })

  vim.keymap.set("n", "g", function()
    vim.fn.jobstart({ "xdg-open", git_url }, { detach = true })
  end, { buffer = dashboard.bufnr, nowait = true, noremap = true, silent = true })

  -- Mapp tall-taster til filer
  for i, file in ipairs(recent_files) do
    local abs_path = vim.fn.expand(file)
    vim.keymap.set("n", tostring(i), function()
      dashboard:unmount()
      vim.cmd("edit " .. vim.fn.fnameescape(abs_path))
    end, { buffer = dashboard.bufnr, nowait = true, noremap = true, silent = true })
  end

  -- Lukk med q eller <Esc>
  dashboard:map("n", "<Esc>", function()
    dashboard:unmount()
  end, { noremap = true, silent = true })
  dashboard:map("n", "q", function()
    dashboard:unmount()
    vim.cmd("qa")
  end, { noremap = true, silent = true })
end)
