" infolines.vim
" Author: Sarah H. McGrath <https://www.shmcgrath.com>
" Version: 0.0.3

" Global Infoline symbol variables
let g:infoline_git = 'git'
let g:infoline_line = 'ln'
let g:infoline_lock = 'X'
let g:infoline_read = 'RO'
let g:infoline_mod = '+'
let g:infoline_unmod = '-'
let g:infoline_bad = '!'
let g:infoline_sep_short = '-'
let g:infoline_sep_tall = '|'
let g:infoline_sep_round = '*'

" Define colors for statusline
let s:dictstatuscolor={'red': 'hi StatusLine guifg=#ab4642',
                        \ 'orange': 'hi StatusLine guifg=#dc9656',
                        \ 'yellow': 'hi StatusLine guifg=#f7ca88',
                        \ 'green': 'hi StatusLine guifg=#a1b56c',
                        \ 'blue': 'hi StatusLine guifg=#7cafc2',
                        \ 'purple': 'hi StatusLine guifg=#ab4642',
                        \ 'brown': 'hi StatusLine guifg=#7cafc2',}

" Define mode dictionary
let s:dictmode= {'n': ['NORMAL', 'green'],
                \ 'no': ['NORMAL-OP', 'green'],
                \ 'v': ['VISUAL', 'purple'],
                \ 'V': ['VISUAL-LN', 'purple'],
                \ '': ['VISUAL-BLK', 'purple'],
                \ 's': ['SELECT', 'yellow'],
                \ 'S': ['SELECT-LN', 'yellow'],
                \ '^S': ['SELECT-BLK', 'yellow'],
                \ 'i': ['INSERT', 'blue'],
                \ 'R': ['REPLACE', 'red'],
                \ 'Rv': ['REPLACE-VIR', 'red'],
                \ 'c': ['COMMAND', 'orange'],
                \ 'cv': ['EX-VIM', 'brown'],
                \ 'ce': ['EX-NORMAL', 'brown'],
                \ 'r': ['PROMPT', 'brown'],
                \ 'rm': ['MORE', 'brown'],
                \ 'r?': ['CONFIRM', 'brown'],
                \ '!': ['SHELL', 'orange'],
                \ 't': ['TERMINAL', 'orange']}

" TABLINE
"function! GetTabline()
"    let l:tabline = ''
"    for i in range 
"endfunction

"function! GetTabLabel()
"endfunction

" STATUSLINE

function! GitInfo()
    let l:gitstatus = ''
    if get(g:, 'loaded_fugitive')
        let l:gitbranch = ''
        let l:gitbranch = %{FugitiveHead()}
        if l:gitbranch != ''
            let l:gitstatus = '[' .g:infoline_git .'-' .l:gitbranch .']'
        else
            let l:gitstatus = '[' .g:infoline_git .']'
        endif
    endif
    return l:gitstatus
endfunction

" Set a lock if the document is read only and not modifiable
function! ReadOnly()
    let l:rostatus = ''
    if !&modifiable && &readonly
        let l:rostatus = g:infoline_lock .g:infoline_read
    elseif &modifiable && &readonly
        let l:rostatus = g:infoline_read
    elseif !&modifiable && !&readonly
        let l:rostatus = g:infoline_lock
    endif
    return '[' .l:rostatus .']'
endfunction

" Set symbols if document has beem modified (○/+) or not modified (●/-)
function! Modified()
    let l:modstatus = ''
    if &modified
        let l:modstatus = g:infoline_mod
    elseif !&modified
        let l:modstatus = g:infoline_unmod
    else
        let l:modstatus = g:infoline_bad
    endif
    return '[' .l:modstatus .']'
endfunction

" Get current mode from dictionary and return it
" If mode is not in dictionary return the abbreviation
" GetMode() gets the mode from the array then returns the name
function! GetMode()
    let l:modenow = mode()
    let l:modelist = get(s:dictmode, l:modenow, [l:modenow, 'red'])
    let l:modecolor = l:modelist[1]
    let l:modename = l:modelist[0]
    let l:modeexe = get(s:dictstatuscolor, l:modecolor, 'red')
        exec l:modeexe
        return l:modename
endfunction

" Get the size of the file in the buffer
function! GetFileSize()
    let l:filesize = getfsize(expand(@%))
    let l:printsize = 0
    let l:byteunit = ''
    if l:filesize >= 1099511627776
        let l:printsize = l:filesize / 1099511627776
        let l:byteunit = 'TB'
    elseif l:filesize >= 1073741824
        let l:printsize = l:filesize / 1073741824
        let l:byteunit = 'GB'
    elseif l:filesize >= 1048576
        let l:printsize = l:filesize / 1048576
        let l:byteunit = 'MB'
    elseif l:filesize >= 1024
        let l:printsize = l:filesize / 1024
        let l:byteunit = 'KB'
    elseif l:filesize < 1024
        let l:printsize = l:filesize
        let l:byteunit = 'B'
    elseif l:filesize <= 0
        let l:printsize = 0
        let l:byteunit = 'B'
    endif
    return l:printsize .l:byteunit
endfunction

" Get information about curent column in CSV file
function! GetCsvColInfo ()
    let l:csvcolinfo = ''
    if &ft == 'csv'
        if exists("*CSV_WCol")
            let l:csvcolname = CSV_WCol("Name")
            let l:csvcolnum = CSV_WCol()
            let l:csvcolinfo = '*[' .l:csvcolname. l:csvcolnum. ']'
        endif
    endif
    return l:csvcolinfo
endfunction

set statusline= " Set statusline to blank
set statusline=%{Modified()}
set statusline+=%{GetMode()}
set statusline+=%{ReadOnly()}
set statusline+=%{GitInfo()}
set statusline+=%{g:infoline_sep_round}
set statusline+=%t
set statusline+=%=  " Switch to right side of statusline
set statusline+=%{GetCsvColInfo()}
set statusline+=%{g:infoline_sep_round}
set statusline+=%{GetFileSize()}
set statusline+=%y  " Type of file in buffer
set statusline+=%{g:infoline_sep_round}
set statusline+=%{&ff}  " Format of the file
set statusline+=%{g:infoline_sep_tall}
set statusline+=%03v    " Current column - 000
set statusline+=%{g:infoline_sep_tall}
set statusline+=%{g:infoline_line}
set statusline+=%04l    " Current line - 0000
set statusline+=/   " Separator
set statusline+=%04L    " Total lines - 0000
set statusline+=%{g:infoline_sep_round}
set statusline+=%P  " Percentage through buffer
