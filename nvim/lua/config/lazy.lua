require("lazy").setup({
  spec = {
    -- LazyVim and its default plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import custom plugins from lua/plugins/
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- always use latest git commits
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- auto-check for plugin updates
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
