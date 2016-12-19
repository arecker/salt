git:
  bobrosssearch.com:
    user: alex
    target: /home/alex/public/bobrosssearch.com
    url: https://github.com/arecker/bobrosssearch.com.git

docker:
  bob:
    image: nginx
    binds: /home/alex/public/bobrosssearch.com:/usr/share/nginx/html:ro
    publish: 8001:80
  reckerdogsdb:
    image: mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: reckerdogs
      MYSQL_USER: reckerdogs
      MYSQL_PASSWORD: password
  reckerdogs:
    image: wordpress
    publish: '8000:80'
    links: reckerdogsdb:mysql
    environment:
      WORDPRESS_DB_USER: reckerdogs
      WORDPRESS_DB_PASSWORD: password
      WORDPRESS_DB_NAME: reckerdogs
  random.png:
    image: arecker/random.png:latest
    publish: 8003:8000

nginx:
  reckerdogs:
    host: reckerdogs.local
    rootproxy: http://127.0.0.1:8000
  bob:
    host: bobrosssearch.local
    rootproxy: http://127.0.0.1:8001
    proxies:
      /random.png: http://127.0.0.1:8003
