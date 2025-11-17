local M = {}

M.apply = function()
	require("bufferline").setup({
		options = {
			indicator = {
				icon = " ",
				style = "icon",
			},

			buffer_close_icon = "󰅖 ",
			modified_icon = "● ",
			close_icon = " ",
			left_trunc_marker = " ",
			right_trunc_marker = " ",
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level)
				local icon = level:match("error") and " " or " "
				return " " .. icon .. count
			end,
			color_icons = false,
			show_buffer_icons = true,
			show_close_icon = true,
			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},
			separator_style = "slope",
			themable = true,

			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					highlight = "Directory",
					separator = true,
				},
			},

			groups = {
				items = {
					require("bufferline.groups").builtin.pinned:with({ icon = "" }),
					require("bufferline.groups").builtin.ungrouped,
				},
			},
		},
		highlights = {
			-- Aktiv buffer
			buffer_selected = {
				fg = "#f9fcf7",
				bg = "#2b2b2b",
				bold = true,
			},

			-- Inaktive buffere
			background = {
				fg = "#c7c7c7",
				bg = "#2b2b2b",
			},
			buffer_visible = {
				fg = "#c7c7c7",
				bg = "#2b2b2b",
			},

			-- Linja bak tabs
			fill = {
				fg = "#c7c7c7",
				bg = "#2b2b2b",
			},

			-- Tabs (når bufferline bruker “tab mode” internt)
			tab = {
				fg = "#c7c7c7",
				bg = "#2b2b2b",
			},
			tab_selected = {
				fg = "#f9fcf7",
				bg = "#2b2b2b",
				bold = true,
			},
			tab_close = {
				fg = "#c7c7c7",
				bg = "#2b2b2b",
			},

			-- Close-knapp
			close_button = {
				fg = "#c7c7c7",
				bg = "#2b2b2b",
			},
			close_button_visible = {
				fg = "#c7c7c7",
				bg = "#2b2b2b",
			},
			close_button_selected = {
				fg = "#f9fcf7",
				bg = "#2b2b2b",
			},

			-- Indicator (den lille markøren ved aktiv buffer)
			indicator_selected = {
				fg = "#f9fcf7",
				bg = "#2b2b2b",
			},
			indicator_visible = {
				fg = "#c7c7c7",
				bg = "#2b2b2b",
			},

			-- Separatorer
			separator = {
				fg = "#4b4b4b",
				bg = "#2b2b2b",
			},
			separator_visible = {
				fg = "#4b4b4b",
				bg = "#2b2b2b",
			},
			separator_selected = {
				fg = "#4b4b4b",
				bg = "#2b2b2b",
			},

			-- Diagnostics (LSP-symboler på tab)
			diagnostic = {
				fg = "#c7c7c7",
				bg = "#2b2b2b",
			},
			diagnostic_visible = {
				fg = "#c7c7c7",
				bg = "#2b2b2b",
			},
			diagnostic_selected = {
				fg = "#f9fcf7",
				bg = "#2b2b2b",
				bold = true,
			},
		},
	})
	vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "#4b4b4b", fg = "#4b4b4b" })
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#2b2b2b", fg = "#2b2b2b" })
	vim.api.nvim_set_hl(0, "TabLine", { bg = "#2b2b2b", fg = "#c7c7c7" })
  -- vim.api.nvim_set_hl(0, "BufferLineBackground", {bg = "#2b2b2b", fg="#2b2b2b"})
end

return M
