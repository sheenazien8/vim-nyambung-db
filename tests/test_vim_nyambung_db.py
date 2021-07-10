import unittest
import autoload.vim_nyambung_db as vim_nyambung_db

class TestVimNyambungDB(unittest.TestCase):
    def test_map_credentals(self):
        input_credentials = "host=192.168.10.10;user=homestead;password=secret"
        expected_credentials_output = {
                'user': 'homestead',
                'password': 'secret',
                'host': '192.168.10.10',
                'database': 'lakasir'
                }
        self.assertEqual(expected_credentials_output, vim_nyambung_db.map_credentians(input_credentials, 'lakasir'))
       
    def test_get_result_from_command(self):
        input_credentials = "host=192.168.10.10;user=homestead;password=secret"
        query = "select id,username from \n users limit 2; select id from roles; insert into groups (name) values ('sheena')"
        config = vim_nyambung_db.map_credentians(input_credentials, 'lakasir')
        vim_nyambung_db.get_result_from_command(query, config)


    def test_run_query_from_shell(self):
        input_credentials = "host=192.168.10.10;user=homestead;password=secret"
        query = "select id,username from \n users limit 2; select id from roles; insert into groups (name) values ('sheena')"
        config = vim_nyambung_db.map_credentians(input_credentials, 'lakasir')
        vim_nyambung_db.run_from_shell(query, config)

if __name__ == '__main__':
    unittest.main()
