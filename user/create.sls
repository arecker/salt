{% for user, info in salt['pillar.get']('user', {}).iteritems() %}
user-{{ user }}:
  user.present:
    - name: {{ user }}
    - fullname: {{ info.get('fullname', user) }}
    - password: {{ info['password'] }}
    - shell: {{ info.get('shell', '/bin/bash') }}
    - groups: {{ info.get('groups', []) }}
{% endfor %}
