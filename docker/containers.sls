{% for container, info in salt['pillar.get']('docker', {}).iteritems() %}
{% set image = info['image'] %}
{% set cmd = info.get('cmd', None) %}
docker-container-{{ container }}:
  dockerng.running:
    - name: {{ container }}
    - image: {{ image }}
    - binds: {{ info.get('binds', []) }}
    - environment: {{ info.get('environment', {}) }}
    - links: {{ info.get('links', []) }}
    - ports: {{ info.get('ports', []) }}
    - volumes: {{ info.get('volumes', []) }}
    {% if cmd %}
    - cmd: {{ cmd }}
    {% endif %}
{% endfor %}
