{% from "postgres/map.jinja" import postgres with context %}

{% if grains['oscodename'] == 'trusty' %}
postgres-ppa:
  pkgrepo.managed:
    - name: deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main
    - key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc
    - require_in:
      - pkg: postgres-packages
{% endif %}

postgres-packages:
  pkg.installed:
    - pkgs: {{ postgres.packages }}

postgres-access:
  file.managed:
    - name: {{ postgres.access_config }}
    - source: salt://postgres/files/pghba.conf
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
        - pkg: postgres-packages

postgres-config:
  file.managed:
    - name: {{ postgres.config }}
    - source: salt://postgres/files/pg.conf
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
        - pkg: postgres-packages

postgres-service:
  service.running:
    - name: postgresql
    - enable: true
    - watch:
        - pkg: postgres-packages
        - file: postgres-access
        - file: postgres-config
    - require:
        - pkg: postgres-packages
        - file: postgres-access
        - file: postgres-config

{% for db, info in salt['pillar.get']('postgres', {}).iteritems() %}
postgres-{{ db }}-user:
  cmd.run:
    - name: psql -c "CREATE USER {{ info['user'] }} WITH PASSWORD '{{ info['password'] }}';"
    - runas: postgres
    - unless: psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='{{ info['user'] }}'" | grep -q 1
    - require:
        - service: postgres-service

postgres-{{ db }}-db:
  cmd.run:
    - name: psql -c "CREATE DATABASE {{ db }};"
    - runas: postgres
    - unless: psql -tAc "SELECT 1 FROM pg_database WHERE datname='{{ db }}'" | grep -q 1
    - require:
        - service: postgres-service

postgres-{{ db }}-grants:
  cmd.run:
    - name: psql -c "GRANT ALL PRIVILEGES ON DATABASE {{ db }} TO {{ info['user'] }};"
    - runas: postgres
    - onchanges:
        - cmd: postgres-{{ db }}-user
        - cmd: postgres-{{ db }}-db
{% endfor %}
