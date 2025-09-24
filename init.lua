vim.opt.clipboard = "unnamedplus" -- use system keyboard for yank
vim.opt.nu = true                 -- set line numbers -- line numbers
vim.opt.relativenumber = true     -- use relative line numbers
-- set tab size to 2 spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.incsearch = true -- incremental search
vim.opt.termguicolors = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99 -- start ikke foldet
vim.opt.foldenable = true

vim.g.mapleader = " "

vim.g.loaded_netrw = 1 -- disable netrw at start of init.lua
vim.g.loaded_netrwPlugins = 1

require("config.lazy")
vim.cmd.colorscheme("onedark")

-- config zathura to nvim
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_progname = "nvr"
vim.g.vimtex_compiler_latexmk = {
  continuous = 1,
  callback = 1,
  options = { "-pdf", "-interaction=nonstopmode", "-synctex=1" },
}

--Telescope keymaps
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = " Telescope Find Files" })
vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>", { desc = " Telescope Live Grep" })
vim.keymap.set("n", "<leader>cs", ":Telescope colorscheme<CR>", { desc = "telescope ColorScheme" })

--NvimTree keymaps
vim.keymap.set("n", "<leader>tt", ":NvimTreeToggle<CR>", { desc = " Toggle NvimTree" })
vim.keymap.set("n", "<leader>tf", ":NvimTreeFocus<CR>", { desc = " Focus NvimTree" })
vim.keymap.set("n", "<leader>tr", ":NvimTreeRefresh<CR>", { desc = " refresh NvimTree " })

-- remove /<search> patterns
vim.keymap.set({ "n", "v" }, "<leader>n", ":nohlsearch<CR>", { desc = " remove search patterns" })

--BufferLine keymaps
vim.keymap.set("n", "<C-h>", ":BufferLineCyclePrev<CR>", { desc = " move to previous bufferline" })
vim.keymap.set("n", "<C-l>", ":BufferLineCycleNext<CR>", { desc = " move to next bufferline" })
vim.keymap.set("n", "<leader>bp", ":BufferLineTogglePin<CR>", { desc = " toggle bufferline pin" })
vim.keymap.set("n", "<leader>bl", ":BufferLineMoveNext<CR>", { desc = " Move tab left" })
vim.keymap.set("n", "<leader>bh", ":BufferLineMovePrev<CR>", { desc = " Move tab right" })
vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", { desc = " Pick tab to go to" })
vim.keymap.set("n", "<leader>bc", ":BufferLinePickClose<CR>", { desc = " Pick tab to close" })

-- save file keymaps
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = " save current file" })
vim.keymap.set("n", "<C-a>s", ":wa<CR>", { desc = " save all files" })
vim.keymap.set("n", "<C-a>q", ":qa<CR>", { desc = " quit all files" })

-- which key
vim.keymap.set("n", "<leader>wk", ":WhichKey<CR>", { desc = " Wich Key?" })

-- noice (notifications)
vim.keymap.set("n", "<C-n>p", ":Noice pick<CR>", { desc = "Noice pick - show history" })
vim.keymap.set("n", "<C-n>d", ":Noice dismiss<CR>", { desc = "Noice dismiss messages" })
vim.keymap.set("n", "<C-l>l", ":Noice last<CR>", { desc = "Noice show last message" })
vim.keymap.set("n", "<C-e>e", ":Noice errors<CR>", { desc = "Noice show errors" })

-- session manager
vim.keymap.set("n", "<leader>ss", ":SessionManager save_current_session<CR>", { desc = "Session Save Current" })
vim.keymap.set("n", "<leader>sll", ":SessionManager load_last_session<CR>", { desc = "Session Load Last" })
vim.keymap.set("n", "<leader>sls", ":SessionManager load_session<CR>", { desc = "Session Load Session" })
vim.keymap.set("n", "<leader>slg", ":SessionManager load_git_session<CR>", { desc = "Session Load Git Session" })
vim.keymap.set(
  "n",
  "<leader>slc",
  ":SessionManager load_current_dir_session<CR>",
  { desc = "Session Load CWD Session" }
)
vim.keymap.set("n", "<leader>sd", ":SessionManager delete_session<CR>", { desc = "Session Delete" })

vim.cmd([[
  autocmd VimEnter * lua require("dashboard.dashboardv1")
]])

-- trouble - debug
vim.keymap.set("n", "<leader>Tm", ":Trouble<CR>", { desc = " Trouble Meny" })
vim.keymap.set("n", "<leader>Td", ":Trouble diagnostics<CR>", { desc = "Trouble Diagnostics" })
