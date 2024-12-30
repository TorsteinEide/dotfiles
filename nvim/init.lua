require("torse.plugins-setup")
require("torse.plugins.comment")
require("torse.core.options")
require("torse.core.keymaps")
require("torse.plugins.nvim-tree")
require("torse.core.colorscheme")
require("torse.plugins.lualine")
require("torse.plugins.telescope")
require("torse.plugins.nvim-cmp")
require("torse.plugins.lsp.mason")
require("torse.plugins.lsp.lspsaga")
require("torse.plugins.lsp.lspconfig")
require("torse.plugins.lsp.null-ls")
require("torse.plugins.autopairs")
require("torse.plugins.treesitter")
require("torse.plugins.gitsigns")
require('mason').setup()
vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])
