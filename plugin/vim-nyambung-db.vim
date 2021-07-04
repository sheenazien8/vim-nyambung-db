" set credentials logins
let g:database = ""
let g:fullpath = ""
let g:location = ""
function! ConnectTheDB()
  let l:dir = $HOME . "/.config/nvim/modules/mysql/"
  if g:database == ""
    let g:database = input("Database Name: ")
  endif
  let l:query = input("Query: ")
  let l:sqlfile = split(getcwd(), '/')[-1] . ".md"
  let l:fullpath = l:dir . l:sqlfile
  if expand("%F") == l:fullpath
    :q
  endif
  if !isdirectory(expand(l:dir))
    execute "call mkdir(expand('" . l:dir. "', 'p'))"
  endif
  execute "!python3 src/connect-mysql.py " . g:database . " \"" . l:query . "\" " l:fullpath . " \"" . g:credentials. "\""
  execute "sp"
  execute "e " l:fullpath
  execute "normal! gg"
  execute "normal! i"
  execute "normal! w"
  :w
  let g:fullpath = l:fullpath
endfunction
function CloseWindowDB()
  if expand("%F") == g:fullpath
    bd!
  endif
endfunction

nnoremap <C-x> :call CloseWindowDB()<cr>

nmap <F11> :call ConnectTheDB() <CR>
