directories:
  /home/alex/bin:
    user: alex
    group: alex
  /home/alex/data:
    user: alex
    group: alex
  /home/alex/public/alexrecker.com:
    user: alex
    group: alex
  /home/alex/public/alexandmarissa.com:
    user: alex
    group: alex

git:
  bobrosssearch.com:
    user: alex
    target: /home/alex/public/bobrosssearch.com
    url: https://github.com/arecker/bobrosssearch.com.git

docker:
  
  bob:
    image: nginx
    binds: /home/alex/public/bobrosssearch.com:/usr/share/nginx/html:ro
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
    links: moolah-db:db,moolah-redis:redis
    ports: "8000"
    cmd: gunicorn
    environment:
      HOST: moolah.reckerfamily.local
      DB_PASS: moolahpassword
      SECRET_KEY: lol-this-is-so-secret
  moolah-celery:
    image: arecker/moolah:latest
    links: moolah-db:db,moolah-redis:redis
    cmd: celery
    environment:
      HOST: moolah.reckerfamily.local
      DB_PASS: moolahpassword
      SECRET_KEY: lol-this-is-so-secret
  moolah-nginx:
    image: arecker/moolah:latest
    links: moolah-db:db,moolah-redis:redis,moolah-gunicorn:gunicorn
    ports: "80"
    cmd: nginx
    environment:
      VIRTUAL_HOST: moolah.reckerfamily.local
      HOST: moolah.reckerfamily.local
      DB_PASS: moolahpassword
      SECRET_KEY: lol-this-is-so-secret

  random.png:
    image: arecker/random.png
    binds: /home/alex/public/random.png:/app/images:ro
  subscribah-db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: subscriber
  subscribah:
    image: arecker/subscribah:latest
    links: subscribah-db:db
    environment:
      SERVER_NAME: alexrecker.local
      DB_PASSWORD: dbpassword
      SECRET_KEY: blah-blah-blah
      SMTP_USER: you@gmail.com
      SMTP_PASSWORD: yourpassword
  blog:
    image: arecker/blog:latest
    links: random.png:random.png,subscribah:subscribah
    binds: /home/alex/public/alexrecker.com:/usr/share/nginx/html:ro
    environment:
      VIRTUAL_HOST: alexrecker.local
