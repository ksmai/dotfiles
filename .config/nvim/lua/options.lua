vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fish doesn't play all that well with others
vim.opt.shell = "/bin/bash"

vim.opt.encoding = "utf-8"

-- TextEdit might fail if hidden is not set.
vim.opt.hidden = true

-- Some servers have issues with backup files, see #649.
vim.opt.backup = false
vim.opt.writebackup = false

-- Give more space for displaying messages.
vim.opt.cmdheight = 2

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 300

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
if vim.fn.has("patch-8.1.1564") == 1 then
	-- Recently vim can merge signcolumn and number column into one
	vim.opt.signcolumn = "number"
else
	vim.opt.signcolumn = "yes"
end

vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.wrap = true
vim.opt.dir = "/tmp/nvim/swap/"
-- vim.opt.scrolloff = 2
vim.opt.showmode = false
vim.opt.joinspaces = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.undodir = "/tmp/nvim/undo/"
-- Make diffing better: https://vimways.org/2018/the-power-of-diff/
vim.opt.diffopt:append("algorithm:patience")
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.wildmode = "longest:full,full"
vim.opt.diffopt:append("followwrap")

-- https://neovim.io/doc/user/provider.html#provider-clipboard
-- vim.opt.clipboard:append("unnamedplus")

if vim.fn.executable("rg") then
	vim.opt.grepprg = "rg --no-heading --vimgrep --hidden --iglob !.git/"
end
