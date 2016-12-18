{% for user, info in salt['pillar.get']('user', {}).iteritems() %}
{% set ssh = info.get('ssh', {}) %}
{% set ssh_present = ssh.get('present', []) %}
{% set ssh_absent = ssh.get('absent', []) %}
{% if ssh_present %}
user-{{ user }}-ssh-present:
  ssh_auth.present:
    - user: {{ user }}
    - names: {{ ssh_present }}
{% endif %}
{% if ssh_absent %}
user-{{ user }}-ssh-absent:
  ssh_auth.absent:
    - user: {{ user }}
    - names: {{ ssh_absent }}
{% endif %}
{% endfor %}
