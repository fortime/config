set t_Co=256
set background=dark

" paper-color-scheme {{{
if !has('gui_running')
    let g:PaperColor_Theme_Options = {
    \        'theme': {
    \            'default': {
    \                'transparent_background': 1
    \            }
    \        }
    \    }
endif
" }}}

colorscheme PaperColor

set guifont=Hack\ 10
