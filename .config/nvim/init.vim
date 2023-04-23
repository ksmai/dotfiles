" vim-plug has to be downloaded to ~/.local/share/nvim/site/autoload/plug.vim
" https://github.com/junegunn/vim-plug
call plug#begin()

Plug 'andymass/vim-matchup'
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
