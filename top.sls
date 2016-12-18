base:

  '*':
    - locale
    - user
    - git
    - docker

  'roles:server':
    - match: grain
    - iptables
    - ssh

  'roles:webserver':
    - match: grain
    - certbot
    - nginx
