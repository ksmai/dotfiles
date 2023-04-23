" vim-plug has to be downloaded to ~/.local/share/nvim/site/autoload/plug.vim
" https://github.com/junegunn/vim-plug
call plug#begin()

Plug 'andymass/vim-matchup'
Plug 'preservim/nerdtree'
Plug 'mawkler/modicator.nvim'

Plug 'tpope/vim-sleuth'

Plug 'SmiteshP/nvim-navic'
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

set winbar+=%{%v:lua.require'nvim-navic'.get_location()%}

lua <<EOF
  -- fidget.vim
  -- require"fidget".setup{}
  -- lsp.signature.nvim
  -- require "lsp_signature".setup{}


  local navic = require("nvim-navic")

  navic.setup {
    icons = {
        File          = "",
        Module        = "",
        Namespace     = "",
        Package       = "",
        Class         = "",
        Method        = "",
        Property      = "",
        Field         = "",
        Constructor   = "",
        Enum          = "",
        Interface     = "",
        Function      = "",
        Variable      = "",
        Constant      = "",
        String        = "",
        Number        = "",
        Boolean       = "",
        Array         = "",
        Object        = "",
        Key           = "",
        Null          = "",
        EnumMember    = "",
        Struct        = "",
        Event         = "",
        Operator      = "",
        TypeParameter = "",
    },
  }

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end

  require("tmp_init")
EOF
