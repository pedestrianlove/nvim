return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		-- See Commands section for default commands if you want to lazy load on them
		config = function()
			require("CopilotChat").setup({})

			-- Enable CopilotChatModel selection using shortcut
			vim.api.nvim_set_keymap(
				"n",
				"<leader>sm",
				":CopilotChatModel<CR>",
				{ desc = "[S]earch Copilot Chat [M]odels", noremap = true }
			)

			-- Enable CopilotChatPrompts selection using shortcut
			vim.api.nvim_set_keymap(
				"n",
				"<leader>sp",
				":CopilotChatPrompts<CR>",
				{ desc = "[S]earch Copilot Chat [P]rompts", noremap = true }
			)
		end,
	},
}
