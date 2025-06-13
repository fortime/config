" editorconfig {{{
" make editorconfig work with fugitive and skip any remote files over ssh
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
" }}}

" YouCompleteMe {{{
let g:ycm_confirm_extra_conf = 0
let g:ycm_min_num_identifier_candidate_chars = 5
let g:ycm_error_symbol = 'E'
let g:ycm_warning_symbol = 'W'
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_max_diagnostics_to_display = 30
let g:ycm_key_invoke_completion = '<C-S-Space>'
let g:ycm_key_detailed_diagnostics = 'gdd'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
" conflicted with ScrollPopup keymapping
let g:ycm_key_list_stop_completion = []
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
"let g:ycm_goto_buffer_command = 'horizontal-split'
let g:ycm_goto_buffer_command = 'same-buffer'
" reuse workspace
let g:ycm_java_jdtls_use_clean_workspace = 0
" unlimited candidate
let g:ycm_max_num_candidates = 0
let g:ycm_max_num_candidates_to_detail = 10
" show completion in comment
let g:ycm_complete_in_comments = 1
"let g:ycm_log_level = 'debug'
" use YcmDiags to populate and open the list
let g:ycm_always_populate_location_list = 0

nnoremap grf :YcmCompleter OpenProject .<CR>
nnoremap gll :YcmToggleLogs<CR>

function! ToggleYcm()
    if g:ycm_auto_trigger == 0
        let g:ycm_auto_trigger = 1
    else
        let g:ycm_auto_trigger = 0
    endif
endfunction

function! LspHelper(...)
    let l:sub_command = a:000[0]
    echo l:sub_command
    if l:sub_command == 'GoToDefinition'
        YcmCompleter GoToDefinition
    elseif l:sub_command == 'GoToDeclaration'
        YcmCompleter GoToDeclaration
    elseif l:sub_command == 'GoToImplementation'
        YcmCompleter GoToImplementation
    elseif l:sub_command == 'GoToReferences'
        YcmCompleter GoToReferences
    elseif l:sub_command == 'GoToType'
        YcmCompleter GoToType
    elseif l:sub_command == 'GoTo'
        YcmCompleter GoTo
    elseif l:sub_command == 'FixIt'
        YcmCompleter FixIt
    elseif l:sub_command == 'CallHierarchy'
        execute "normal \<Plug>(YCMCallHierarchy)"
    elseif l:sub_command == 'Rename'
        YcmCompleter RefactorRename a:000[1]
    elseif l:sub_command == 'Toggle'
        if g:ycm_auto_trigger == 0
            let g:ycm_auto_trigger = 1
        else
            let g:ycm_auto_trigger = 0
        endif
    elseif l:sub_command == 'Restart'
        YcmCompleter RestartServer
    elseif l:sub_command == 'Info'
        YcmDebugInfo
    elseif l:sub_command == 'ShowDiags'
        YcmDiags
    endif
endfunction
command -nargs=+ -complete=customlist,LspHelperSubCommands LspHelper :call LspHelper(<f-args>)

function! CustomizedAutoformat()
    if &filetype == "java"
        YcmCompleter Format
    else
        Autoformat
    endif
endfunction
command CustomizedAutoformat :call CustomizedAutoformat()
" }}}

" Ultisnip {{{
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" }}}

" JAVA specified seting {{{
" autocmd BufEnter *.java setlocal expandtab!
let g:java_highlight_functions=1
let g:java_highlight_java_lang_ids=1
""}}}

" No line number {{{
autocmd TerminalWinOpen * setlocal nonumber norelativenumber
" }}}

" Scroll popup {{{
function! ScrollPopup(down)
    let winid = popup_findinfo()
    if winid == 0
        return 0
    endif

    let pp = popup_getpos(winid)
    if pp.visible != 1
        return 0
    endif

    let firstline = pp.firstline + a:down
	let buf_lastline = str2nr(trim(win_execute(winid, "echo line('$')")))
    if firstline < 1
        let firstline = 1
    elseif pp.lastline + a:down > buf_lastline
        let firstline = firstline - a:down + buf_lastline - pp.lastline
    endif

    " The appear of scrollbar will change the layout of the content which will cause inconsistent height.
    call popup_setoptions( winid,
                \ {'scrollbar': 0, 'firstline' : firstline } )

    return 1
endfunction

inoremap <expr> <C-e> ScrollPopup(3) ? '' : '<C-e>'
inoremap <expr> <C-y> ScrollPopup(-3) ? '' : '<C-y>'
" }}}
