local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "solarized-osaka",
        news = {
          lazyvim = true,
          neovim = true,
        },
      },
    },

    { "HiPhish/rainbow-delimiters.nvim", dependencies = "nvim-treesitter/nvim-treesitter" },

    {
      "echasnovski/mini.indentscope",
      version = false, -- wait till new 0.7.0 release to put it back on semver
      event = "LazyFile",
      opts = {
        -- symbol = "▏",
        -- symbol = "│",
        -- symbol = "┃",
        symbol = "╎",
        options = { try_as_border = true },
      },
      init = function()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = {
            "alpha",
            "dashboard",
            "fzf",
            "help",
            "lazy",
            "lazyterm",
            "mason",
            "neo-tree",
            "notify",
            "toggleterm",
            "Trouble",
            "trouble",
          },
          callback = function()
            vim.b.miniindentscope_disable = true
          end,
        })
      end,
    },

    -- ╭─────────────────────────────────────────────────────────╮
    -- │ Neo-tree override                                       │
    -- ╰─────────────────────────────────────────────────────────╯
    {
      {
        "nvim-neo-tree/neo-tree.nvim",
        config = function()
          -- Set up key mappings for default and float styles
          vim.api.nvim_set_keymap("n", "<leader>E", ":Neotree reveal<CR>", { noremap = true, silent = true })
          vim.api.nvim_set_keymap("n", "<leader>e", ":Neotree float<CR>", { noremap = true, silent = true })
        end,
        opts = function(_, opts)
          local defaults = opts

          -- Modify the defaults to auto close when a file is opened
          defaults.event_handlers = {
            {
              event = "file_opened",
              handler = function()
                require("neo-tree").close_all()
              end,
            },
          }

          -- Set the position to float style
          -- defaults.window.position = "float"

          return defaults
        end,
      },
    },

    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
