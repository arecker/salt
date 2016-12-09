user:
  alex:
    groups: [ sudo ]

git:
  bob:
    url: https://github.com/arecker/bobrosssearch.com.git
    target: /usr/share/nginx/bob
  random.png:
    url: https://github.com/arecker/random.png
    target: /home/alex/git/random.png
    user: alex

virtualenv:
  random.png:
    root: /home/alex/.virtualenvs/random.png
    user: alex
    requirements: /home/alex/git/random.png/requirements.txt

systemd:
  random.png:
    user: alex
    group: alex
    dir: /home/alex/git/random.png
    start: /home/alex/.virtualenvs/random.png/bin/python server.py

nginx:
  blog:
    root: /usr/share/nginx/blog
    host: alexrecker.local
    redirects:
      /anakin/: /anakin.html
    proxies:
      /random.png: http://127.0.0.1:8000/
  bob:
    root: /usr/share/nginx/bob
    host: bobrosssearch.local
