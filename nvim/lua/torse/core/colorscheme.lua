local status, _ = pcall(vim.cmd, "colorscheme NeoSolarized")
if not status then
	print("Colorscheme not found!")
	return
end
