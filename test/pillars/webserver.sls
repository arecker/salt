docker:
  reckerdogsdata:
    image: debian:jessie
    volumes: [ /var/lib/mysql, /var/www/html/wp-content ]
  reckerdogsdb:
    image: mysql
    volumes_from: reckerdogsdata
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: reckerdogs
      MYSQL_USER: reckerdogs
      MYSQL_PASSWORD: password
  reckerdogs:
    image: wordpress
    publish: '8000:80'
    links: reckerdogsdb:mysql
    volumes_from: reckerdogsdata
    environment:
      WORDPRESS_DB_USER: reckerdogs
      WORDPRESS_DB_PASSWORD: password
      WORDPRESS_DB_NAME: reckerdogs

nginx:
  reckerdogs:
    host: reckerdogs.local
    rootproxy: http://127.0.0.1:8000
