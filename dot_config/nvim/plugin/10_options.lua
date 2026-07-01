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
vim.opt.signcolumn = "number"
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
vim.opt.showmode = false
vim.opt.joinspaces = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.undodir = "/tmp/nvim/undo/"
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.wildmode = "longest:full,full"
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:append("followwrap")
vim.opt.background = "dark"
vim.opt.winborder = "single"

if vim.fn.executable("rg") then
	vim.opt.grepprg = "rg --no-heading --vimgrep --hidden --iglob !.git/"
end
