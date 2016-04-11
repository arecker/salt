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

djangos:
  blog:
    user: alex
    host: backends.alexrecker.com
    secret: lol-so-secret
    git: https://github.com/arecker/blog.git
    src: /home/alex/git/blog
    root: /var/www/blog
    media_root: /var/www/blog/media
    static_root: /var/www/blog/static
    venv: /home/alex/.virtualenvs/blog
    requirements: /home/alex/git/blog/requirements/common.txt
    db_user: blogdb
    db_name: blogdb
    db_pass: docker