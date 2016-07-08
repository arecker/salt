ssh_port: 22

users:
  alex:
    name: Alex Recker
    password: mW/NIfgJNeq3M
    sudo: True
    keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNiV+TbU+BEvmY6rcNrYsOF+4j+pRE1qQo6B364ZBMcXzJcWqlFR5zyEBJD7znAa1L/zK2WgVh1zPqRDKeRUOJzulx/acM2TngoQim/zxQD4+72lZyeG/LSqKw/9u7c2dbxJQvzSpdW9+Xlsc9rymZ5qYL0qC5DmzlKXLtN9kRyGoGNvWX/dfJtPBgsDfVleghsxKXVLvXw6DHC/p/NppbYyMGRrYjFNJEv5xDT0ka011gP1ORzIDSbd+XlJxxf7GTfyY0OARRUal9Ey8U79PGqDTBqRUS4IIu7QFHMMJ1+4W2UdtZ86SnT7kEVM9LsZ8AzlOb8LPFGz98r2l1z/pl alex@hurricane-ron"

statics:
  bob:
    git: https://github.com/arecker/bobrosssearch.com.git
    root: /var/www/bob
    host: bobrosssearch.com
    user: travis
  blog-jekyll:
    root: /var/www/blog
    user: travis
    host: alexrecker.com

djangos:
  blog:
    user: travis
    git: https://github.com/arecker/blog
    host: backend.alexrecker.com
    port: 8001
    secret: lol-so-secret
    db_user: blog
    db_name: blogdb
    db_pass: docker
    email_host: smtp.test.com
    email_user: alex@test.com
    email_pass: lol-dont-tell-anyone
    email_port: 887
    static: /var/www/blog-backend
    log: /home/travis/logs/blog.log
    redis_cache_no: 0
    redis_broker_no: 1
  moolah:
    user: travis
    git: https://github.com/arecker/moolah
    host: moolah.reckerfamily.com
    port: 8002
    secret: anotha-secret-yo
    db_user: moolah
    db_name: moolah
    db_pass: travisdb
    static: /var/www/moolah
    log: /home/travis/logs/moolah
    redis_cache_no: 2
    redis_broker_no: 3
