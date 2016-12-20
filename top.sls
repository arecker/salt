base:

  '*':
    - locale
    - user
    - fs

  'roles:development':
    - match: grain
    - git
    - emacs
    - python
    - docker

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
