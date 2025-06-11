" For auto completion for quotes, parens, brackets
Plug 'Raimondi/delimitMate'
" For git integration
Plug 'tpope/vim-fugitive'
" For exploring filesystem
Plug 'scrooloose/nerdtree'
" For tag navigation
Plug 'majutsushi/tagbar'
" For toggling nerdtree and tagbar
Plug 'fortime/ntatb'
" Snip
Plug 'SirVer/ultisnips'
" Snippets
Plug 'honza/vim-snippets'
" Pretty status line
Plug 'bling/vim-airline'
" vim-airline-themes
Plug 'vim-airline/vim-airline-themes'
" highlight trailing whitespaces
Plug 'ntpeters/vim-better-whitespace'
" Visual Increment
Plug 'triglav/vim-visual-increment'
" Autoformat
Plug 'Chiel92/vim-autoformat'
" EasyMotion
Plug 'easymotion/vim-easymotion'
" Enhanced multi-file search
Plug 'wincent/ferret'
" Basic fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Enhanced fzf
Plug 'junegunn/fzf.vim'
" complementary pairs of mappings
Plug 'tpope/vim-unimpaired'
" debugger plugin
Plug 'puremourning/vimspector'
" Aligning Text
Plug 'godlygeek/tabular'

function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

function! FcitxRemoteWontPanic()
    " fcitx5-remote will panic when it can't chat to dbus
    if !executable('fcitx5-remote')
        return 1
    endif
    if !empty($DBUS_SESSION_BUS_ADDRESS)
        let l:bus_path = substitute($DBUS_SESSION_BUS_ADDRESS, "unix:path=", "", "")
        return !empty(glob(l:bus_path))
    endif
    if !empty($XDG_RUNTIME_DIR)
        return !empty(glob($XDG_RUNTIME_DIR + "/bus"))
    endif
    return 0
endfunction

" switch to the default im when leaving buffer
Plug 'rlue/vim-barbaric', Cond(FcitxRemoteWontPanic())
