users-packages:
  pkg.installed:
    - pkgs:
        - bash
        - sudo

{% for user, info in pillar['users'].iteritems() %}
users-{{ user }}:
  user.present:
    - name: {{ user }}
    - password: {{ info.get('password') }}
    - fullname: {{ info.get('name', '') }}
    - shell: /bin/bash
{% endfor %}


{% for user, info in pillar['users'].iteritems() %}
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
