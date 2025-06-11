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

set laststatus=2
set ruler
set cmdheight=2

set linespace=0
set wildmenu
set backspace=2

set foldenable
set foldmethod=indent
set completeopt+=popup
" SQLComplete use C-c to triger complete which is confliced with my mapping
let g:omni_sql_no_default_maps = 1

" no resizing for all windows after a ycm buffer view close
set noequalalways

" disable reindent while typing ':'
set indentkeys-=<:>

"nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" Map Ctrl-c to Esc
" {{{
ino <C-C> <Esc>
" }}}

" JumpToTheLineLastOpen {{{
autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif
" }}}

" LSP Mapping {{{
function! LspHelperSubCommands(arg_lead, cmd_line, cursor_pos)
    " a:arg_lead: The characters already typed for the current argument.
    " a:cmd_line: The entire command line.
    " a:cursor_pos: The cursor position in the command line.

    let l:args = split(a:cmd_line[0:a:cursor_pos] . 'n')
    if len(args) > 2
        return []
    endif

    let l:options = [
        \'GoToDefinition',
        \'GoToDeclaration',
        \'GoToImplementation',
        \'GoToReferences',
        \'GoToType',
        \'GoTo',
        \'FixIt',
        \'CallHierarchy',
        \'Rename',
        \'Toggle',
        \'Restart',
        \'Info',
    \]

    " Filter the list based on the characters already typed (a:arg_lead)
    let l:filtered_options = filter(l:options, 'v:val =~? "^" . a:arg_lead')

    " Return the filtered list
    return l:filtered_options
endfunction

nnoremap gdf :LspHelper GoToDefinition<CR>
nnoremap gdc :LspHelper GoToDeclaration<CR>
nnoremap gdi :LspHelper GoToImplementation<CR>
nnoremap gdr :LspHelper GoToReferences<CR>
nnoremap gtd :LspHelper GoToType<CR>
nnoremap gsc :LspHelper GoTo<CR>
nnoremap gfi :LspHelper FixIt<CR>
nnoremap gch :LspHelper CallHierarchy<CR>
nnoremap gli :LspHelper Info<CR>
" }}}

" NERDTree {{{
let g:NERDTreeWinSize = 20
let NERDTreeWinPos = "right"
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" }}}

" Tagbar {{{
let g:tagbar_width = 20
let g:tagbar_left = 1
" }}}

" {{{
let g:airline_theme = "badwolf"
let g:airline#extensions#tabline#enabled = 1
" }}}

" OpenCOrCppFileForCurrentHeader {{{
autocmd BufEnter *.h,*.hpp nnoremap gcc :call OpenCOrCppFileForCurrentHeader()<CR>
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
autocmd BufEnter *.cc,*.cpp,*.c nnoremap gch :call OpenHeaderFileForCurrentSource()<CR>
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
autocmd BufEnter *.js nnoremap ght :call OpenHtmlFileForCurrentJsFile()<CR>
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
autocmd BufEnter *.html nnoremap gjs :call OpenJsFileForCurrentHtmlFile()<CR>
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

" Edit indentkeys {{{
autocmd FileType yaml setlocal indentkeys-=0# indentkeys-=<:>
" }}}

" folding by indent for tex {{{
autocmd FileType tex setlocal foldmethod=indent
let g:tex_flavor='latex'
"}}}

" Autoformat {{{
let g:formatdef_prettier = '"prettier --stdin-filepath ".expand("%:p").(&textwidth ? " --print-width ".&textwidth : "")." --tab-width=".shiftwidth()'
let g:formatdef_scalafmt = "'scalafmt --stdin'"
let g:formatters_scala = ['scalafmt']
let g:formatdef_rustfmt = "'rustfmt --edition 2024'"
let g:formatters_rust = ['rustfmt']
let g:formatters_javascript = ['prettier']
let g:formatdef_cssfmt = "'prettier --parser css --tab-width 2 --stdin'"
let g:formatters_css = ['cssfmt']
let g:formatdef_htmlfmt = "'prettier --parser html --tab-width 2 --stdin'"
let g:formatters_html = ['htmlfmt']
let g:formatdef_xmlfmt = "'tidy -q -raw -xml --indent-spaces 4 --indent yes --indent-attributes yes --vertical-space yes --output-xml yes --wrap 0'"
let g:formatters_xml = ['xmlfmt']
let g:formatdef_jsonfmt = "'jq'"
let g:formatters_json = ['jsonfmt']
let g:formatters_python = ['black']
let g:formatdef_markdownfmt = "'prettier --parser markdown --stdin'"
let g:formatters_markdown = ['markdownfmt']
" To disable the fallback to vim's indent file, retabbing and removing trailing whitespace
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
" }}}

" vim-visual-increment {{{
set nrformats=alpha,octal,hex
" }}}

