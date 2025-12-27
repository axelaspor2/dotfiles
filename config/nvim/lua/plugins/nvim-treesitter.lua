return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      highlight = { enable = true },
      ensure_installed = { "typescript", "javascript", "lua" },
    })
    -- 基本のハイライト
    vim.api.nvim_set_hl(0, '@keyword', { fg = '#ff6b6b', bold = true })
    vim.api.nvim_set_hl(0, '@string', { fg = '#51cf66' })
    vim.api.nvim_set_hl(0, '@function', { fg = '#74c0fc', bold = true })
    vim.api.nvim_set_hl(0, '@variable', { fg = '#ffd43b' })
    vim.api.nvim_set_hl(0, '@type', { fg = '#ff8cc8' })
    vim.api.nvim_set_hl(0, '@comment', { fg = '#868e96', italic = true })
  end,

}
