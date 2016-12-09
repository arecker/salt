users-packages:
  pkg.installed:
    - pkgs:
        - bash
        - sudo

{% for user, info in salt['pillar.get']('user', {}).iteritems() %}
users-{{ user }}:
  user.present:
    - name: {{ user }}
    - fullname: {{ info.get('fullname', user) }}
    - shell: {{ info.get('shell', '/bin/bash') }}
    - groups: {{ info.get('groups', []) }}
    - require:
        - pkg: users-packages
{% endfor %}
