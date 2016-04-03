base:
  '*':
    - auth
    - firewall
    - git
    - host
    - memcached
    - database
    - virtualenv
    - django
    - systemd
    - nginx
    # - letsencrypt
    # - nginx  # needs to run again to pick up ssl stuff
