"To make vundle work
set nocompatible               " be iMproved
filetype off                   " required!
set rtp+=~/.vim/bundle/vundle
call vundle#begin()

" Bundle
" For vim plugins management
Plugin 'gmarik/vundle'
" For smart completion
Plugin 'Valloric/YouCompleteMe'
" For ycm listing diagnostic message
Plugin 'Valloric/ListToggle'
" For syntax diagnosting
Plugin 'scrooloose/syntastic'
" For auto completion for quotes, parens, brackets
Plugin 'Raimondi/delimitMate'
" For git integration
Plugin 'tpope/vim-fugitive'
" For exploring filesystem
Plugin 'scrooloose/nerdtree'
" For tag navigation
Plugin 'majutsushi/tagbar'
" For toggling nerdtree and tagbar
Plugin 'fortime/ntatb'
" For systemd syntax
Plugin 'Matt-Stevens/vim-systemd-syntax'
" For colorscheme
Plugin 'rainbow.zip'
" For css syntax bugs fix
Plugin 'hail2u/vim-css-syntax'
" For css3 syntax
Plugin 'hail2u/vim-css3-syntax'
" For cpp enhanced syntax highlight
Plugin 'octol/vim-cpp-enhanced-highlight'
" For cpp enhanced syntax highlight using libclang
"Plugin 'bbchung/clighter'
" Snip
Plugin 'SirVer/ultisnips'
" Snippets
Plugin 'honza/vim-snippets'
" Ansible yaml syntax
Plugin 'chase/vim-ansible-yaml'
" Use shell to run the conent of current buffer
Plugin 'JarrodCTaylor/vim-shell-executor'
" Pretty status line
Plugin 'bling/vim-airline'
" vim-airline-themes
Plugin 'vim-airline/vim-airline-themes'
" highlight trailing whitespaces
Plugin 'ntpeters/vim-better-whitespace'
" Git
"Plugin 'airblade/vim-gitgutter'
" JavaScript
Plugin 'pangloss/vim-javascript'

call vundle#end()

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

set guifont=WenQuanYi\ Micro\ Hei\ Mono\ 14

syntax on
filetype on
filetype plugin on
filetype indent on

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
set relativenumber

set history=1000
set nobackup
set noswapfile

set enc=utf-8
set fencs=utf-8,gb18030,gbk,gb2312,cp936,ucs-bom,shift-jis

set gdefault

set hlsearch
set incsearch

"set statusline=%{strftime(\"%d/%m/%y\ -\ %H:%M\")}\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ %F%m%r%h%w\ [POS=%l,%v][%p%%]
set t_Co=256
set laststatus=2
set ruler
set cmdheight=2

set linespace=0
set wildmenu
set backspace=2

set foldenable
set foldmethod=indent

" no resizing for all windows after a ycm buffer view close
set noequalalways

"nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" KeyMap {{{
nnoremap <F2> :set number! relativenumber!<CR>
nnoremap gj= :%!python -m json.tool<CR>
" }}}

" JumpToTheLineLastOpen {{{
autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif
" }}}

let g:loaded_zipPlugin = 1
let g:loaded_zip = 1

" YouCompleteMe {{{
let g:ycm_confirm_extra_conf = 0
let g:ycm_min_num_identifier_candidate_chars = 5
let g:ycm_error_symbol = 'E'
let g:ycm_warning_symbol = 'W'
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_max_diagnostics_to_display = 10
let g:ycm_key_invoke_completion = '<C-S-Space>'
let g:ycm_key_detailed_diagnostics = 'gdd'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_goto_buffer_command = 'horizontal-split'

" nnoremap gdf :YcmCompleter GoToDefinition<CR>
" nnoremap gdc :YcmCompleter GoToDeclaration<CR>
" nnoremap gsf :YcmCompleter GoTo<CR>
nnoremap gsc :YcmCompleter GoTo<CR>
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

" Ultisnip {{{
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" }}}

" {{{
let g:airline_theme = "badwolf"
let g:airline#extensions#tabline#enabled = 1
" }}}

" OpenCOrCppFileForCurrentHeader {{{
autocmd bufenter *.h,*.hpp nnoremap gcc :call OpenCOrCppFileForCurrentHeader()<CR>
function! OpenCOrCppFileForCurrentHeader()
    let extension = expand("%:e")
    if extension == "h"
        let target = expand("%<:p").".c"
        echo target
        if (filereadable(target))
            exec ":sp ". target
            return
        endif
    endif
    if extension == "hpp" || extension == "h"
        let target = expand("%<:p").".cpp"
        echo target
        if (filereadable(target))
            exec ":sp ". target
            return
        endif
        let target = expand("%<:p").".cc"
        echo target
        if (filereadable(target))
            exec ":sp ". target
            return
        endif
    endif
endfunction
" }}}
" OpenHeaderFileForCurrentSource {{{
autocmd bufenter *.cc,*.cpp,*.c nnoremap gch :call OpenHeaderFileForCurrentSource()<CR>
function! OpenHeaderFileForCurrentSource()
    let extension = expand("%:e")
    if extension != "cc" && extension != "cpp" && extension != "c"
        return
    endif
    let target = expand("%<:p").".h"
    echo target
    if (filereadable(target))
        exec ":sp ". target
        return
    endif
    if extension != "cc" && extension != "cpp"
        return
    endif
    let target = expand("%<:p").".hpp"
    echo target
    if (filereadable(target))
        exec ":sp ". target
        return
    endif
endfunction
" }}}

" OpenHtmlFileForCurrentJsFile {{{
autocmd bufenter *.js nnoremap ght :call OpenHtmlFileForCurrentJsFile()<CR>
function! OpenHtmlFileForCurrentJsFile()
    let extension = expand("%:e")
    if extension == "js"
        let target = expand("%<:p").".html"
        echo target
        if (filereadable(target))
            exec ":sp ". target
            return
        endif
    endif
endfunction
" }}}
" OpenJsFileForCurrentHtmlFile {{{
autocmd bufenter *.html nnoremap gjs :call OpenJsFileForCurrentHtmlFile()<CR>
function! OpenJsFileForCurrentHtmlFile()
    let extension = expand("%:e")
    if extension == "html"
        let target = expand("%<:p").".js"
        echo target
        if (filereadable(target))
            exec ":sp ". target
            return
        endif
    endif
endfunction
" }}}

" Reset tab stop for python {{{
" autocmd BufEnter *.py setlocal sw=2 ts=2 sts=2 expandtab
" }}}
"no expandtab for java {{{
    autocmd BufEnter *.java setlocal expandtab!
""}}}
