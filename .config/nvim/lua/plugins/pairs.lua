return {
	"echasnovski/mini.pairs",
	event = { "BufReadPost", "BufNewFile" },
	config = function(_, opts)
		require("mini.pairs").setup(opts)
	end,
}
