{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% for project, info in DJANGOS.iteritems() %}
web-django-{{ project }}-hostname:
  host.present:
    - ip: 127.0.0.1
    - name: {{ info.get('host') }}
{% endfor %}
