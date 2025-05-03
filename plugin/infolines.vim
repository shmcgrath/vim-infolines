" infolines.vim
" Author: Sarah H. McGrath <https://www.shmcgrath.com>
" Version: 0.0.4

" Global Infoline symbol variables
let g:infoline_git = 'git'
let g:infoline_line = 'ln'
let g:infoline_lock = 'X'
let g:infoline_readonly = 'RO'
let g:infoline_help = 'HLP'
let g:infoline_preview = 'PRV'
let g:infoline_quickfix = 'QFL'
let g:infoline_location_list = 'LOCL'
let g:infoline_mod = '+'
let g:infoline_unmod = '-'
let g:infoline_bad = '!'
let g:infoline_sep_short = '-'
let g:infoline_sep_tall = '|'
let g:infoline_sep_round = '●'

" Define colors for statusline
let s:dictstatuscolor={'red': 'hi StatusLine guifg=#660000',
                        \ 'orange': 'hi StatusLine guifg=#fe6700',
                        \ 'yellow': 'hi StatusLine guifg=#fffb0a',
                        \ 'green': 'hi StatusLine guifg=#004e00',
                        \ 'blue': 'hi StatusLine guifg=#1d2951',
                        \ 'purple': 'hi StatusLine guifg=#4b006e',
                        \ 'brown': 'hi StatusLine guifg=#6f4e37',}

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

let s:dict_special_labels = {
	\ 'filetype:Outline':     'Symbols',
	\ 'filetype:checkhealth': 'Health',
	\ 'filetype:dashboard':   'Dashboard',
	\ 'filetype:fzf':         'FZF',
	\ 'filetype:fzf-lua':     'FZF',
	\ 'filetype:gitcommit':   'Commit',
	\ 'filetype:lspinfo':     'LSP',
	\ 'filetype:man':         'Man',
	\ 'filetype:netrw':       'netrw',
	\ 'filetype:oil':         'Oil',
	\ 'buftype:help':         'Help',
	\ 'buftype:nofile':       'Scratch',
	\ 'buftype:prompt':       'Prompt',
	\ 'buftype:quickfix':     'Quickfix',
	\ 'buftype:terminal':     'Terminal',
\ }

" STATUSLINE
function! GitInfo()
    try
        if get(g:, 'loaded_fugitive')
			return FugitiveStatusline()
        endif
    catch
        return "GitInfo Error: " . v:exception
    endtry
endfunction

" Set a lock if the document is read only and not modifiable
function! ReadOnly()
    try
        let l:rostatus = ''
        if !&modifiable && &readonly
            let l:rostatus = g:infoline_lock .g:infoline_readonly
        elseif &modifiable && &readonly
            let l:rostatus = g:infoline_readonly
        elseif !&modifiable && !&readonly
            let l:rostatus = g:infoline_lock
        endif
        return '[' .l:rostatus .']'
    catch
        return "ReadOnly Error: " . v:exception
    endtry
endfunction

" Set symbols if document has beem modified (○/+) or not modified (●/-)
function! Modified()
    try
        let l:modstatus = ''
        if &modified
            let l:modstatus = g:infoline_mod
        elseif !&modified
            let l:modstatus = g:infoline_unmod
        else
            let l:modstatus = g:infoline_bad
        endif
        return '[' .l:modstatus .']'
    catch
        return "Modified Error: " . v:exception
    endtry
endfunction

" Get current mode from dictionary and return it
" If mode is not in dictionary return the abbreviation
" GetMode() gets the mode from the array then returns the name
function! GetMode()
    try
        let l:modenow = mode()
        let l:modelist = get(s:dictmode, l:modenow, [l:modenow, 'red'])
        let l:modecolor = l:modelist[1]
        let l:modename = l:modelist[0]
        let l:modeexe = get(s:dictstatuscolor, l:modecolor, 'red')
            return l:modename
    catch
        return "GetMode Error: " . v:exception
    endtry
endfunction

function! WinBuffInfo()
    let l:winbuffstat = ''
endfunction

" Get the size of the file in the buffer
function! GetFileSize()
    try
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
    catch
        return "GetFileSize Error: " . v:exception
    endtry
endfunction

