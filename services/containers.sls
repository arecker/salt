{% set containers = salt['pillar.get']('containers', {}) %}
{% if containers %}
container-docker-installed:
  cmd.run:
    - name: docker -v

{% for container, info in containers.iteritems() %}
{% set image = info['image'] %}
{% set volumes = info.get('volumes') %}
{% set ports = info.get('ports') %}
container-{{ container }}-pulled:
  cmd.run:
    - name: docker pull {{ image }}
    - require:
        - cmd: container-docker-installed

container-{{ container }}-stop:
  cmd.run:
    - name: docker stop {{ container }} && docker rm {{ container }}
    - onlyif: docker inspect -f {{ '{{.State.Running}}' }} {{ container }}
    - require:
        - cmd: container-{{ container }}-pulled

container-{{ container }}-running:
  cmd.run:
    - name: docker run -d --name {{ container }} --restart="always" -v {{ volumes }} -p {{ ports }} {{ image }}
    - require:
        - cmd: container-{{ container }}-stop
{% endfor %}

{% endif %}
