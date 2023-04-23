" vim-plug has to be downloaded to ~/.local/share/nvim/site/autoload/plug.vim
" https://github.com/junegunn/vim-plug
call plug#begin()

Plug 'andymass/vim-matchup'
Plug 'preservim/nerdtree'
Plug 'mawkler/modicator.nvim'

Plug 'tpope/vim-sleuth'

" does not work with rust at this moment:
" https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/9#issuecomment-1212862795
" Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
" Plug 'ray-x/lsp_signature.nvim'
" Plug 'j-hui/fidget.nvim'

call plug#end()

syntax on

" vim-matchup
let g:matchup_matchparen_offscreen = {'method': 'popup'}

" NERDTree
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

let g:NERDTreeShowHidden = 1

" quick fix window
function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction

nnoremap <silent> <Leader>q :call ToggleQuickFix()<CR>

" handle frequent typos
command! Q :q
command! W :w
command! Wq :wq

lua <<EOF
  -- fidget.vim
  -- require"fidget".setup{}
  -- lsp.signature.nvim
  -- require "lsp_signature".setup{}
  require("tmp_init")
EOF
