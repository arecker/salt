locale-packages:
  pkg.installed:
    - name: locales

locales-en-us:
  locale.present:
    - name: en_US.UTF-8
    - require:
        - pkg: locale-packages

locales-default:
  locale.system:
    - name: en_US.UTF-8
    - require:
        - pkg: locale-packages
        - locale: locales-en-us

users-packages:
  pkg.installed:
    - pkgs:
        - bash
        - sudo

{% set users = pillar.get('users', {}) %}
{% for user, info in users.iteritems() %}
users-{{ user }}:
  user.present:
    - name: {{ user }}
    - password: {{ info.get('password') }}
    - fullname: {{ info.get('name', None) }}
    - shell: /bin/bash
    {% if info.get('sudo', False) %}
    - groups:
        - sudo
    {% endif %}
    - require:
        - pkg: users-packages

users-key-{{ user }}:
  {% set keys = info.get('keys', []) %}
  {% if keys %}
  ssh_auth.present:
    - user: {{ user }}
    - names:
      {% for key in keys %}
      - {{ key }}
      {% endfor %}
    - require:
        - user: users-{{ user }}
  {% endif %}
{% endfor %}

{% set ssh = pillar.get('ssh', None) %}
{% if ssh %}
ssh-packages:
  pkg.installed:
    - name: openssh-server

ssh-config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://files/sshd.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
        - pkg: ssh-packages
    - context:
        PORT: {{ ssh }}

ssh-motd:
  file.managed:
    - name: /etc/motd
    - source: salt://files/motd.txt
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
