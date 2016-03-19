{% set USER = pillar.get('user') %}
users:
  pkg.installed:
    - pkgs:
      - sudo
  user.present:
    - name: {{ USER }}
    - groups:
        - sudo
  ssh_auth.present:
    - user: {{ USER }}
    - source: salt://keys/hurricane-ron.pub

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://configs/sshd_config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/motd:
  file.managed:
    - source: salt://configs/motd.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

openssh-server:
  pkg.installed: []

sshd:
  service.running:
    - name: sshd
    - enable: true
    - watch:
      - pkg: openssh-server
      - file: /etc/ssh/sshd_config
    - require:
      - pkg: openssh-server
      - file: /etc/motd
      - file: /etc/ssh/sshd_config
