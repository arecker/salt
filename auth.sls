{% set USER = pillar.get('user') %}
{% set KEYS = pillar.get('keys') %}
users:
  pkg.installed:
    - pkgs:
      - sudo
  user.present:
    - name: {{ USER }}
    - groups:
        - sudo
        - www-data
  ssh_auth.present:
    - user: {{ USER }}
    {% if KEYS %}
    {% for key in KEYS %}
    - names:
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

/etc/motd:
  file.managed:
    - text: "
| This machine is managed by salt.
| https://github.com/arecker/salt
"
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
