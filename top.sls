base:
  '*':
    - locale
    - user
    {% if not salt['grains.get']('workstation', False) %}
    - ssh
    {% endif %}
    - docker
