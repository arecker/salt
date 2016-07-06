import urllib
import socket
import unittest

import psycopg2


class TestWebsites(unittest.TestCase):
    def assert_website_works(self, expected_html='', domain=''):
        response = urllib.urlopen('http://' + domain)
        content = ''.join(response.readlines())
        self.assertEqual(response.getcode(), 200)
        self.assertIn(expected_html, ''.join(response.readlines()))
        self.assertEqual(socket.gethostbyname(domain), '127.0.0.1')

    def test_bob(self):
        self.assert_website_works(
            domain='bobrosssearch.com',
            expected_html='<title>Bob Ross Search</title>',
        )

    def test_blog(self):
        with open('/var/www/blog/index.html', 'w+') as f:
            f.write('<h1>Hi There</h1>')
        self.assert_website_works(
            domain='alexrecker.com',
            expected_html='<h1>Hi There</h1>',
        )

    def test_moolah(self):
        self.assert_website_works(
            domain='moolah.reckerfamily.com',
            expected_html='Login',
        )


class TestDatabase(unittest.TestCase):
    def assert_database_works(self, name='', user='', password='', table=''):
        connstring = "dbname='{}' user='{}' host='localhost' password='{}'".format(name, user, password)
        conn = psycopg2.connect(connstring)
        cursor.execute("SELECT 1 FROM {}".format(table))
        record = cursor.fetchone()
        self.assertEqual(record, 1)

    def test_blog(self):
        self.assert_database_works(
            name='blogdb',
            user='blog',
            password='docker',
            table='auth_user'
        )

    def test_moolah(self):
        self.assert_database_works(
            name='moolah',
            user='moolah',
            password='travisdb',
            table='auth_user'
        )


if __name__ == '__main__':
    unittest.main()
