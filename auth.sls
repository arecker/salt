{% set USER = pillar.get('user') %}
{% set KEYS = pillar.get('keys') %}
users:
  pkg.installed:
    - pkgs:
      - sudo
      - bash
  user.present:
    - name: {{ USER }}
    - shell: /bin/bash
    - empty_password: True
    - groups:
        - sudo
        - www-data
  ssh_auth.present:
    - user: {{ USER }}
    {% if KEYS %}
    - names:
    {% for key in KEYS %}
      - {{ key }}
    {% endfor %}
    {% endif %}

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://configs/sshd_config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
        - pkg: openssh-server

/etc/motd:
  file.managed:
    - source: salt://configs/motd
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
