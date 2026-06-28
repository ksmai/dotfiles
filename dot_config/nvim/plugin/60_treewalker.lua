require("treewalker").setup({
	highlight = false,
})

vim.keymap.set(
	{ "n", "x", "o" },
	"<C-h>",
	"<cmd>Treewalker Left<cr>",
	{ desc = "Moves to the first ancestor node that's on a different line from the current node" }
)

vim.keymap.set(
	{ "n", "x", "o" },
	"<C-l>",
	"<cmd>Treewalker Right<cr>",
	{ desc = "Moves to the next node down that's indented further than the current node" }
)

vim.keymap.set(
	{ "n", "x", "o" },
	"<C-j>",
	"<cmd>Treewalker Down<cr>",
	{ desc = "Moves down to the next neighbor node" }
)

vim.keymap.set(
	{ "n", "x", "o" },
	"<C-k>",
	"<cmd>Treewalker Up<cr>",
	{ desc = "Moves up to the previous neighbor node" }
)

vim.keymap.set(
	"n",
	"]e",
	"<cmd>Treewalker SwapDown<cr>",
	{ desc = "Swaps the biggest node on the line downward in the document" }
)

vim.keymap.set(
	"n",
	"[e",
	"<cmd>Treewalker SwapUp<cr>",
	{ desc = "Swaps the highest node on the line upwards in the document" }
)

vim.keymap.set(
	"n",
	"<leader><",
	"<cmd>Treewalker SwapLeft<cr>",
	{ desc = "Swap the node under the cursor with its previous neighbor" }
)

vim.keymap.set(
	"n",
	"<leader>>",
	"<cmd>Treewalker SwapRight<cr>",
	{ desc = "Swap the node under the cursor with its next neighbor" }
)
