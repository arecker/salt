postgresql-packages:
  pkg.installed:
    - pkgs:
        - postgresql-9.3

postgresql-config-tcp:
  file.replace:
    - name: /etc/postgresql/9.3/main/postgresql.conf
    - pattern: "listen_addresses='localhost'"
    - repl: "listen_addresses='localhost 172.17.0.1/16'"

postgresql-config-auth:
  file.append:
    - name: /etc/postgresql/9.3/main/pg_hba.conf
    - text: host all all 172.17.0.1/16 trust

postgresql-service:
  service.running:
    - name: postgresql
    - enable: True
    - require:
        - pkg: postgresql-packages
        - file: postgresql-config-tcp
        - file: postgresql-config-auth
    - watch:
        - pkg: postgresql-packages
        - file: postgresql-config-tcp
        - file: postgresql-config-auth

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
