postgresql-packages:
  pkg.installed:
    - pkgs:
        - postgresql

postgresql-config:
  cmd.script:
    - name: salt://services/files/configure_postgresql.sh
    - require:
        - pkg: postgresql-packages

postgresql-service:
  service.running:
    - name: postgresql
    - enable: True
    - require:
        - pkg: postgresql-packages
        - cmd: postgresql-config
    - watch:
        - pkg: postgresql-packages

{% set djangos = pillar.get('djangos', {}) %}
{% for project, info in djangos.iteritems() %}
postgresql-{{ project }}-database:
  postgres_user.present:
    - name: {{ info.get('db_user') }}
    - db_password: {{ info.get('db_pass') }}
  postgres_database.present:
    - name: {{ info.get('db_name') }}
    - owner: {{ info.get('db_user') }}
    - require:
        - postgres_user: postgresql-{{ project }}-database
  require:
    - service: postgresql-service
    - pkg: postgresql-packages
{% endfor %}
