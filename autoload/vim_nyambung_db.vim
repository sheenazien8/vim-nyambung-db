" --------------------------------
" Add our plugin to the path
" --------------------------------
if has("python3")
  command! -nargs=1 Py py3 <args>
else
  command! -nargs=1 Py py <args>
endif

Py import sys
Py import vim
Py sys.path.append(vim.eval('expand("<sfile>:h")'))

let g:database = ''
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

function! vim_nyambung_db#VimNyambungDb(buff_type)
if g:database == ''
  let g:database = input("Database: ")
endif

Py << EOF
from vim_nyambung_db import *

def get_visual_selection():
    buf = vim.current.buffer
    (starting_line_num, col1) = buf.mark('<')
    (ending_line_num, col2) = buf.mark('>')
    lines = vim.eval('getline({}, {})'.format(starting_line_num, ending_line_num))
    lines[0] = lines[0][col1:]
    lines[-1] = lines[-1][:col2 + 1]
    return lines, starting_line_num, ending_line_num, col1, col2

def delete_old_output_if_exists():
    if int(vim.eval('buflisted("results")')):
        vim.command('bdelete results')
def create_window_result():
    delete_old_output_if_exists()
    vim.command('split /tmp/results.md')
    vim.command("normal! gg")
    vim.command("normal! i")
    vim.command("normal! w")
    vim.command("file results")
    vim.command('setlocal filetype=text')
    vim.command('setlocal buftype=nowrite')
    vim.command('normal! G')

def execute():
    lines, starting_line_num, ending_line_num, col1, col2 = get_visual_selection()
    command_selection = lines[0]
    config = map_credentians(vim.eval('g:credentials'), vim.eval('g:database'))
    result_command = get_result_from_command(command_selection, config)
    print(result_command)
    output = map_result_from_command(result_command)
    create_window_result()

def execute_from_shell():
    lines, starting_line_num, ending_line_num, col1, col2 = get_visual_selection()
    input_credentials = vim.eval('g:credentials')
    query = ' '.join(lines)
    config = map_credentians(input_credentials, vim.eval('g:database'))
    run_from_shell(query, config)
    create_window_result()

execute_from_shell()
EOF
endfunction

