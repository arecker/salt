docker-installed:
  cmd.run:
    - name: docker -v

docker-redis-pulled:
  cmd.run:
    - name: docker pull redis
    - require:
        - cmd: docker-installed

docker-redis-upgraded:
  cmd.run:
    - name: |
        docker create --volumes-from redis-instance --name redis-instance-tmp redis --appendonly yes &&
        docker stop redis-instance &&
        docker rm redis-instance &&
        docker rename redis-instance-tmp redis-instance &&
        docker start redis-instance
    - onlyif: docker inspect --format="{{ '{{ .State.Running }}' }}" redis-instance
    - require:
        - cmd: docker-redis-pulled

docker-redis-running:
  cmd.run:
    - name: docker run --name redis-instance -d redis --appendonly yes
    - unless: docker inspect --format="{{ '{{ .State.Running }}' }}" redis-instance
    - require:
        - cmd: docker-redis-pulled

{% set pgpass = pillar.get('postgres') %}
{% if pgpass %}
docker-postgres-pulled:
  cmd.run:
    - name: docker pull postgres
    - require:
        - cmd: docker-installed

docker-postgres-upgraded:
  cmd.run:
    - name: |
        docker create --volumes-from postgres-instance --restart="always" \
            --name postgres-instance-tmp -e POSTGRES_PASSWORD={{ pgpass }} postgres &&
        docker stop postgres-instance &&
        docker rm postgres-instance &&
        docker rename postgres-instance-tmp postgres-instance &&
        docker start postgres-instance
    - onlyif: docker inspect --format="{{ '{{ .State.Running }}' }}" postgres-instance
    - require:
        - cmd: docker-postgres-pulled

docker-postgres-running:
  cmd.run:
    - name: docker run --restart="always" --name postgres-instance -e POSTGRES_PASSWORD={{ pgpass }} -d postgres
    - unless: docker inspect --format="{{ '{{ .State.Running }}' }}" postgres-instance
    - require:
        - cmd: docker-postgres-pulled
{% endif %}

{% for container, info in pillar.get('containers', {}).iteritems() %}
docker-{{ container }}-pulled:
  cmd.run:
    - name: docker pull {{ info['image'] }}
    - require:
        - cmd: docker-installed

docker-{{ container }}-upgraded:
  cmd.run:
    - name: |
        docker create --volumes-from {{ container }} --name {{ container }}-tmp --restart="always" \
               {% for k, v in info.get('environment', {}).iteritems() %} -e {{ k }}={{ v }} {% endfor %} \
               {% if info.get('volumes') %} -v {{ info['volumes'] }} {% endif %} \
               {% if info.get('ports') %} -p {{ info['ports'] }} {% endif %} \
               {{ info['image'] }}
        docker stop {{ container }}
        docker rm {{ container }}
        docker rename {{ container }}-tmp {{ container }}
        docker start {{ container }}
    - onlyif: docker inspect --format="{{ '{{ .State.Running }}' }}" {{ container }}
    - require:
        - cmd: docker-{{ container }}-pulled

docker-{{ container }}-running:
  cmd.run:
    - name: |
        docker run --name {{ container }} --restart="always" -d \
               {% for k, v in info.get('environment', {}).iteritems() %} -e {{ k }}={{ v }} {% endfor %} \
               {% if info.get('volumes') %} -v {{ info['volumes'] }} {% endif %} \
               {% if info.get('ports') %} -p {{ info['ports'] }} {% endif %} \
               {{ info['image'] }}
    - unless: docker inspect --format="{{ '{{ .State.Running }}' }}" {{ container }}
    - require:
        - cmd: docker-{{ container }}-pulled
{% endfor %}
