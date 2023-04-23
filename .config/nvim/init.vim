" vim-plug has to be downloaded to ~/.local/share/nvim/site/autoload/plug.vim
" https://github.com/junegunn/vim-plug
call plug#begin()

Plug 'ciaranm/securemodelines'
Plug 'itchyny/lightline.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'andymass/vim-matchup'
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'mawkler/modicator.nvim'

Plug 'tpope/vim-sleuth'

Plug 'SmiteshP/nvim-navic'
" does not work with rust at this moment:
" https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/9#issuecomment-1212862795
" Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'ray-x/lsp_signature.nvim'
" Plug 'j-hui/fidget.nvim'

call plug#end()

syntax on

" vim-matchup
let g:matchup_matchparen_offscreen = {'method': 'popup'}

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
    \ 'inactive': {
    \   'left': [
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

" NERDTree
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

let g:NERDTreeShowHidden = 1

" FZF
let g:fzf_layout = { 'down': '25%' }
let g:fzf_preview_window = ['hidden,right,50%', 'ctrl-/']
nnoremap <silent> <C-p> :Files<CR>

if executable('rg')
  nnoremap <silent> <Leader>rg :Rg<CR>
  set grepprg=rg\ --no-heading\ --vimgrep\ --hidden\ --iglob\ !.git/
endif

" editorconfig-vim
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
au FileType gitcommit let b:EditorConfig_disable = 1

" https://github.com/kutsan/dotfiles/blob/24e22188ceec893be98ccf055d4d155d3ba512c6/.vim/autoload/kutsan/mappings/normal/terminal.vim
" https://github.com/NicksIdeaEngine/dotfiles/blob/6373d11aa9b893e4812b58e15ecc62a0b0b07971/.config/nvim/functions.vim#L139
" Toggle terminal buffer or create new one if there is none.
"nnoremap <silent> <leader>. :call nvim_open_win(bufnr('%'), v:true, {'relative': 'editor', 'anchor': 'NW', 'width': winwidth(0), 'height': 2*winheight(0)/5, 'row': 1, 'col': 0})<cr>:call TerminalToggle()<cr>
"tnoremap <silent> <esc> <c-\><c-n>:call TerminalToggle()<cr>:q<cr>

function! TerminalCreate() abort
  if !has('nvim')
    return v:false
  endif

  if !exists('g:terminal')
    let g:terminal = {
          \ 'opts': {},
          \ 'term': {
          \ 'loaded': v:null,
          \ 'bufferid': v:null
          \ },
          \ 'origin': {
          \ 'bufferid': v:null
          \ }
          \ }

    function! g:terminal.opts.on_exit(jobid, data, event) abort
      silent execute 'buffer' g:terminal.origin.bufferid
      silent execute 'bdelete!' g:terminal.term.bufferid

      let g:terminal.term.loaded = v:null
      let g:terminal.term.bufferid = v:null
      let g:terminal.origin.bufferid = v:null
    endfunction
  endif

  if g:terminal.term.loaded
    return v:false
  endif

  let g:terminal.origin.bufferid = bufnr('')

  enew
  call termopen(&shell, g:terminal.opts)

  let g:terminal.term.loaded = v:true
  let g:terminal.term.bufferid = bufnr('')
  startinsert
endfunction

function! TerminalToggle()
  if !has('nvim')
    return v:false
  endif

  " Create the terminal buffer.
  if !exists('g:terminal') || !g:terminal.term.loaded
    return TerminalCreate()
  endif

  " Go back to origin buffer if current buffer is terminal.
  if g:terminal.term.bufferid ==# bufnr('')
    silent execute 'buffer' g:terminal.origin.bufferid

    " Launch terminal buffer and start insert mode.
  else
    let g:terminal.origin.bufferid = bufnr('')

    silent execute 'buffer' g:terminal.term.bufferid
    startinsert
  endif
endfunction


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
  require "lsp_signature".setup{}

  -- https://github.com/neovim/nvim-lspconfig#suggested-configuration
  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<Leader>ce', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<Leader>cq', vim.diagnostic.setloclist, opts)

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

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    --vim.keymap.set('n', '<Leader>aw', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<Leader>rw', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<Leader>lw', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<Leader>td', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<Leader>cf', function() vim.lsp.buf.format { async = true } end, bufopts)

    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end

  require("tmp_init")
EOF
