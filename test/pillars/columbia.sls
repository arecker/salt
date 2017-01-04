directories:
  /home/alex/bin:
    user: alex
    group: alex
  /home/alex/data:
    user: alex
    group: alex
  /home/alex/git:
    user: alex
    group: alex
  /home/alex/public/alexrecker.com:
    user: alex
    group: alex
  /home/alex/public/alexandmarissa.com:
    user: alex
    group: alex
  /home/alex/public/random.png:
    user: alex
    group: alex
  /home/alex/public/moolah.reckerfamily.com:
    user: alex
    group: alex

git:
  bobrosssearch.com:
    user: alex
    url: https://github.com/arecker/bobrosssearch.com.git
    target: /home/alex/git/bobrosssearch.com
  moolah:
    user: alex
    url: https://github.com/arecker/moolah.git
    target: /home/alex/git/moolah
  random.png:
    user: alex
    url: https://github.com/arecker/random.png.git
    target: /home/alex/git/random.png
  subscribah:
    user: alex
    url: https://github.com/arecker/subscribah.git
    target: /home/alex/git/subscribah
  django-proxy:
    user: alex
    url: https://github.com/arecker/django-proxy.git
    target: /home/alex/git/django-proxy
  blog-proxy:
    user: alex
    url: https://github.com/arecker/blog-proxy.git
    target: /home/alex/git/blog-proxy

docker:
  bob:
    image: arecker/bobrosssearch.com:latest
    build: /home/alex/git/bobrosssearch.com
    environment:
      VIRTUAL_HOST: bobrosssearch.local

  wedding:
    image: nginx
    binds: /home/alex/public/alexandmarissa.com:/usr/share/nginx/html:ro
    environment:
      VIRTUAL_HOST: alexandmarissa.local

  reckerdogs-db:
    image: mysql
    binds: /home/alex/data/reckerdogs/mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: reckerdogs
      MYSQL_USER: reckerdogs
      MYSQL_PASSWORD: password
  reckerdogs:
    image: wordpress
    binds: /home/alex/data/reckerdogs/wp-content:/var/www/html/wp-content
    links: reckerdogs-db:mysql
    environment:
      VIRTUAL_HOST: reckerdogs.local
      WORDPRESS_DB_USER: reckerdogs
      WORDPRESS_DB_PASSWORD: password
      WORDPRESS_DB_NAME: reckerdogs

  moolah-redis:
    image: redis
  moolah-db:
    image: postgres
    binds: /home/alex/data/moolah/postgres:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: moolahpassword
  moolah-gunicorn:
    image: arecker/moolah:latest
    build: /home/alex/git/moolah
    binds: /home/alex/public/moolah.reckerfamily.com:/var/www/moolah
    links:
      - moolah-db:db
      - moolah-redis:redis
    ports: [ 80 ]
    cmd: gunicorn
    environment:
      HOST: moolah.reckerfamily.local
      DB_PASS: moolahpassword
      SECRET_KEY: lol-this-is-so-secret
  moolah-celery:
    image: arecker/moolah:latest
    build: /home/alex/git/moolah
    links: moolah-db:db,moolah-redis:redis
    cmd: celery
    environment:
      HOST: moolah.reckerfamily.local
      DB_PASS: moolahpassword
      SECRET_KEY: lol-this-is-so-secret
  moolah-proxy:
    image: arecker/django-proxy:latest
    build: /home/alex/git/django-proxy
    binds: /home/alex/public/moolah.reckerfamily.com:/usr/share/nginx/html:ro
    links:
      - moolah-gunicorn:app
    environment:
      VIRTUAL_HOST: moolah.reckerfamily.local

  random.png:
    image: arecker/random.png
    build: /home/alex/git/random.png
    binds: /home/alex/public/random.png:/app/images:ro
  subscribah-db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: subscriber
  subscribah:
    image: arecker/subscribah:latest
    build: /home/alex/git/subscribah
    links: subscribah-db:db
    environment:
      SERVER_NAME: alexrecker.local
      DB_PASSWORD: dbpassword
      SECRET_KEY: blah-blah-blah
      SMTP_USER: you@gmail.com
      SMTP_PASSWORD: yourpassword
  blog:
    image: arecker/blog-proxy:latest
    build: /home/alex/git/blog-proxy
    links:
      - random.png:random.png
      - subscribah:subscribah
    binds: /home/alex/public/alexrecker.com:/usr/share/nginx/html:ro
    environment:
      VIRTUAL_HOST: alexrecker.local
