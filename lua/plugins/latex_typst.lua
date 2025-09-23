return {
	{
		"chomosuke/typst-preview.nvim",
		lazy = false,
		version = "1.*",
		opts = {},
	},
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_latexmk = {}
		end,
	},
	{
		"mfussenegger/nvim-lint",
		ft = { "tex", "plaintex" },
		config = function()
			require("lint").linters_by_ft = { tex = { "chktex" }, plaintex = { "chktex" } }
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = { tex = { "latexindent" }, plaintex = { "latexindent" } },
			format_on_save = { lsp_fallback = true, timeout_ms = 2000 },
		},
	},
}
