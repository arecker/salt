import urllib
import socket
import unittest


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


if __name__ == '__main__':
    unittest.main()
