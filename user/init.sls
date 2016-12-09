user-packages:
  pkg.installed:
    - pkgs: [ bash, sudo, zsh ]

{% for user, info in salt['pillar.get']('user', {}).iteritems() %}
{% set ssh = info.get('ssh', {}) %}
{% set ssh_present = ssh.get('present', []) %}
{% set ssh_absent = ssh.get('absent', []) %}
user-{{ user }}:
  user.present:
    - name: {{ user }}
    - fullname: {{ info.get('fullname', user) }}
    - password: {{ info['password'] }}
    - shell: {{ info.get('shell', '/bin/bash') }}
    - groups: {{ info.get('groups', []) }}
    - require:
        - pkg: user-packages

{% if ssh_present %}
user-{{ user }}-ssh-present:
  ssh_auth.present:
    - user: {{ user }}
    - names: {{ ssh_present }}
    - require:
        - user: user-{{ user }}
{% endif %}

{% if ssh_absent %}
user-{{ user }}-ssh-absent:
  ssh_auth.absent:
    - user: {{ user }}
    - names: {{ ssh_absent }}
    - require:
        - user: user-{{ user }}
{% endif %}

{% endfor %}
