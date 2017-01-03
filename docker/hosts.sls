{% for container, info in salt['pillar.get']('docker', {}).iteritems() %}
{% set environment = info.get('environment', {}) %}
{% set host = environment.get('VIRTUAL_HOST', None) %}
{% if host %}
docker-host-{{ container }}-{{ host }}:
  host.present:
    - name: {{ host }}
    - ip: 127.0.0.1
{% endif %}
{% endfor %}
