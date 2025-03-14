return {
	{
		"savq/melange-nvim",
	},

	{
		"scottmckendry/cyberdream.nvim",
		config = function()
			require("cyberdream").setup({ transparent = true })
		end,
	},

	{
		"EdenEast/nightfox.nvim",
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme dayfox]]) -- Default colorscheme

			-- Autocommand to run terminal command after the colorscheme is loaded
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "dayfox", -- You can specify the exact colorscheme
				callback = function()
					-- Run the terminal command to change Kitty's background
					vim.fn.system("bash -c 'kitty @ set-colors background=#1e1e2e'")
				end,
			})
		end,
	},
	-- Required dependency
	{ "nvim-lua/plenary.nvim" },

	-- Command to toggle themes
	{
		"nvim-lua/plenary.nvim", -- Using plenary.nvim, but it's not strictly needed
		config = function()
			vim.api.nvim_create_user_command("ToggleTheme", function()
				local themes = { "melange", "cyberdream", "nightfox" }
				local current_theme = vim.g.colors_name
				local next_index = 1

				for i, theme in ipairs(themes) do
					if theme == current_theme then
						next_index = i % #themes + 1
						break
					end
				end

				vim.cmd("colorscheme " .. themes[next_index])
			end, {})
		end,
	},
}
