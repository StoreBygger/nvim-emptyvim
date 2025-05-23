return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "c", "bash", "javascript", "toml", "css", "html", "json" },
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

  -- Selve LSP-oppsettet
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Bruker ts_ls i stedet for tsserver
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- tilpasset kode for ts_ls-serveren
        end,
        settings = {
          -- spesifikke innstillinger for ts_ls (TypeScript)
        },
      })

      -- Eksempel: Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {},
      })

      -- Python LSP (pyright)
      lspconfig.pyright.setup({
        capabilities = capabilities,
      })

      -- C LSP (clangd)
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })

      -- TOML LSP (taplo)
      lspconfig.taplo.setup({
        capabilities = capabilities,
      })

      -- JSON LSP (jsonls), kan brukes for konfigurasjonsfiler som .json
      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })

      -- YAML LSP (yaml)
      lspconfig.yamlls.setup({
        capabilities = capabilities,
      })

      lspconfig.html.setup({
        capabilities = capabilities,
      })

      lspconfig.cssls.setup({
        capabilities = capabilities,
      })
    end,
  },

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
