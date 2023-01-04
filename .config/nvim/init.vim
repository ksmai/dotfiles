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
Plug 'mawkler/modicator.nvim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
" does not work with rust at this moment:
" https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/9#issuecomment-1212862795
" Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'ray-x/lsp_signature.nvim'
Plug 'j-hui/fidget.nvim'

Plug 'rust-lang/rust.vim'

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

" modicator.vim
set termguicolors
set cursorline

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
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, guifg)
  exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg=none ctermfg=White guibg=#181818 guifg=#'. a:guifg
  exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

let s:nerd_tree_code_color = g:base16_gui09
call NERDTreeHighlightFile('js', s:nerd_tree_code_color)
call NERDTreeHighlightFile('jsx', s:nerd_tree_code_color)
call NERDTreeHighlightFile('ts', s:nerd_tree_code_color)
call NERDTreeHighlightFile('tsx', s:nerd_tree_code_color)
call NERDTreeHighlightFile('py', s:nerd_tree_code_color)
call NERDTreeHighlightFile('rs', s:nerd_tree_code_color)
call NERDTreeHighlightFile('jade', s:nerd_tree_code_color)
call NERDTreeHighlightFile('pug', s:nerd_tree_code_color)
call NERDTreeHighlightFile('html', s:nerd_tree_code_color)
call NERDTreeHighlightFile('css', s:nerd_tree_code_color)

let s:nerd_tree_config_color = g:base16_gui0B
call NERDTreeHighlightFile('yml', s:nerd_tree_config_color)
call NERDTreeHighlightFile('yaml', s:nerd_tree_config_color)
call NERDTreeHighlightFile('json', s:nerd_tree_config_color)
call NERDTreeHighlightFile('toml', s:nerd_tree_config_color)
call NERDTreeHighlightFile('Dockerfile', s:nerd_tree_config_color)

let s:nerd_tree_hidden_color = g:base16_gui03
call NERDTreeHighlightFile('ds_store', s:nerd_tree_hidden_color)
call NERDTreeHighlightFile('gitconfig', s:nerd_tree_hidden_color)
call NERDTreeHighlightFile('gitignore', s:nerd_tree_hidden_color)
call NERDTreeHighlightFile('bashrc', s:nerd_tree_hidden_color)
call NERDTreeHighlightFile('bashprofile', s:nerd_tree_hidden_color)
call NERDTreeHighlightFile('lock', s:nerd_tree_hidden_color)
call NERDTreeHighlightFile('env', s:nerd_tree_hidden_color)
call NERDTreeHighlightFile('dockerignore', s:nerd_tree_hidden_color)
call NERDTreeHighlightFile('pyc', s:nerd_tree_hidden_color)

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
  nnoremap <silent> <C-g> :Rg<CR>
  set grepprg=rg\ --no-heading\ --vimgrep\ --hidden\ --iglob\ !.git/
endif

" spellchecking
augroup setSpelling
  autocmd!
  autocmd FileType gitcommit setlocal spell spelllang=en_us
  autocmd FileType markdown setlocal spell spelllang=en_us
augroup END

" vim-better-whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

" eslint
autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll

" fugitive
nnoremap <silent> <Leader>gs :Git<CR><C-w>_
nnoremap <silent> <Leader>gd :Gvdiffsplit<CR>
nnoremap <silent> <Leader>gl :0Gclog<CR>
vnoremap <silent> <Leader>gl :Gclog<CR>

" editorconfig-vim
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
au FileType gitcommit let b:EditorConfig_disable = 1

" rust.vim
let g:rustfmt_autosave = 1

" https://github.com/kutsan/dotfiles/blob/24e22188ceec893be98ccf055d4d155d3ba512c6/.vim/autoload/kutsan/mappings/normal/terminal.vim
" https://github.com/NicksIdeaEngine/dotfiles/blob/6373d11aa9b893e4812b58e15ecc62a0b0b07971/.config/nvim/functions.vim#L139
" Toggle terminal buffer or create new one if there is none.
nnoremap <silent> <leader>. :call nvim_open_win(bufnr('%'), v:true, {'relative': 'editor', 'anchor': 'NW', 'width': winwidth(0), 'height': 2*winheight(0)/5, 'row': 1, 'col': 0})<cr>:call TerminalToggle()<cr>
tnoremap <silent> <leader>. <c-\><c-n>:call TerminalToggle()<cr>:q<cr>

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
set pumheight=9

" https://neovim.io/doc/user/provider.html#provider-clipboard
"set clipboard+=unnamedplus
vnoremap <Leader>y "+y
vnoremap <Leader>Y "+Y
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P
nnoremap <Leader>y "+y
nnoremap <Leader>Y "+Y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

" quick save
nnoremap <Leader>w :w<CR>

" quick fix window
function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction

nnoremap <silent> <Leader>q :call ToggleQuickFix()<CR>

" very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sv/

" handle frequent typos
command! Q :q
command! W :w
command! Wq :wq

lua << EOF
-- fidget.vim
require"fidget".setup{}
-- lsp.signature.nvim
require "lsp_signature".setup{}
EOF



" lsp. nvim-lspconfig nvim-cmp
set completeopt=menu,menuone,noselect

lua <<EOF
  -- Set up nvim-cmp.
  -- Super-Tab like mapping
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end

  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      -- <Esc>['<C-b>'] = cmp.mapping.scroll_docs(-4),
      -- <Esc>['<C-f>'] = cmp.mapping.scroll_docs(4),
      -- <Esc>['<C-Space>'] = cmp.mapping.complete(),
      -- <Esc>['<C-e>'] = cmp.mapping.abort(),
      ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

      -- ["<Tab>"] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_next_item()
      --   elseif vim.fn["vsnip#available"](1) == 1 then
      --     feedkey("<Plug>(vsnip-expand-or-jump)", "")
      --   elseif has_words_before() then
      --     cmp.complete()
      --   else
      --     fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      --   end
      -- end, { "i", "s" }),

      -- ["<S-Tab>"] = cmp.mapping(function()
      --   if cmp.visible() then
      --     cmp.select_prev_item()
      --   elseif vim.fn["vsnip#jumpable"](-1) == 1 then
      --     feedkey("<Plug>(vsnip-jump-prev)", "")
      --   end
      -- end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'nvim_lsp_signature_help' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
      { name = 'path' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- https://github.com/neovim/nvim-lspconfig#suggested-configuration
  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<Leader>ce', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<Leader>cq', vim.diagnostic.setloclist, opts)

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
    vim.keymap.set('n', '<Leader>aw', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<Leader>rw', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<Leader>lw', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<Leader>td', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<Leader>cf', function() vim.lsp.buf.format { async = true } end, bufopts)
  end

  local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  }

  -- Set up lspconfig.
  local lspconfig = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- rust-analyzer
  lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    ["rust-analyzer"] = {
        checkOnSave = {
            command = "clippy",
        },
    },
  }

  -- pylsp
  lspconfig.pylsp.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    pylsp = {
    },
  }

  -- tsserver
  lspconfig.tsserver.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    tsserver = {
    },
  }

  --eslint
  lspconfig.eslint.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    eslint = {
    },
  }
EOF