" Get information about curent column in CSV file
function! GetCsvColInfo ()
    try
        let l:csvcolinfo = ''
        if &ft == 'csv'
            if exists("*CSV_WCol")
                let l:csvcolname = CSV_WCol("Name")
                let l:csvcolnum = CSV_WCol()
                let l:csvcolinfo = '*[' .l:csvcolname. l:csvcolnum. ']'
            endif
        endif
        return l:csvcolinfo
    catch
        return "GetCsvColInfo Error: " . v:exception
    endtry
endfunction

"function! GetLinterInfo() abort
	"if exists(':ALEEnable')
		"try
			"let l:counts = ale#statusline#Count(bufnr('%'))
			"let l:all_errors = l:counts.error + l:counts.style_error
			"let l:all_non_errors = l:counts.total - l:all_errors
			"return l:counts.total == 0 ? 'OK' : printf('%dW %dE', all_non_errors, all_errors)
		"catch
			"return "GetLinterInfo Error: " . v:exception
		"endtry
	"else
		"return "ALE NOT INST."
	"endif
"endfunction

" This is the recommended LinterStatus() function from ALE docs
function! LinterStatus() abort
	if exists('g:ale_enabled')
		try
			let l:counts = ale#statusline#Count(bufnr(''))

			let l:all_errors = l:counts.error + l:counts.style_error
			let l:all_non_errors = l:counts.total - l:all_errors

			return l:counts.total == 0 ? 'OK' : printf(
			\   '%dW %dE',
			\   all_non_errors,
			\   all_errors
			\)
		catch
			return "LinterStatus Error: " . v:exception
		endtry
	endif
endfunction

"Then define the MyTabLine() function to list all the tab pages labels.  A
"convenient method is to split it in two parts:  First go over all the tab
"pages and define labels for them.  Then get the label for each tab page. >

"For basics see the 'statusline' option.  The same items can be used in the
"'tabline' option.  Additionally, the |tabpagebuflist()|, |tabpagenr()| and
"|tabpagewinnr()| functions are useful.

set statusline= " Set statusline to blank
set statusline+=%{Modified()}
set statusline+=%{GetMode()}
set statusline+=%{ReadOnly()}
set statusline+=%{GitInfo()}
set statusline+=%{g:infoline_sep_round}
set statusline+=%t
set statusline+=%{g:infoline_sep_round}
"set statusline+=%{GetLinterInfo()}
"set statusline+=%{LinterStatus()}
"display %h (help) %w (preview window) %q (quickfix or local list)
set statusline+=%h%w%q
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

function InfolinesTabLine() abort
  let s = ''
  for i in range(tabpagenr('$'))
	" select the highlighting
	if i + 1 == tabpagenr()
	  let s .= '%#TabLineSel#'
	else
	  let s .= '%#TabLine#'
	endif

	" set the tab page number (for mouse clicks)
	let s .= '%' .. (i + 1) .. 'T'

	" the label is made by InfolinesTabLabel()
	let s .= ' %{InfolinesTabLabel(' .. (i + 1) .. ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
	let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

"Now the MyTabLabel() function is called for each tab page to get its label. >

function InfolinesTabLabel(tab) abort
	let buflist = tabpagebuflist(a:tab)
	let winnr = tabpagewinnr(a:tab)
	let bufnumber = get(buflist, winnr - 1, -1)
	if bufnumber == -1
		return 'No Buffers'
	endif
	let fullpath = bufname(bufnumber)
	let filename = empty(fullpath) ? 'No Name' : fnamemodify(fullpath, ':t')
	let filetype = getbufvar(bufnumber, '&filetype')
	let buftype = getbufvar(bufnumber, '&buftype')

	let ft_key = 'filetype:' .. filetype
	let bt_key = 'buftype:' .. buftype

	if has_key(s:dict_special_labels, ft_key)
		let label = s:dict_special_labels[ft_key]
	elseif has_key(s:dict_special_labels, bt_key)
		let label = s:dict_special_labels[bt_key]
	elseif empty(fullpath)
		let ft = empty(filetype) ? 'FT' : filetype
		let bt = empty(buftype) ? 'BT' : buftype
		let label = ft .. bt
	else
		let label = filename
	endif

	let label = printf('[%02d|%s]', a:tab, label)

	for b in buflist
		let binfo = getbufinfo(b)
		if !empty(binfo) && binfo[0].changed
			let label = '+' .. label
			break
		endif
	endfor

	return label
endfunction

set tabline=%!InfolinesTabLine()
