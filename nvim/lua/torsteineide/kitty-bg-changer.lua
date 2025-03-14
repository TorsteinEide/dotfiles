local M = {}
local fn = vim.fn
local api = vim.api
M.original_color = nil

-- Get the original background color from Kitty
local get_kitty_background = function()
	if M.original_color == nil then
		fn.jobstart({ "kitty", "@", "get-colors" }, {
			on_stdout = function(_, d, _)
				for _, result in ipairs(d) do
					if string.match(result, "^background") then
						local color = vim.split(result, "%s+")[2]
						M.original_color = color
						break
					end
				end
			end,
			on_stderr = function(_, d, _)
				if #d > 1 then
					api.nvim_err_writeln(
						"Chameleon.nvim: Error getting background. Make sure kitty remote control is turned on."
					)
				end
			end,
		})
	end
end

-- Change Kitty's background color
local change_background = function(color, sync)
	local arg = 'background="' .. color .. '"'
	local command = "kitty @ set-colors " .. arg
	if not sync then
		fn.jobstart(command, {
			on_stderr = function(_, d, _)
				if #d > 1 then
					api.nvim_err_writeln(
						"Chameleon.nvim: Error changing background. Make sure kitty remote control is turned on."
					)
				end
			end,
		})
	else
		fn.system(command)
	end
end

-- Change background color to orange when Neovim is open
local set_bg_when_open = function()
	change_background("#f76f53") -- Change to orange when Neovim is open
end

-- Restore original background color when Neovim is closed
local restore_bg_when_closed = function()
	if M.original_color ~= nil then
		change_background(M.original_color, true)
	end
end

-- Setup the autocommands for detecting Neovim open/close
local setup_autocmds = function()
	local autocmd = api.nvim_create_autocmd
	local autogroup = api.nvim_create_augroup
	local bg_change = autogroup("BackgroundChange", { clear = true })

	-- When Neovim is opened, change the background to the orange color
	autocmd({ "VimEnter" }, {
		pattern = "*",
		callback = function()
			set_bg_when_open()
		end,
		group = bg_change,
	})

	-- When Neovim is closed (VimLeave), restore the original background
	autocmd({ "VimLeavePre", "VimSuspend" }, {
		callback = function()
			restore_bg_when_closed()
		end,
		group = autogroup("BackgroundRestore", { clear = true }),
	})
end

M.setup = function()
	get_kitty_background() -- Get the original background color
	setup_autocmds() -- Setup the autocommands for open/close events
end

return M
