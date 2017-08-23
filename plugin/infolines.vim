" infolines.vim
" Author: Sarah H. McGrath <https://www.shmcgrath.com>
" Version: 0.0.2

" TODO: MAKE A LOADED VARIABLE

"------------------------------------------------------------------------------
" GLOBAL INFOLINE SYMBOL VARIABLES
"------------------------------------------------------------------------------
let s:dict_infoline_unicode ={'git': '⎇',
                        \ 'line': '☰',
                        \ 'lock': '🔒',
                        \ 'read': 'RO',
                        \ 'mod': '○',
                        \ 'unmod': '●',
                        \ 'bad': '💩',
                        \ 'sep_short': '▪',
                        \ 'sep_tall': '‖',}

let s:dict_infoline_text ={'git': 'git',
                        \ 'line': 'ln',
                        \ 'lock': 'X',
                        \ 'read': 'RO',
                        \ 'mod': '+',
                        \ 'unmod': '-',
                        \ 'bad': '!',
                        \ 'sep_short': '-',
                        \ 'sep_tall': '|',}

function! GetInfolineChars(dictionary)
	let l:infoline_dictionary = a:dictionary
    let g:infoline_git = get(l:infoline_dictionary, 'git', 'git')
    let g:infoline_line = get(l:infoline_dictionary, 'line', 'ln')
    let g:infoline_lock = get(l:infoline_dictionary, 'lock', 'X')
    let g:infoline_read = get(l:infoline_dictionary, 'read', 'RO')
    let g:infoline_mod = get(l:infoline_dictionary, 'mod', '+')
    let g:infoline_unmod = get(l:infoline_dictionary, 'unmod', '-')
    let g:infoline_bad = get(l:infoline_dictionary, 'bad', '!')
    let g:infoline_sep_short = get(l:infoline_dictionary, 'sep_short', '-')
    let g:infoline_sep_tall = get(l:infoline_dictionary, 'sep_tall', '|')
endfunction

" USER PREFS - WHAT CHARS TO USE, WHAT STATUS, WHAT TAB
let g:infoline_unicode = 6 
let g:infoline_status = 0
let g:infoline_tab= 0

if g:infoline_unicode == 0 || g:infoline_unicode >= 4
    call GetInfolineChars(s:dict_infoline_text)
elseif g:infoline_unicode == 1
    call GetInfolineChars(s:dict_infoline_unicode)
elseif g:infoline_unicode == 2
    call GetInfolineChars(g:dict_user_text)
elseif g:infoline_unicode == 3
    call GetInfolineChars(g:dict_user_unicode)
endif

"------------------------------------------------------------------------------
" TABLINE
"------------------------------------------------------------------------------
"function! GetTabline()
"    let l:tabline = ''
"    for i in range 
"endfunction

"function! GetTabLabel()
"endfunction
"------------------------------------------------------------------------------
" STATUSLINE
"------------------------------------------------------------------------------
" STATUS LINE FUNCTIONS

function! GitInfo()
    if exists(g:loaded_fugitive)
        let l:gitbranch = toupper(fugitive#head())
        if l:gitbranch != ''
            return '[' .g:infoline_git .'-' .l:gitbranch .']'
        else
            return '[' .g:infoline_git .']'
        endif
    else
        return ''
    endif
endfunction

" SET A LOCK IF THE DOCUMENT IS READ ONLY AND NOT MODIFIABLE
function! ReadOnly()
    if !&modifiable && &readonly
        return g:infoline_lock .g:infoline_read
    elseif &modifiable && &readonly
        return g:infoline_read
    elseif !&modifiable && !&readonly
        return g:infoline_lock
    else
        return ''
endfunction

" SET SYMBOLS IF DOCUMENT HAS BEEM MODIFIED (○/+) OR NOT MODIFIED (●/-)
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

" DEFINE MODE DICTIONARY
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

" DEFINE COLORS FOR STATUSLINE
let s:dictstatuscolor={'red': 'hi StatusLine guifg=#ab4642',
                        \ 'orange': 'hi StatusLine guifg=#dc9656',
                        \ 'yellow': 'hi StatusLine guifg=#f7ca88',
                        \ 'green': 'hi StatusLine guifg=#a1b56c',
                        \ 'blue': 'hi StatusLine guifg=#7cafc2',
                        \ 'purple': 'hi StatusLine guifg=#ab4642',
                        \ 'brown': 'hi StatusLine guifg=#7cafc2',}

" GET CURRENT MODE FROM DICTIONARY AND RETURN IT
" IF MODE IS NOT IN DICTIONARY RETURN THE ABBREVIATION
" GetMode() GETS THE MODE FROM THE ARRAY THEN RETURNS THE NAME
function! GetMode()
    let l:modenow = mode()
    let l:modelist = get(s:dictmode, l:modenow, [l:modenow, 'red'])
    let l:modecolor = l:modelist[1]
    let l:modename = l:modelist[0]
    let l:modeexe = get(s:dictstatuscolor, l:modecolor, 'red')
        exec l:modeexe
        return l:modename
endfunction

" GET THE SIZE OF THE FILE IN THE BUFFER
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

"------------------------------------------------------------------------------
" STATUS LINE
"------------------------------------------------------------------------------
set statusline=%{Modified()}       " CHECK MODIFIED STATUS
set statusline+=%{GetMode()}        " GET CURRENT MODE
set statusline+=[%{ReadOnly()}]     " CHECK READ ONLY AND MODIFIABLE STATUS
set statusline+=%{GitInfo()}        " GIT BRANCH INFORMATION
set statusline+=▪%.25F              " PATH TO THE FILE
set statusline+=%=                  " SWITCH TO RIGHT SIDE OF STATUS LINE
set statusline+=▪                   " SQUARE SEPARATOR
set statusline+=%{GetFileSize()}    " GET SIZE OF FILE
set statusline+=%y                  " TYPE OF THE FILE IN BUFFER
set statusline+=▪                   " SQUARE SEPARATOR
set statusline+=%{&ff}              " FORMAT OF THE FILE
set statusline+=‖                   " COLUMN SEPARATOR
set statusline+=%02v                " CURRENT COLUMN - 00
set statusline+=%{g:infoline_sep_tall}
set statusline+=%{g:infoline_line}
set statusline+=%03l               " CURRENT LINE - 0R00
set statusline+=/                   " SEPARATOR
set statusline+=%03L                " TOTAL LINES - 000
set statusline+=▪                   " SQUARE SEPARATOR
set statusline+=%P                  " PERCENTAGE THROUGH BUFFER
