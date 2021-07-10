command! DBExecute ConnectTheDB()
command! -range DBExecuteSelection call vim_nyambung_db#VimNyambungDb("selection")
