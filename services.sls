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
    - name: |
        docker run --name redis-instance -d redis redis-server --appendonly yes
        docker start redis-instance
    - unless: docker inspect --format={{ '"{{ .State.Running }}"' }} redis-instance
    - require:
        - cmd: docker-redis-pulled

docker-redis-upgraded:
  cmd.run:
    - name: |
       docker create --volumes-from redis-instance --name redis-instance-tmp redis
       docker stop redis-instance
       docker rm redis-instance
       docker rename redis-instance-tmp redis-instance
       docker start redis-instance
    - onlyif: docker inspect --format={{ '"{{ .State.Running }}"' }} redis-instance
    - require:
        - cmd: docker-redis-running

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
        - cmd: docker-redis-pulled

docker-postgres-upgraded:
  cmd.run:
    - name: |
       docker create --volumes-from postgres-instance --name postgres-instance-tmp postgres
       docker stop postgres-instance
       docker rm postgres-instance
       docker rename postgres-instance-tmp postgres-instance
       docker start postgres-instance
    - onlyif: docker inspect --format={{ '"{{ .State.Running }}"' }} postgres-instance
    - require:
        - cmd: docker-postgres-running
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
