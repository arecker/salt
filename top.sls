base:

  '*':
    - locale
    - user
    - fs

  'roles:server':
    - match: grain
    - iptables
    - ssh
    - git
    - python
    - docker

  'roles:webserver':
    - match: grain
    - certbot
    - nginx
