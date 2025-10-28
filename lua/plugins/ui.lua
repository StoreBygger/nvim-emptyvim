return {
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		lazy = false,
		priority = 1000,
		config = function() end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			--vim.cmd.colorscheme("tokyonight")
		end,
	},

	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
		lazy = false,
		priority = 1000,
		config = function() end,
	},

	{
		"navarasu/onedark.nvim",
		name = "onedark",
		style = "warm",
		lazy = false,
		priority = 1000,
		config = function()
			require("onedark").setup({
				style = "deep",
				transparent = false,
				term_colors = true,
				ending_tiles = false,
			})
			-- require("onedark").load()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		name = "lualine",
		lazy = false,
		priority = 1000,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = { theme = "onedark" },
			})
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",

		config = function()
			require("nvim-tree").setup({
				sort = {
					sorter = "name",
				},

				view = {
					width = 30,
				},

				renderer = {
					group_empty = true,
					add_trailing = true,
					special_files = {
						"README.md",
						"readme.md",
						"README",
						"readme",
					},
					hidden_display = "simple",
					highlight_git = "icon",
				},

				filters = {},

				git = {
					enable = true,
				},

				modified = {
					enable = true,
				},
			})
			local api = require("nvim-tree.api")

			vim.keymap.set(
				"n",
				"<leader>tcp",
				api.tree.change_root_to_parent,
				{ desc = " nvim-Tree Change root to Parent" }
			)
			vim.keymap.set("n", "<leader>tcn", api.tree.change_root_to_node, { desc = "nvim-Tree Change root to Node" })
		end,
	},

	{
		"akinsho/bufferline.nvim",
		lazy = false,
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					indicator = {
						icon = " ",
						style = "icon",
					},
					buffer_close_icon = "󰅖",
					modified_icon = "● ",
					close_icon = " ",
					left_trunc_marker = " ",
					right_trunc_marker = " ",
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level, diagnostics_dict, context)
						local icon = level:match("error") and " " or " "
						return " " .. icon .. count
					end,
					color_icons = true,
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
			})
		end,
	},

	{
		"MunifTanjim/nui.nvim",
	},

	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				background_colour = "#000000",
			})
		end,
	}, -- lazy.nvim

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
	},

	{
		"stevearc/dressing.nvim",
		opts = {},
	},

	{
		"Shatur/neovim-session-manager",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local config = require("session_manager.config")
			require("session_manager").setup({
				sessions_dir = vim.fn.expand("~/.config/nvim/sessions/"),
				autoload_mode = config.AutoloadMode.Disabled,
				autosave_last_session = true,
				autosave_only_in_session = false,
				autosave_ignore_not_normal = true,
				autosave_ignore_filetypes = {
					"gitcommit",
					"gitrebase",
				},
			})
		end,
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = { --[[ things you want to change go here]]
		},
		config = function()
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					else
						return 20
					end
				end,

				open_mapping = [[<C-\>]],
				start_in_insert = true,
				shade_terminals = true,
			})
		end,
	},
}
