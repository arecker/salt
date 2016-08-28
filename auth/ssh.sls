{% set SSH_PORT = pillar.get('ssh-port', None) %}
{% if SSH_PORT %}
ssh-packages:
  pkg.installed:
    - name: openssh-server

ssh-config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://auth/files/sshd_config
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
        - pkg: ssh-packages
    - context:
        PORT: {{ SSH_PORT }}

ssh-motd:
  file.managed:
    - name: /etc/motd
    - source: salt://auth/files/motd
    - user: root
    - group: root
    - mode: 644

ssh-service:
  service.running:
    - name: ssh
    - enable: true
    - watch:
        - pkg: ssh-packages
        - file: ssh-config
    - require:
        - pkg: ssh-packages
        - file: ssh-config
        - file: ssh-motd
{% endif %}
