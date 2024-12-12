return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", function()
				vim.cmd("Git")
			end, { noremap = true, desc = "[G]it [S]tatus." })
			vim.keymap.set("n", "<leader>ga", function()
				vim.cmd("Git add .")
			end, { noremap = true, desc = "[G]it [A]dd." })
			vim.keymap.set("n", "<leader>gc", function()
				vim.cmd("Git commit")
			end, { noremap = true, desc = "[G]it [C]ommit." })
			vim.keymap.set("n", "<leader>gp", function()
				vim.cmd("Git push -u origin")
			end, { noremap = true, desc = "[G]it [P]ush." })

			-- Conflicts
			vim.keymap.set("n", "gu", function()
				vim.cmd("diffget //2")
			end, { desc = "Merge conflict [G]et left.(u)" })
			vim.keymap.set("n", "gh", function()
				vim.cmd("diffget //3")
			end, { desc = "Merge conflict [G]et right.(h)" })
		end,
	},
	{
		"tpope/vim-rhubarb",
		config = function()
			vim.g.rhubarb_github_host = "github.com"
		end,
	},
}
