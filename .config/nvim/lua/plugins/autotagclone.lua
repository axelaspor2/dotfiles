return {
	"windwp/nvim-ts-autotag",
	lazy = false,
	config = function()
		require("nvim-ts-autotag").setup({
			opts = {
				enabled_close = true,
				enabled_rename = true,
				enabled_clone_on_slash = false
			}
		})
	end,

}
