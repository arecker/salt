import urllib
import socket
import unittest


class TestWebsites(unittest.TestCase):
    def assert_website_works(self, expected_html='', domain=''):
        response = urllib.urlopen('http://' + domain)
        content = ''.join(response.readlines())
        self.assertEqual(response.getcode(), 200)
        self.assertIn(expected_html, content)
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
            expected_html='<title>Login to Moolah</title>',
        )


if __name__ == '__main__':
    unittest.main()
