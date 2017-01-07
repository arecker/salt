directories:
  /home/alex/bin:
    user: alex
    group: alex
  /home/alex/public/alexrecker.com:
    user: alex
    group: alex
  /home/alex/public/alexandmarissa.com:
    user: alex
    group: alex
  /home/alex/images:
    user: alex
    group: alex

docker:

  bob:
    image: arecker/bobrosssearch.com:latest
    environment:
      VIRTUAL_HOST: bobrosssearch.local

  wedding:
    image: nginx
    binds: /home/alex/public/alexandmarissa.com:/usr/share/nginx/html:ro
    environment:
      VIRTUAL_HOST: alexandmarissa.local

  reckerdogs-db:
    image: mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: reckerdogs
      MYSQL_USER: reckerdogs
      MYSQL_PASSWORD: reckerdogspassword

  reckerdogs:
    image: wordpress
    links: reckerdogs-db:mysql
    environment:
      VIRTUAL_HOST: reckerdogs.local
      WORDPRESS_DB_USER: reckerdogs
      WORDPRESS_DB_PASSWORD: reckerdogspassword
      WORDPRESS_DB_NAME: reckerdogs

  subscribah-db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: subscriberpassword
      POSTGRES_DB: subscriber

  subscribah:
    image: arecker/subscribah:latest
    links:
      - subscribah-db:db
    environment:
      DB_PASSWORD: subscriberpassword
      SECRET_KEY: secret-key-lol
      SMTP_USER: user@test.com
      SMTP_PASSWORD: mailpassword

  random.png:
    image: arecker/random.png:latest
    binds: /home/alex/images:/app/images:ro

  blog:
    image: arecker/blog-proxy:latest
    binds: /home/alex/public/alexrecker.com:/usr/share/nginx/html:ro
    links:
      - subscribah:subscribah
      - random.png:random.png
    environment:
      VIRTUAL_HOST: alexrecker.local
