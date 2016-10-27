{% set users = pillar.get('users', {}) %}

users-packages:
  pkg.installed:
    - pkgs:
      - bash
      - sudo
      - zsh

{% for user, info in users.iteritems() %}

{% set ssh = info.get('ssh', {}) %}
{% set ssh_present = ssh.get('present', []) %}
{% set ssh_absent = ssh.get('absent', []) %}

users-{{ user }}:
  user.present:
    - name: {{ user }}
    - fullname: {{ info.get('fullname', user) }}
    - shell: {{ info.get('shell', '/bin/bash') }}
      {% if info.get('sudo', False) %}
    - groups:
        - sudo
      {% endif %}
    - require:
        - pkg: users-packages

{% if ssh_present %}
users-{{ user }}-ssh-present:
  ssh_auth.present:
    - user: {{ user }}
    - names:
        {% for key in ssh_present %}
        - {{ key }}
        {% endfor %}
    - require:
        - user: users-{{ user }}
{% endif %}

{% if ssh_absent %}
users-{{ user }}-ssh-absent:
  ssh_auth.absent:
    - user: {{ user }}
    - names:
        {% for key in ssh_absent %}
        - {{ key }}
        {% endfor %}
    - require:
        - user: users-{{ user }}
{% endif %}

{% endfor %}
