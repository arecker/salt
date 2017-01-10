{% for container, info in salt['pillar.get']('containers', {}).iteritems() %}
{% set build = info.get('build', None) %}
{% set image = info['image'] %}
docker-image-{{ container }}-{{ image }}:
  dockerng.image_present:
    - name: {{ image }}
    {% if build %}
    - build: {{ build }}
    {% endif %}
{% endfor %}
