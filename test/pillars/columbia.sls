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

git:
  bobrosssearch.com:
    user: alex
    target: /home/alex/public/bobrosssearch.com
    url: https://github.com/arecker/bobrosssearch.com.git

docker:
  bob-proxy:
    image: nginx
    binds: /home/alex/public/bobrosssearch.com:/usr/share/nginx/html:ro
    publish: 8000:80
  blog-proxy:
    image: nginx
    binds: /home/alex/public/alexrecker.com:/usr/share/nginx/html:ro
    publish: 8002:80
  wedding-proxy:
    image: nginx
    binds: /home/alex/public/alexandmarissa.com:/usr/share/nginx/html:ro
    publish: 8003:80
  random.png:
    image: arecker/random.png:latest
    binds: /home/alex/public/random.png:/app/images:ro
    publish: 8004:8000

  reckerdogs-db:
    image: mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: reckerdogs
      MYSQL_USER: reckerdogs
      MYSQL_PASSWORD: password
  reckerdogs-wp:
    image: wordpress
    publish: '8001:80'
    links: reckerdogs-db:mysql
    envnironment:
      WORDPRESS_DB_USER: reckerdogs
      WORDPRESS_DB_PASSWORD: password
      WORDPRESS_DB_NAME: reckerdogs

  moolah-redis:
    image: redis
  moolah-db:
    image: postgres
    environment:
      POSTGRES_DB: moolah
      POSTGRES_PASSWORD: moolahpassword
  moolah:
    image: arecker/moolah:latest
    links: moolah-db:db,moolah-redis:redis
    publish: '8005:80'
    environment:
      HOST: moolah.reckerfamily.local
      DB_PASS: moolahpassword
      SECRET_KEY: lol-this-is-so-secret
      
nginx:
  bob:
    host: bobrosssearch.local
    rootproxy: http://127.0.0.1:8000
  reckerdogs:
    host: reckerdogs.local
    rootproxy: http://127.0.0.1:8001
  blog:
    host: alexrecker.local
    rootproxy: http://127.0.0.1:8002
    proxies:
      /random.png: http://127.0.0.1:8004/
  wedding:
    host: alexandmarissa.local
    rootproxy: http://127.0.0.1:8003
  moolah:
    host: moolah.reckerfamily.local
    rootproxy: http://127.0.0.1:8005
