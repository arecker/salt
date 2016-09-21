{% set databases = pillar.get('databases', {}) %}
{% if databases %}
db-installed:
  pkg.installed:
    - pkgs:
        - postgresql-9.4
        - postgresql-contrib-9.4
        - postgresql-server-dev-9.4
        - python-dev

db-access:
  file.managed:
    - name: /etc/postgresql/9.4/main/pg_hba.conf
    - source: salt://files/pghba.conf
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
        - pkg: db-installed

db-config:
  file.managed:
    - name: /etc/postgresql/9.4/main/postgresql.conf
    - source: salt://files/pg.conf
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
        - pkg: db-installed

db-service:
  service.running:
    - name: postgresql
    - enable: true
    - watch:
        - pkg: db-installed
        - file: db-access
        - file: db-config
    - require:
        - pkg: db-installed
        - file: db-access
        - file: db-config

{% for db, info in databases.iteritems() %}
db-{{ db }}-user:
  postgres_user.present:
    - name: {{ info['user'] }}
    - password: {{ info['password'] }}
    - require:
        - pkg: db-installed
        - service: db-service

db-{{ db }}-db:
  postgres_database.present:
    - name: {{ db }}
    - owner: {{ info['user'] }}
{% endfor %}
{% endif %}

docker-installed:
  cmd.run:
    - name: docker -v
    - require:
        - pkg: db-installed
        - service: db-service
        {% for db, info in databases.iteritems() %}
        - postgres_user: db-{{ db }}-user
        - postgres_database: db-{{ db }}-db
        {% endfor %}

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
            {% for env in info.get('env', []) %} -e {{ env }} {% endfor %} \
            {% for link in info.get('links', []) %} --link {{ link }} {% endfor %} \
            {% for host in info.get('hosts', []) %} --add-host {{ host }} {% endfor %} \
            -d --restart always {{ info['image'] }}
    - unless: docker inspect --format={{ '"{{ .State.Running }}"' }} {{ container }}
    - require:
        - cmd: docker-{{ container }}-stopped
{% endfor %}
