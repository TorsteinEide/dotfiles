return {
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  config = function()
    require("lualine").setup({
      sections = {
        lualine_z = {
          {
            -- Show the currently connected server and its status
            require("opencode").statusline,
          },
        },
      },
    })
    require("snacks").setup({
      input = {
        enabled = true, -- Enhances Ask
      },
      picker = {
        enabled = true, -- Enhances Select
        win = {
          input = {
            keys = {
              ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
            },
          },
        },
        actions = {
          opencode_send = function(picker) ---@param picker snacks.Picker
            local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
              return item.file and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                or item.text
            end, picker:selected({ fallback = true }))

            require("opencode").prompt(table.concat(items, ", ") .. " ")
          end,
        },
      },
    })
    -- Configure blink.cmp to show completions in Ask from opencode.nvim's in-process LSP.
    -- Only applicable when using snacks.input.
    require("blink.cmp").setup({
      sources = {
        -- Either enable LSP (and optionally buffer) source globally
        default = { "lsp", "buffer" },
        -- Or only for Ask
        per_filetype = {
          opencode_ask = { "lsp", "buffer" },
        },
        -- Display buffer completions (if included above) when no LSP completions are available
        providers = { lsp = { fallbacks = {} } },
      },
    })
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any; goto definition on the type for details
    }

    vim.o.autoread = true -- Required for `vim.g.opencode_opts.events.reload`

    -- Recommended/example keymaps
    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask("@this: ")
    end, { desc = "Ask OpenCode…" })
    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      require("opencode").select()
    end, { desc = "Select OpenCode…" })

    vim.keymap.set({ "n", "x" }, "go", function()
      return require("opencode").operator("@this ")
    end, { desc = "Append range to OpenCode", expr = true })
    vim.keymap.set("n", "goo", function()
      return require("opencode").operator("@this ") .. "_"
    end, { desc = "Append line to OpenCode", expr = true })

    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "Scroll OpenCode up" })
    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "Scroll OpenCode down" })
  end,
}
