{% set STATICS = salt['pillar.get']('statics', {}) %}
{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% if STATICS %}
static_hosts:
  host.present:
    - ip: 127.0.0.1
    - names:
      {% for site, info in STATICS.iteritems() %}
      - {{ info.get('server_name', 'localhost') }}
      {% endfor %}
{% endif %}
{% if DJANGOS %}
django_hosts:
  host.present:
    - ip: 127.0.0.1
    - names:
    {% for project, info in DJANGOS.iteritems() %}
      - {{ info.get('server_name', 'localhost') }}
    {% endfor %}
{% endif %}
