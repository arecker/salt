postgresql-packages:
  pkg.installed:
    - pkgs:
        - postgresql

postgresql-service:
  service.running:
    - name: postgresql
    - enable: True
    - require:
        - pkg: postgresql-packages
    - watch:
        - pkg: postgresql-packages

{% set djangos = pillar.get('djangos', {}) %}
{% for project, info in djangos.iteritems() %}
postgresql-{{ project }}-database:
  postgres_user.present:
    - name: {{ info.get('db_user') }}
    - pass: {{ info.get('db_pass') }}
  postgres_database.present:
    - name: {{ info.get('db_name') }}
    - owner: {{ info.get('db_user') }}
    - host: 0.0.0.0
    - require:
        - postgres_user: postgresql-{{ project }}-database
  require:
    - service: postgresql-service
    - pkg: postgresql-packages
{% endfor %}
