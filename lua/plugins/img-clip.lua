return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		dir_path = "assets", ---@type string | fun(): string
		extension = "png", ---@type string | fun(): string
	},
	keys = {
		-- suggested keymap
		{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},
}
