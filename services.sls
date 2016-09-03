docker-installed:
  cmd.run:
    - name: docker -v

docker-redis-pulled:
  cmd.run:
    - name: docker pull redis
    - require:
        - cmd: docker-installed

docker-redis-running:
  cmd.run:
    - name: docker run --name redis-instance -d redis redis-server --appendonly yes
    - unless: docker inspect --format={{ '"{{ .State.Running }}"' }} redis-instance
    - require:
        - cmd: docker-redis-pulled

{% set postgres = pillar.get('postgres', None) %}
{% if postgres %}
docker-postgres-pulled:
  cmd.run:
    - name: docker pull postgres
    - require:
        - cmd: docker-installed

docker-postgres-running:
  cmd.run:
    - name: docker run --name postgres-instance -e POSTGRES_PASSWORD={{ postgres }} -d postgres
    - unless: docker inspect --format={{ '"{{ .State.Running }}"' }} postgres-instance
    - require:
        - cmd: docker-postgres-pulled
{% endif %}

{% for container, info in pillar.get('containers', {}).iteritems() %}
docker-{{ container }}-pulled:
  cmd.run:
    - name: docker pull {{ info['image'] }}
    - require:
        - cmd: docker-installed

docker-{{ container }}-stopped:
  cmd.run:
    - name: docker stop {{ container }} && docker rm {{ container }}
    - onlyif: docker inspect --format={{ '"{{ .State.Running }}"' }} {{ container }}
    - require:
        - cmd: docker-{{ container }}-pulled

docker-{{ container }}-running:
  cmd.run:
    - name: |
        docker run --name {{ container }} \
            {% if info.get('volumes') %} -v {{  info['volumes'] }}{% endif %} \
            {% if info.get('ports') %} -p {{  info['ports'] }}{% endif %} \
            -d {{ info['image'] }}
    - unless: docker inspect --format={{ '"{{ .State.Running }}"' }} {{ container }}
    - require:
        - cmd: docker-{{ container }}-stopped
{% endfor %}
