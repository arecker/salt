import urllib
import socket
import unittest

import psycopg2


class TestWebsites(unittest.TestCase):
    def assert_website_works(self, url='', expected_html='', domain=''):
        response = urllib.urlopen(url)
        content = ''.join(response.readlines())
        self.assertEqual(response.getcode(), 200)
        self.assertIn(expected_html, ''.join(response.readlines()))
        self.assertEqual(socket.gethostbyname(domain), '127.0.0.1')

    def test_bob(self):
        self.assert_website_works(
            url='http://bobrosssearch.com',
            expected_html='<title>Bob Ross Search</title>',
            domain='bobrosssearch.com'
        )

    def test_blog(self):
        with open('/var/www/blog/index.html', 'w+') as f:
            f.write('<h1>Hi There</h1>')
        self.assert_website_works(
            url='http://alexrecker.com',
            expected_html='<h1>Hi There</h1>',
            domain='alexrecker.com'
        )

    def test_moolah(self):
        self.assert_website_works(
            url='http://moolah.reckerfamily.com',
            expected_html='Login',
            domain='moolah.reckerfamily.com'
        )


class TestDatabase(unittest.TestCase):
    def assert_database_works(self, name='', user='', password='', table=''):
        connstring = "dbname='{}' user='{}' host='localhost' password='{}'".format(name, user, password)
        conn = psycopg2.connect(connstring)
        cursor.execute("SELECT 1 FROM {}".table)
        record = cursor.fetchone()
        self.assertEqual(record, 1)

    def test_blog(self):
        self.assert_database_works(name='blogdb', user='blog', password='docker', table='auth_user')


if __name__ == '__main__':
    unittest.main()
