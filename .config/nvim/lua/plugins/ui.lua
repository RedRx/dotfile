return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },

  -- mini.animate override
  {
    "echasnovski/mini.animate",
    opts = function(_, opts)
      opts.scroll = {
        enable = false,
      }
    end,
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        -- mode = "tabs",
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        globalstatus = false,
        -- theme = "solarized_dark",
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        -- color = { fg = "#ffaa88", bg = "black", gui = "italic,bold" },
        -- color = { fg = "#ffaa88", gui = "bold" },
        color = { gui = "bold" },
      },
      sections = {
        lualine_a = {
          {
            "mode", -- Use the built-in mode component
            fmt = function(str)
              -- Custom format function to prepend the Vim icon to the mode text
              return " " .. str
            end,
          },
        },
      },
    },
  },

  -- filename
  {
    "b0o/incline.nvim",
    dependencies = { "craftzdog/solarized-osaka.nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("solarized-osaka.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
            InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      -- local logo = [[
      --   ██████╗ ███████╗ █████╗ ██████╗ ██╗   ██╗██████╗ ███████╗██╗   ██╗
      --   ██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝██╔══██╗██╔════╝██║   ██║
      --   ██████╔╝█████╗  ███████║██████╔╝ ╚████╔╝ ██║  ██║█████╗  ██║   ██║
      --   ██╔══██╗██╔══╝  ██╔══██║██╔══██╗  ╚██╔╝  ██║  ██║██╔══╝  ╚██╗ ██╔╝
      --   ██████╔╝███████╗██║  ██║██║  ██║   ██║   ██████╔╝███████╗ ╚████╔╝
      --   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚══════╝  ╚═══╝
      -- ]]
      local logo = [[ 
+=====================================================+
|     ____                        ____                |
|    | __ )  ___  __ _ _ __ _   _|  _ \  _____   __   |
|    |  _ \ / _ \/ _` | '__| | | | | | |/ _ \ \ / /   |
|    | |_) |  __/ (_| | |  | |_| | |_| |  __/\ V /    |
|    |____/ \___|\__,_|_|   \__, |____/ \___| \_/     |
|                           |___/                     |
+=====================================================+
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
}
