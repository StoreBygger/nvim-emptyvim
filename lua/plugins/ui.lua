return {
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		lazy = false,
		priority = 1000,
		config = function() end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- fast i stedet for "auto"
				transparent_background = true,
				float = {
					transparent = true,
					solid = false,
				},
			})

			vim.cmd.colorscheme("catppuccin-mocha")
		end,
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
			local bufferline_setup = require("custom.bufferlinesetup")

			bufferline_setup.apply()

			vim.api.nvim_create_autocmd("colorscheme", {
				callback = function()
					bufferline_setup.apply()
				end,
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
	{
		"lmantw/themify.nvim",

		lazy = false,
		priority = 999,

		config = function()
			require("themify").setup({
				async = false,
				-- Enabling this would load the colorscheme asynchronously, which might improve your startup time.

				activity = false,
				-- Enabling this would track your colorscheme usage activity.

				{
					"folke/tokyonight.nvim",

					branch = "main",

					before = function(theme)
						-- The function run before the colorscheme is loaded.
						require("tokyonight").setup({
							transparent = true,
						})
					end,
					after = function(theme)
						-- The function run after the colorscheme is loaded.
					end,

					-- A colorscheme can have multiple themes, you can use the options below to only show the themes you want.
					-- whitelist = {},
					blacklist = {},
				},

				{
					"rebelot/kanagawa.nvim",

					before = function(theme)
						require("kanagawa").setup({
							transparent = true,
						})
					end,
				},

				{
					"bluz71/vim-moonfly-colors",
				},

				{
					"navarasu/onedark.nvim",
					style = "warm",

					before = function(theme)
						require("onedark").setup({
							style = "deep",
							transparent = true,
							term_colors = true,
							ending_tiles = true,
						})
					end,
				},
				{
					"catppuccin/nvim",
					name = "catppuccin",
					before = function(theme)
						require("catppuccin").setup({
							flavour = "auto",
							transparent_background = true,
							float = {
								transparent = true,
								solid = false,
							},
						})
					end,
				},

				-- The loader loads the colorscheme on startup, you can use the option below to replace it with a custom one.
				loader = function()
					-- og så faktisk last temaet
					vim.cmd.colorscheme("catppuccin-mocha") -- Custom loader logic...
				end,
			})
		end,
	},
}
