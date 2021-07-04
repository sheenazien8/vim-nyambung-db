import os
import mysql.connector
from mysql.connector import errorcode

def map_result():
    credentials = os.sys.argv[4]

    credentials = os.sys.argv[4]
    account = []
    for credential in credentials.split(";"):
        rows = []
        for (value) in credential.split("="):
            rows.append(value)
        account.append(rows)
    database = ''
    account.append(['database', database])
    sql = ("")
    if len(os.sys.argv) >= 2:
        if os.sys.argv[1]:
            database = os.sys.argv[1]
            pass
        if os.sys.argv[2]:
            sql = (os.sys.argv[2])
            pass
        pass
    config = dict(account)

    try:
      cnx = mysql.connector.connect(**config)
      cursor = cnx.cursor()
      cursor.execute(sql)
      wrap = []
      for (row) in cursor:
          rows = []
          for percolumn in row:
              rows.append(str(percolumn))
              pass
          wrap.append(rows)
          pass
      column = cursor.column_names
      result = [column, *wrap]

      return result
    except mysql.connector.Error as err:
      if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Something is wrong with your user name or password")
      elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
      else:
        print("Something is wrong with your query or statement")
    else:
        cnx.close()
    pass

if map_result() is not None:
    result = map_result()
    with open(os.sys.argv[3], 'w') as writer:
        for (rows) in result:
            writer.write("|")
            for percolumn in rows:
                if not percolumn:
                    percolumn = "-"
                writer.write(percolumn + "|")
            writer.write("\n")
            pass
        pass
    pass
else:
    with open(os.sys.argv[3], 'w') as writer:
        writer.write("Something is wrong!!")
