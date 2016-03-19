{% set STATICS = salt['pillar.get']('statics', {}) %}
{% if STATICS %}
static_hosts:
  host.present:
    - ip: 127.0.0.1
    {% for site, info in STATICS.iteritems() %}
    - names:
      - {{ info.get('server_name') }}
    {% endfor %}
{% endif %}
