return {
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					--{ name = "nvim_lua" },
					--{ name = "git" },
					{
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}, {
					{ name = "buffer" },
				}),
			})
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "git" },
				}, {
					{ name = "buffer" },
				}),
			})
			require("cmp_git").setup({})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},

	{
		"hrsh7th/cmp-nvim-lsp",
	},

	{
		"hrsh7th/cmp-buffer",
	},

	{
		"hrsh7th/cmp-path",
	},

	{
		"hrsh7th/cmp-cmdline",
	},

	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		run = "make_install_jsregexp",
	},

	{
		"saadparwaiz1/cmp_luasnip",
	},

	{
		"petertriho/cmp-git",
	},

	{
		"rafamadriz/friendly-snippets",
	},

	{
		"liamvdvyver/cmp-bibtex",
	},

	{
		"kdheepak/cmp-latex-symbols",
	},
}
