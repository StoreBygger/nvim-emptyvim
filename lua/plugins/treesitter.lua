return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"python",
					"c",
					"bash",
					"javascript",
					"toml",
					"css",
					"html",
					"json",
					"latex",
					"bibtex",
					"cpp",
				},
				sync_install = false,
				auto_install = true,
				ignore_install = {},
				modules = {},
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				refactor = {
					highlight_current_scope = { enable = true },
					smart_rename = { enable = true, keymaps = { smart_rename = "grr" } },
					navigation = {
						enable = true,

						keymaps = {
							goto_definition = "gnd",
							list_definitions = "gnD",
							list_definitions_toc = "gO",
							goto_next_usage = "<a-*>",
							goto_previous_usage = "<a-#>",
						},
					},
				},
				pairs = {
					enable = true,
					highlight_pair_events = {},
					goto_right_end = false,
					fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')",
					keymaps = {
						goto_partner = "<leader>%",
						delete_balanced = "X",
					},
				},
			})
		end,
	},

	{
		"p00f/clangd_extensions.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		ft = { "c", "cpp", "objc", "objcpp" }, -- lazy-load på C/C++
		opts = {}, -- eller config = true
		config = function()
			require("clangd_extensions").setup({
				ast = {
					-- These are unicode, should be available in any font
					role_icons = {
						type = "🄣",
						declaration = "🄓",
						expression = "🄔",
						statement = ";",
						specifier = "🄢",
						["template argument"] = "🆃",
					},
					kind_icons = {
						Compound = "🄲",
						Recovery = "🅁",
						TranslationUnit = "🅄",
						PackExpansion = "🄿",
						TemplateTypeParm = "🅃",
						TemplateTemplateParm = "🅃",
						TemplateParamObject = "🅃",
					},
					--[[ These require codicons (https://github.com/microsoft/vscode-codicons)
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },

            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            }, ]]

					highlights = {
						detail = "Comment",
					},
				},
				memory_usage = {
					border = "none",
				},
				symbol_info = {
					border = "none",
				},
			})
		end,
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	{
		"HiPhish/rainbow-delimiters.nvim",
		lazy = false,
		config = function()
			---@type rainbow_delimiters.config
			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = "rainbow-delimiters.strategy.global",
					vim = "rainbow-delimiters.strategy.local",
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				priority = {
					[""] = 110,
					lua = 210,
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			}
		end,
	},

	{

		"nvim-treesitter/nvim-treesitter-refactor",
		lazy = false,
	},

	{
		"theHamsta/nvim-treesitter-pairs",
		lazy = false,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"theHamsta/nvim-treesitter-pairs",
		},
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
			})

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp_status, cmp = pcall(require, "cmp")

			if cmp_status then
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "xml", "javascript", "typescript", "tsx" },
		config = function()
			require("nvim-ts-autotag").setup({})
		end,
	},

	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = {
					"prettier",
					"stylua",
					"black",
					"shfmt",
					"clang_format",
					"flake8",
					"luacheck",
					"shellcheck",
					"stylelint",
				},
				automatic_installation = true,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		build = ":TSUpdate",
	},

	{
		"nvim-tree/nvim-web-devicons",
		name = "nvim-web-devicons",

		config = function() end,
	},

	-- Mason: automatisk installasjon av LSP
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = true,
		lazy = false,
	},

	-- LSP-integrasjon for Mason
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"ts_ls",
					"clangd",
					"taplo",
					"jsonls",
					"yamlls",
					"html",
					"cssls",
				}, -- legg til ønskede språkservere
				automatic_installation = true,
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			-- Felles capabilities (cmp)
			local caps = require("cmp_nvim_lsp").default_capabilities()

			-- CLANGD: egen capabilities (utf-16) + root_dir via vim.fs
			local clangd_caps = vim.deepcopy(caps)
			clangd_caps.offsetEncoding = { "utf-16" }

			local function root_dir_from(fname)
				local markers = {
					"compile_commands.json",
					"compile_flags.txt",
					"configure.ac",
					"configure.in",
					"config.h.in",
					"meson.build",
					"meson_options.txt",
					"build.ninja",
					"Makefile",
					".git",
				}

				-- Sørg for at vi har en faktisk filsti (ikke et tall)
				local start = (type(fname) == "number") and vim.api.nvim_buf_get_name(fname) or fname
				if not start or start == "" then
					start = vim.loop.cwd()
				end

				-- Bruk en KATALOG som start for søket
				local root_from = (vim.fn.isdirectory(start) == 1) and start or vim.fs.dirname(start)

				local found = vim.fs.find(markers, { upward = true, path = root_from })[1]
				return found and vim.fs.dirname(found) or root_from
			end

			-- ---- Definer konfiger ----
			-- clangd
			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
				capabilities = clangd_caps,
				root_dir = root_dir_from,
				-- evt. on_attach for nøkkelbindinger:
				on_attach = function(client, bufnr)
					vim.keymap.set("n", "<leader>ch", function()
						-- clangd off-spec method (switch source/header)
						client.request(
							"clangd.switchSourceHeader",
							{ uri = vim.uri_from_bufnr(bufnr) },
							function(err, res)
								if not err and res then
									vim.cmd.edit(vim.uri_to_fname(res))
								end
							end,
							bufnr
						)
					end, { buffer = bufnr, desc = "Switch Source/Header (C/C++)" })
				end,
			})

			-- TypeScript (nytt navn)
			vim.lsp.config("ts_ls", {
				capabilities = caps,
				settings = {},
			})

			-- Lua
			vim.lsp.config("lua_ls", { capabilities = caps })

			-- Python
			vim.lsp.config("pyright", { capabilities = caps })

			-- TOML
			vim.lsp.config("taplo", { capabilities = caps })

			-- JSON
			vim.lsp.config("jsonls", { capabilities = caps })

			-- YAML
			vim.lsp.config("yamlls", { capabilities = caps })

			-- HTML / CSS
			vim.lsp.config("html", { capabilities = caps })
			vim.lsp.config("cssls", { capabilities = caps })

			-- ---- Slå på konfigene ----
			vim.lsp.enable({
				"clangd",
				"ts_ls",
				"lua_ls",
				"pyright",
				"taplo",
				"jsonls",
				"yamlls",
				"html",
				"cssls",
			})
		end,
	},
	-- Selve LSP-oppsettet
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	lazy = false,
	-- 	opts = {
	-- 		servers = {
	-- 			-- Ensure mason installs the server
	-- 			clangd = {
	-- 				keys = {
	-- 					{ "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
	-- 				},
	-- 				root_markers = {
	-- 					"compile_commands.json",
	-- 					"compile_flags.txt",
	-- 					"configure.ac", -- AutoTools
	-- 					"Makefile",
	-- 					"configure.ac",
	-- 					"configure.in",
	-- 					"config.h.in",
	-- 					"meson.build",
	-- 					"meson_options.txt",
	-- 					"build.ninja",
	-- 					".git",
	-- 				},
	-- 				capabilities = {
	-- 					offsetEncoding = { "utf-16" },
	-- 				},
	-- 				cmd = {
	-- 					"clangd",
	-- 					"--background-index",
	-- 					"--clang-tidy",
	-- 					"--header-insertion=iwyu",
	-- 					"--completion-style=detailed",
	-- 					"--function-arg-placeholders",
	-- 					"--fallback-style=llvm",
	-- 				},
	-- 				init_options = {
	-- 					usePlaceholders = true,
	-- 					completeUnimported = true,
	-- 					clangdFileStatus = true,
	-- 				},
	-- 			},
	-- 		},
	-- 		setup = {
	-- 			clangd = function(_, opts)
	-- 				local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
	-- 				require("clangd_extensions").setup(
	-- 					vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts })
	-- 				)
	-- 				return false
	-- 			end,
	-- 		},
	-- 	},
	-- 	config = function()
	-- 		local lspconfig = vim.lsp.config()
	-- 		local capabilities = require("cmp_nvim_lsp").default_capabilities()
	--
	-- 		-- Bruker ts_ls i stedet for tsserver
	-- 		lspconfig.ts_ls.setup({
	-- 			capabilities = capabilities,
	-- 			on_attach = function(client, bufnr)
	-- 				-- tilpasset kode for ts_ls-serveren
	-- 			end,
	-- 			settings = {
	-- 				-- spesifikke innstillinger for ts_ls (TypeScript)
	-- 			},
	-- 		})
	--
	-- 		-- Eksempel: Lua
	-- 		lspconfig.lua_ls.setup({
	-- 			capabilities = capabilities,
	-- 			settings = {},
	-- 		})
	--
	-- 		-- Python LSP (pyright)
	-- 		lspconfig.pyright.setup({
	-- 			capabilities = capabilities,
	-- 		})
	--
	-- 		-- C LSP (clangd)
	-- 		lspconfig.clangd.setup({
	-- 			capabilities = capabilities,
	-- 		})
	--
	-- 		-- TOML LSP (taplo)
	-- 		lspconfig.taplo.setup({
	-- 			capabilities = capabilities,
	-- 		})
	--
	-- 		-- JSON LSP (jsonls), kan brukes for konfigurasjonsfiler som .json
	-- 		lspconfig.jsonls.setup({
	-- 			capabilities = capabilities,
	-- 		})
	--
	-- 		-- YAML LSP (yaml)
	-- 		lspconfig.yamlls.setup({
	-- 			capabilities = capabilities,
	-- 		})
	--
	-- 		lspconfig.html.setup({
	-- 			capabilities = capabilities,
	-- 		})
	--
	-- 		lspconfig.cssls.setup({
	-- 			capabilities = capabilities,
	-- 		})
	-- 	end,
	-- },

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"numToStr/Comment.nvim",
		opts = {},
	},
}
