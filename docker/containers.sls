{% for container, info in salt['pillar.get']('docker', {}).iteritems() %}
{% set image = info['image'] %}
{% set build = info.get('build', None) %}
{% set cmd = info.get('cmd', None) %}
docker-image-{{ container }}-{{ image }}:
  dockerng.image_present:
    - name: {{ image }}
    {% if build %}
    - build: {{ build }}
    {% endif %}

docker-container-{{ container }}:
  dockerng.running:
    - name: {{ container }}
    - image: {{ image }}
    - binds: {{ info.get('binds', []) }}
    - environment: {{ info.get('environment', {}) }}
    - links: {{ info.get('links', []) }}
    - ports: {{ info.get('ports', []) }}
    {% if cmd %}
    - cmd: {{ cmd }}
    {% endif %}
    - require:
        - dockerng: docker-image-{{ container }}-{{ image }}
{% endfor %}
