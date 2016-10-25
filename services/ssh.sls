ssh-package:
  pkg.installed:
    - name: openssh-server

ssh-config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://services/files/ssh-config.conf
    - user: root
    - group: root
    - mode: 644
    - require:
        - pkg: ssh-package

ssh-motd:
  file.managed:
    - name: /etc/motd
    - source: salt://services/files/ssh-motd.txt
    - user: root
    - group: root
    - mode: 644

ssh-service:
  service.running:
    - name: ssh
    - enable: True
    - watch:
        - pkg: ssh-package
        - file: ssh-motd
        - file: ssh-config
