{% set postgres = pillar.get('postgres', {}) %}
{% if postgres %}

{% if grains['os'] == 'Ubuntu' %}
postgres-ppa:
  pkgrepo.managed:
    - name: deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main
    - key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc
{% endif %}

postgres-pkgs:
  pkg.installed:
    - pkgs:
        - postgresql-9.4
        - postgresql-contrib-9.4
        - postgresql-server-dev-9.4
        - python-dev
    {% if grains['os'] == 'Ubuntu' %}
    - require:
        - pkgrepo: postgres-ppa
    {% endif %}

postgres-access:
  file.managed:
    - name: /etc/postgresql/9.4/main/pg_hba.conf
    - source: salt://services/files/pghba.conf
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
        - pkg: postgres-pkgs

postgres-config:
  file.managed:
    - name: /etc/postgresql/9.4/main/postgresql.conf
    - source: salt://services/files/pg.conf
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
        - pkg: postgres-pkgs

postgres-service:
  service.running:
    - name: postgresql
    - enable: true
    - watch:
        - pkg: postgres-pkgs
        - file: postgres-access
        - file: postgres-config
    - require:
        - pkg: postgres-pkgs
        - file: postgres-access
        - file: postgres-config

{% for db, info in postgres.iteritems() %}
postgres-{{ db }}-user:
  postgres_user.present:
    - name: {{ info['user'] }}
    - password: {{ info['password'] }}
    - require:
        - pkg: postgres-pkgs
        - service: postgres-service

postgres-{{ db }}-db:
  postgres_database.present:
    - name: {{ db }}
    - owner: {{ info['user'] }}
    - require:
        - pkg: postgres-pkgs
        - service: postgres-service
        - postgres_user: postgres-{{ db }}-user
{% endfor %}

{% endif %}
