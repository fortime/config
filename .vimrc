"To make vundle work
set nocompatible               " be iMproved
filetype off                   " required!
call vundle#rc()

" Bundle
" For vim plugins management
Bundle 'gmarik/vundle'
" For smart completion
Bundle 'Valloric/YouCompleteMe'
" For ycm listing diagnostic message
Bundle 'Valloric/ListToggle'
" For syntax diagnosting
Bundle 'scrooloose/syntastic'
" For auto completion for quotes, parens, brackets
Bundle 'Raimondi/delimitMate'
" For git integration
Bundle 'tpope/vim-fugitive'
" For exploring filesystem
Bundle 'scrooloose/nerdtree'
" For tag navigation
Bundle 'majutsushi/tagbar'
" For toggling nerdtree and tagbar 
Bundle 'fortime/ntatb'
" For systemd syntax
Bundle 'Matt-Stevens/vim-systemd-syntax'
" For colorscheme
Bundle 'rainbow.zip'
" For css syntax bugs fix
Bundle 'hail2u/vim-css-syntax'
" For css3 syntax
Bundle 'hail2u/vim-css3-syntax'
" For cpp enhanced syntax highlight
"Bundle 'octol/vim-cpp-enhanced-highlight'
" For cpp enhanced syntax highlight using libclang
Bundle 'bbchung/clighter'

colorscheme neon
highlight Folded ctermbg=black term=standout cterm=bold ctermfg=6 guifg=#40f0f0 guibg=#006090
highlight FoldColumn ctermbg=black term=standout cterm=bold ctermfg=6 guifg=#40c0ff guibg=#404040
highlight SignColumn ctermbg=yellow term=standout cterm=bold ctermfg=6 guifg=Cyan guibg=Grey
highlight Conceal ctermbg=4 ctermfg=7 guifg=LightGrey guibg=DarkGrey
highlight PmenuSel ctermbg=red ctermfg=0 guibg=DarkGrey
highlight PmenuSbar ctermbg=5 guibg=Grey
highlight PmenuThumb ctermbg=4 guibg=DarkGrey
highlight TabLine ctermbg=3 term=underline cterm=bold,underline ctermfg=7 gui=underline guibg=DarkGrey
highlight CursorColumn ctermbg=4 ctermfg=5 term=reverse guibg=Grey40

set nocompatible
set noeb
set confirm

set autoindent
set cindent
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

set number

set history=1000
set nobackup
set noswapfile

set enc=utf-8
set fencs=utf-8,gb18030,gbk,gb2312,cp936,ucs-bom,shift-jis

set gdefault

set hlsearch
set incsearch

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set laststatus=2
set ruler   
set cmdheight=2

syntax on
filetype on
filetype plugin on
filetype indent on

set linespace=0
set wildmenu
set backspace=2

set foldenable
set foldmethod=indent
"nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" KeyMap {{{
nnoremap <F2> :set number!<CR>
" }}}

" Autocmd {{{
autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif
" }}}

" YouCompleteMe {{{
let g:ycm_confirm_extra_conf = 0
let g:ycm_min_num_identifier_candidate_chars = 5
let g:ycm_error_symbol = 'E'
let g:ycm_warning_symbol = 'W'
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_max_diagnostics_to_display = 10
let g:ycm_key_invoke_completion = '<C-S-Space>'
let g:ycm_key_detailed_diagnostics = 'gdd'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

nnoremap gdf :YcmCompleter GoToDefinition<CR>
nnoremap gdc :YcmCompleter GoToDeclaration<CR>
nnoremap gsf :YcmCompleter GoToDefinition h<CR>
nnoremap gsc :YcmCompleter GoToDeclaration h<CR>
" }}}

" NERDTree {{{
let g:NERDTreeWinSize = 20
let NERDTreeWinPos=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" }}}

" Tagbar {{{
let g:tagbar_width = 20
let g:tagbar_left = 1

map <silent> <F8> :NtatbToggleAll<cr> 
map <silent> <F9> :NtatbToggleTagbar<cr> 
map <silent> <F10> :NtatbToggleNERDTree<cr> 
" }}}
