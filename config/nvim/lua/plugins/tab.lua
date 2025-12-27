return {
	'akinsho/bufferline.nvim', 
	version = "*", 
	dependencies = 'nvim-tree/nvim-web-devicons',
	lazy = false,
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup{}
	end,
	keys = {
	  {mode = "n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab"},
	  {mode = "n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab"},
	}
}

