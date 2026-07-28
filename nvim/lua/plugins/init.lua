-- Place your plugin specs here.
-- Each file in this directory is automatically loaded.
-- Example:
--
-- return {
--   { "catppuccin/nvim", name = "catppuccin", opts = {} },
-- }
return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    },
  },
}