" ferret {{{
nmap gsw <Plug>(FerretAckWord)
nmap gso <Plug>(FerretAck)
" }}}

" fzf {{{
nmap <silent> gsg :GFiles --recurse-submodules<CR>
nmap <silent> gsh :GFiles -moc --directory<CR>
nmap <silent> gsr :Files<CR>

function! FerretBufferLineHandler(lines)
    if len(a:lines) < 2
        return
    endif

    execute split(a:lines[1], '\t')[0]
    normal! ^zvzz
    exec "normal \<Enter>"
endfunction

command! -bang -nargs=* FerretBLines call fzf#vim#buffer_lines('', {'sink*': function('FerretBufferLineHandler')}, <bang>0)
nmap ,s :copen \| FerretBLines<CR>
nmap ,f :BLines<CR>
" }}}

" No line number {{{
autocmd VimEnter * if (&filetype == '') | setlocal nonumber norelativenumber | else | setlocal number relativenumber | endif
autocmd BufReadPost * if (&filetype == '') | setlocal nonumber norelativenumber | else | setlocal number relativenumber | endif
" }}}

" init vimspector {{{
function! CustomPickProcess( ... ) abort
    let ps = 'ps aux'

    let line_selected = fzf#run( {
        \ 'source': ps,
        \ 'options': '--header-lines=1  '
        \          . '--prompt="Select Process: " '
        \ ,
        \
        \ } )[ 0 ]
    if empty( line_selected)
        return 0
    endif
    let pid = split( line_selected )[ 0 ]
    return str2nr( pid )
endfunction

let g:vimspector_custom_process_picker_func = 'CustomPickProcess'
let g:vimspector_install_gadgets = [ 'debugpy', 'CodeLLDB', 'vscode-java-debug' ]
let g:vimspector_base_dir=expand( '$HOME/.local/share/vimspector' )
let s:jdt_ls_debugger_port = 0
function! s:StartDebugging()
    if &filetype == "java"
        if s:jdt_ls_debugger_port <= 0
            " Get the DAP port
            let s:jdt_ls_debugger_port = youcompleteme#GetCommandResponse(
                \ 'ExecuteCommand',
                \ 'vscode.java.startDebugSession' )

            if s:jdt_ls_debugger_port == ''
                 echom "Unable to get DAP port - is JDT.LS initialized?"
                 let s:jdt_ls_debugger_port = 0
                 return
             endif
        endif

        call DebuggerMapping()

        " Start debugging with the DAP port
        call vimspector#LaunchWithSettings( { 'DAPPort': s:jdt_ls_debugger_port } )
    endif
endfunction

function! s:StopDebugging()
    call EditorMapping()

    VimspectorReset
endfunction
" }}}

" Fx mappings {{{
function! EditorMapping()
    nnoremap <F2> :set number! relativenumber!<CR>
    nnoremap <F3> :copen 10<CR>
    nnoremap <Leader><F3> :ccl<CR>
    nnoremap <F4> :echo expand('%')<CR>
    nnoremap <F5> :CustomizedAutoformat<CR>
    map <F6> :LspHelper Toggle<CR>
    map <Leader><F6> :LspHelper Restart<CR>
    nnoremap <F7> <Plug>VimspectorToggleBreakpoint
    map <silent> <F8> :NtatbToggleAll<CR>
    map <silent> <F9> :NtatbToggleTagbar<CR>
    map <silent> <F10> :NtatbToggleNERDTree<CR>

    nnoremap <silent> <buffer> <Leader><F5> :call <SID>StartDebugging()<CR>
endfunction

function! DebuggerMapping()
    " Set shortcut according to Human
    " Ctrl/Shift + Function Key doesn't work
    nnoremap <F2> <Plug>VimspectorDisassemble
    nnoremap <F3> <Plug>VimspectorRestart
    nnoremap <F4> <Plug>VimspectorStop
    nnoremap <F5> <Plug>VimspectorContinue
    nnoremap <F6> <Plug>VimspectorPause
    nnoremap <F7> <Plug>VimspectorToggleBreakpoint
    nnoremap <Leader><F7> <Plug>VimspectorAddFunctionBreakpoint
    nnoremap <F8> <Plug>VimspectorJumpToNextBreakpoint
    nnoremap <Leader><F8> <Plug>VimspectorJumpToPreviousBreakpoint
    nnoremap <F9> <Plug>VimspectorStepOver
    nnoremap <Leader><F9> <Plug>VimspectorRunToCursor
    nnoremap <F10> <Plug>VimspectorStepInto
    nnoremap <F11> <Plug>VimspectorStepOut

    nnoremap <silent> <buffer> <Leader><F5> :call <SID>StopDebugging()<CR>
endfunction
" }}}

call EditorMapping()
