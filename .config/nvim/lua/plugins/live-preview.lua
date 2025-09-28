return {
	"brianhuster/live-preview.nvim",
	cmd = { "LivePreview" },
	config = function()
		require("livepreview.config").set()
	end,
}
