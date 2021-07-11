import mysql.connector
from mysql.connector import errorcode
import os
import subprocess

ERROR_LOG = "/tmp/error.log"
INPUT_FILE = "/tmp/input"
RESULTS_FILE = "/tmp/results.md"
connections = None

def map_credentians(dbconfig, database):
    account = []
    for credential in dbconfig.split(";"):
        rows = []
        for (value) in credential.split("="):
            rows.append(value)
        account.append(rows)
    account.append(['database', database])

    return dict(account)

def get_result_from_command(queries, config):
    try:
      cnx = mysql.connector.connect(**config)
      cursor = cnx.cursor()
      wrap = []
      queries = queries.split(';')
      while("" in queries) :
          queries.remove("")
      for query in queries:
          if len(query) > 0:
              query = query.replace('\n', '')
              query = query.strip()
              cursor.execute(query)
              column = cursor.column_names
              results = ['# ' + query, column]
              for row in cursor:
                  results.append(row)
                  pass
              pass
          wrap.append(results)
      cnx.commit()
      cursor.close()
      cnx.close()

      return wrap
    except mysql.connector.Error as err:
      if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Something is wrong with your user name or password")
      elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
      else:
        print(err)
    except Exception as e:
        print(e)
    else:
        cnx.close()

def map_result_from_command(result):
    with open(RESULTS_FILE, 'w') as writer:
        for (items) in result:
            for item in items:
                if isinstance(item, str):
                    writer.write(item.strip() + '\n')
                    pass
                else:
                    if len(item) > 0:
                        writer.write('|')
                        for record in item:
                            writer.write(str(record) + '|')
                        writer.write("\n")
            writer.write("\n")
            pass
        pass

    return read_file_results(RESULTS_FILE)

def read_file_results(file_to_read):
    if os.path.isfile(file_to_read):
        with open(file_to_read, "r") as f:
            return [l.rstrip('\n') for l in f.readlines()]

def run_from_shell(command, config):
    connection = "mysql -h {0[host]} -u {0[user]} -p{0[password]} -D {0[database]} -e ".format(config)
    shell_command = connection + "\"" + command + "\""
    subprocess.check_call("{0} < {1} > {2} 2> {3}".format(
        shell_command,
        INPUT_FILE,
        RESULTS_FILE,
        ERROR_LOG),
        shell=True
        )
    return read_file_lines(RESULTS_FILE)

def read_file_lines(file_to_read):
    if os.path.isfile(file_to_read):
        with open(file_to_read, "r") as f:
            return [l.rstrip('\n') for l in f.readlines()]
