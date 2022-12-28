" Fish doesn't play all that well with others
set shell=/bin/bash
let mapleader = "\<Space>"

" vim-plug has to be downloaded to ~/.local/share/nvim/site/autoload/plug.vim
" https://github.com/junegunn/vim-plug
call plug#begin()

Plug 'chriskempson/base16-vim'
Plug 'ciaranm/securemodelines'
Plug 'itchyny/lightline.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'andymass/vim-matchup'
Plug 'terryma/vim-expand-region'
Plug 'ntpeters/vim-better-whitespace'
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'machakann/vim-highlightedyank'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'ray-x/lsp_signature.nvim'

call plug#end()

syntax on
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" base16
if exists('$BASE16_THEME') && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
    let base16colorspace=256
    colorscheme base16-$BASE16_THEME
endif

" lightline.vim
let g:lightline = {
    \ 'active': {
    \   'left': [
    \     [ 'mode', 'paste' ],
    \     [ 'fugitive', 'readonly', 'filename', 'modified' ],
    \   ],
    \   'right': [
    \     [ 'lineinfo' ],
    \     [ 'percent' ],
    \     [ 'fileformat', 'fileencoding', 'filetype' ],
    \   ],
    \ },
    \ 'component_function': {
    \   'fugitive': 'FugitiveStatusline',
    \ } }

" vim-expand-region
vnoremap v <Plug>(expand_region_expand)
vnoremap <C-v> <Plug>(expand_region_shrink)

let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :0,
      \ 'a"'  :0,
      \ 'i''' :0,
      \ 'a''' :0,
      \ 'i]'  :1,
      \ 'a]'  :0,
      \ 'ib'  :1,
      \ 'ab'  :1,
      \ 'iB'  :1,
      \ 'aB'  :1,
      \ 'ip'  :0,
      \ 'i%'  :0,
      \ 'a%'  :0,
      \ }

" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('pug', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('yaml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('ts', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('gitconfig', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('bashrc', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('bashprofile', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('Dockerfile', 'Gray', 'none', '#686868', '#151515')

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

let g:NERDTreeShowHidden = 1

" FZF
nnoremap <silent> <C-p> :execute system('git rev-parse --is-inside-work-tree') =~ 'true' ? 'GFiles --cached --others --exclude-standard' : 'Files'<CR>

" spellchecking
augroup setSpelling
  autocmd!
  autocmd FileType gitcommit setlocal spell spelllang=en_us
  autocmd FileType markdown setlocal spell spelllang=en_us
augroup END

" vim-better-whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

" fugitive
nnoremap <Leader>gs :Git<CR><C-w>_

" editorconfig-vim
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
au FileType gitcommit let b:EditorConfig_disable = 1

" miscellaneous
set mouse=a
set incsearch
set ignorecase
set smartcase
set number
set relativenumber
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set wrap
set dir=/tmp/nvim/swap/
" set scrolloff=2
set noshowmode
set nojoinspaces
set splitright
set splitbelow
set undofile
set undodir=/tmp/nvim/undo/
" Make diffing better: https://vimways.org/2018/the-power-of-diff/
set diffopt+=algorithm:patience
set showcmd
set laststatus=2

" https://neovim.io/doc/user/provider.html#provider-clipboard
"set clipboard+=unnamedplus
vnoremap <Leader>y "+y
vnoremap <Leader>Y "+Y
vnoremap <Leader>d "+d
vnoremap <Leader>D "+D
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P
nnoremap <Leader>y "+y
nnoremap <Leader>Y "+Y
nnoremap <Leader>d "+d
nnoremap <Leader>D "+D
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

" quick save
nnoremap <leader>w :w<CR>

" very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sv/

" handle frequent typos
command! Q :q
command! W :w
command! Wq :wq
