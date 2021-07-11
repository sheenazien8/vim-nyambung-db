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
Py from vim_nyambung_db import *

let g:database = ''
function! ConnectTheDB()
if g:database == ''
  let g:database = input("Database: ")
endif
let s:query = input("Query: ")
Py << EOF
def execute_command_query():
    command_selection = vim.eval('s:query')
    config = map_credentians(vim.eval('g:credentials'), vim.eval('g:database'))
    result_command = get_result_from_command(command_selection, config)
    output = map_result_from_command(result_command)
    create_window_result()

execute_command_query()

EOF
endfunction

function! vim_nyambung_db#VimNyambungDb(buff_type)
if g:database == ''
  let g:database = input("Database: ")
endif

Py << EOF

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
    vim.command('let lines=getbufline(bufnr("/tmp/results.md"), 1, "$")')
    for line in range(0, len(' '.join(vim.eval('lines')).split('# ')) - 1):
      vim.command("normal! 2ji")
      vim.command("normal! }")
      pass
    vim.command("file results")
    vim.command('setlocal filetype=text')
    vim.command('setlocal buftype=nowrite')
    vim.command('normal! G')

def execute():
    lines, starting_line_num, ending_line_num, col1, col2 = get_visual_selection()
    command_selection = ' '.join(lines)
    config = map_credentians(vim.eval('g:credentials'), vim.eval('g:database'))
    result_command = get_result_from_command(command_selection, config)
    output = map_result_from_command(result_command)
    create_window_result()

execute()
EOF
endfunction

