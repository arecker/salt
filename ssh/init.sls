{% from "ssh/map.jinja" import ssh with context %}

ssh-package:
  pkg.installed:
    - name: {{ ssh.package }}

ssh-config:
  file.managed:
    - name: {{ ssh.config }}
    - source: salt://ssh/files/config.conf
    - user: root
    - group: root
    - mode: 644
    - require:
        - pkg: ssh-package

ssh-motd:
  file.managed:
    - name: {{ ssh.motd }}
    - source: salt://ssh/files/motd.txt
    - user: root
    - group: root
    - mode: 644

ssh-service:
  service.running:
    - name: {{ ssh.service }}
    - enable: True
    - watch:
        - pkg: ssh-package
        - file: ssh-motd
        - file: ssh-config
