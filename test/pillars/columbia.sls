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

volumes:
  reckerdogs-database: {}
  reckerdogs-wordpress: {}

containers:
  bob:
    image: arecker/bobrosssearch.com:latest
    environment:
      VIRTUAL_HOST: reckerdogs.local
  reckerdogs-database:
    image: mysql
    binds: reckerdogs-database:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: reckerdogs
      MYSQL_USER: reckerdogs
      MYSQL_PASSWORD: reckerdogspassword
  reckerdogs-wordpress:
    image: wordpress
    links: reckerdogs-database:mysql
    binds: reckerdogs-wordpress:/var/www/html
    environment:
      VIRTUAL_HOST: reckerdogs.local
      WORDPRESS_DB_USER: reckerdogs
      WORDPRESS_DB_PASSWORD: reckerdogspassword
      WORDPRESS_DB_NAME: reckerdogs
