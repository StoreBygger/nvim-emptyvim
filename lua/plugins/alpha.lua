-- return {
--   {
--     "nvimdev/dashboard-nvim",
--     event = "VimEnter",
--     config = function()
--       local header_ascii = require("custom.header_ascii")
--
--       require("dashboard").setup({
--         theme = "doom",
--         config = {
--           header = header_ascii,
--
--           center = {
--             { icon = "󰱼", desc = "find file ", action = "Telescope find_files", key = "f" },
--             { icon = "󱏒", desc = "open tree", action = "NvimTreeToggle", key = "t" },
--           },
--
--           footer = {
--             "Footer text",
--             "Version 0.1",
--           },
--         },
--       })
--     end,
--   },
-- }
--
--

return {
	{
		"MunifTanjim/nui.nvim",
	},
}
