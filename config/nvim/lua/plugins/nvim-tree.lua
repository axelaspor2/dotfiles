return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
  end,

  keys = {
    {mode = "n", "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "NvimTreeをトグルする"},
    {mode = "n", "<C-f>", "<cmd>NvimTreeFocus<CR>", desc = "NvimTreeにフォーカスする"},
  }


}
