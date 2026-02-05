local M = {}

local cfg = {
  browser = "firefox",
  c = {
    cc = "gcc",
    cflags = "-Wall",
  },
  avr = {
    flash_target = "flash",
  },
}

local last_args = {}

local function term_run(cmd)
  require("toggleterm.terminal").Terminal:new({ cmd = cmd, close_on_exit = false, direction = "horizontal" }):toggle()
end

local function buf_text()
  return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
end

local function is_avr_c()
  local txt = buf_text()
  if txt:find("#%s*include%s*<%s*avr/") then
    return true
  end
  if txt:find("F_CPU") then
    return true
  end
  return false
end

local function file_info()
  local file = vim.fn.expand("%:p")
  local ext = vim.fn.expand("%:e")
  return file, ext
end

local function find_root()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    file = vim.loop.cwd()
  end
  local start = (vim.fn.isdirectory(file) == 1) and file or vim.fs.dirname(file)
  local found = vim.fs.find({ "Makefile", ".git" }, { upward = true, path = start })[1]
  if not found then
    return start
  end
  return (found:match("Makefile$") and vim.fs.dirname(found)) or found
end

local function promt_args(ft)
  local default = last_args[ft] or ""
  local ret
  vim.ui.input({ promt = ("Args for %s: "):format(ft), default = default }, function(inp)
    ret = inp or ""
  end)

  --vent til callback er kjørt
  local wait = 0
  while ret == nil and wait < 1000 do
    vim.wait(10)
    wait = wait + 10
  end

  last_args[ft] = ret or ""
  return last_args[ft]
end

local function get_args(mode, ft)
  local args = (mode == "compile_run_args") and prompt_args(ft) or (last_args[ft] or "")
  if args ~= "" then
    args = " " .. args
  end
  return args
end

local function avr_make(mode, root)
  if mode == "flash" then
    return ("make -C %q %s"):format(root, cfg.avr.flash_target)
  elseif mode == "compile" then
    return ("make -C %q"):format(root)
  elseif mode == "compile_run" or mode == "compile_run_args" then
    return ("make -C %q && make -C %q %s"):format(root, root, cfg.avr.flash_target)
  else -- run / run_args -> for AVR : flash
    return ("make -C %q %s"):format(root, cfg.avr.flash_target)
  end
end

local function c_make(mode, root)
  if mode == "compile" then
    return ("make -C %q"):format(root)
  elseif mode == "compile_run" or mode == "compile_run_args" then
    local exe = vim.fn.fnameescape(vim.fn.expand("%:r"))
    local args = get_args(mode, "c")

    return ("make -C %q && %q%s"):format(root, exe, args)
  else
    local exe_guess = vim.fn.expand("%:p:r")
    local args = get_args(mode, "c")

    return ("make -C %q && %q%s"):format(root, exe_guess, args)
  end
end

local function c_no_make(mode, root)
  local file = vim.fn.expand("%:p")
  local out = vim.fn.expand("%:p:r")
  local args = get_args(mode, "c")

  print(("Kjører c_no_make med fil %s, out: %s"):format(file, out))

  if mode == "compile" then
    return ("%s %s -o %s %s"):format(cfg.c.cc, file, out, cfg.c.cflags)
  else
    return ("%s %s -o %s %s && %s%s"):format(cfg.c.cc, file, out, cfg.c.cflags, out, args)
  end
end

-- Kommandobygging
local function build_run_cmd(mode)
  vim.cmd("wa")
  local file, ext = file_info()
  local root = find_root()

  if ext == "py" then
    local args = (mode == "run_args") and (" " .. promt_args("python")) or (last_args["python"] or "")
    return ("python3 %s%s"):format(file, args)
  elseif ext == "js" then
    local args = (mode == "run_args") and (" " .. promt_args("node")) or (last_args["node"] or "")
    return ("node %s%s"):format(file, args)
  elseif ext == "sh" then
    local args = (mode == "run_args") and (" " .. promt_args("bash")) or (last_args["bash"] or "")
    return ("bash %s%s"):format(file, args)
  elseif ext == "lua" then
    local args = (mode == "run_args") and (" " .. promt_args("lua")) or (last_args["lua"] or "")
    return ("lua %s%s").format(file, args)
  elseif ext == "html" then
    return ("%s :s"):format(cfg.browser, file)
  elseif ext == "c" then
    local has_make = vim.loop.fs_stat(root .. "/Makefile") ~= nil
    local avr = is_avr_c()

    if has_make then
      if avr then
        return avr_make(mode, root)
      else
        return c_make(mode, root)
      end
    else
      if avr then
        return nil, ("AVR projects must have Makefile, found no Makefile in %q"):format(root)
      else
        return c_no_make(mode, root)
      end
    end
  else
    return nil, ("Ukjent filtype: %s"):format(ext)
  end
end

function M.run(mode)
  local cmd, err = build_run_cmd(mode or "run")

  if not cmd then
    vim.notify(err or "Ingen kommando generert", vim.log.levels.WARN)
    return
  end

  term_run(cmd)
end

function M.setup()
  -- Presise variabler

  vim.keymap.set("n", "<F5>r", function()
    M.run("run")
  end, { desc = "Run" })
  vim.keymap.set("n", "<F5>a", function()
    M.run("run_args")
  end, { desc = "Run with args" })
  vim.keymap.set("n", "<F5>c", function()
    M.run("compile")
  end, { desc = "Compile" })
  vim.keymap.set("n", "<F5>R", function()
    M.run("compile_run")
  end, { desc = "Compile and run" })
  vim.keymap.set("n", "<F5>A", function()
    M.run("compile_run_args")
  end, { desc = "Compile and run with args" })
  vim.keymap.set("n", "<F5>F", function()
    M.run("flash")
  end, { desc = "AVR FLASH" })
end

return M
