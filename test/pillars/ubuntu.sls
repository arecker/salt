systemd: False

upstart:
  random.png:
    user: alex
    group: alex
    dir: /home/alex/git/random.png
    start: /home/alex/.virtualenvs/random.png/bin/python server.py
