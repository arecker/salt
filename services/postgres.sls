{% set postgres = pillar.get('postgres', {}) %}

# TODO: yuck
{% if grains['os'] == 'Ubuntu' %}
{% set postgres_version = '9.3' %}
{% else %}
{% set postgres_version = '9.4' %}
{% endif %}


{% if postgres %}
postgres-pkgs:
  pkg.installed:
    - pkgs:
        - postgresql-{{ postgres_version }}
        - postgresql-contrib-{{ postgres_version }}
        - postgresql-server-dev-{{ postgres_version }}
        - python-dev

postgres-access:
  file.managed:
    - name: /etc/postgresql/{{ postgres_version }}/main/pg_hba.conf
    - source: salt://services/files/pghba.conf
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
        - pkg: postgres-pkgs

postgres-config:
  file.managed:
    - name: /etc/postgresql/{{ postgres_version }}/main/postgresql.conf
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
