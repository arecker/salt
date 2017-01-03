{% for container, info in salt['pillar.get']('docker', {}).iteritems() %}
docker-{{ container }}:
  dockerng.running:
    - name: {{ container }}
    - image: {{ info['image'] }}
    - binds: {{ info.get('binds', []) }}
    - environment: {{ info.get('environment', {}) }}
    - links: {{ info.get('links', []) }}
    - ports: {{ info.get('ports', []) }}
    {% if info.get('cmd', False) %}- cmd: {{ info.get('cmd', None) }}{% endif %}
{% endfor %}
