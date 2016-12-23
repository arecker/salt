directories:
  /home/alex/bin:
    user: alex
    group: alex
  /home/alex/data:
    user: alex
    group: alex

docker:
  blog-db:
    image: mysql
    binds:
      - '/home/alex/data/blog/mysql:/var/lib/mysql'
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: blog
      MYSQL_USER: blog
      MYSQL_PASSWORD: blogpassword
  blog-wp:
    image: wordpress
    publish: '8001:80'
    binds:
      - '/home/alex/data/blog/wp-content:/var/www/html/wp-content'
    links: blog-db:mysql
    envnironment:
      WORDPRESS_DB_USER: blog
      WORDPRESS_DB_NAME: blog
      WORDPRESS_DB_PASSWORD: blogpassword
  portfolio-db:
    image: mysql
    binds:
      - '/home/alex/data/portfolio/mysql:/var/lib/mysql'
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: portfolio
      MYSQL_USER: portfolio
      MYSQL_PASSWORD: portfoliopassword
  portfolio-wp:
    image: wordpress
    publish: '8002:80'
    binds:
      - '/home/alex/data/portfolio/wp-content:/var/www/html/wp-content'
    links: portfolio-db:mysql
    envnironment:
      WORDPRESS_DB_USER: portfolio
      WORDPRESS_DB_NAME: portfolio
      WORDPRESS_DB_PASSWORD: portfoliopassword

nginx:
  blog:
    host: blog.sarahrecker.local
    rootproxy: http://127.0.0.1:8001
  portfolio:
    host: sarahrecker.local
    rootproxy: http://127.0.0.1:8002
