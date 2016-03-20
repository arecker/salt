{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% if DJANGOS %}
database-django-deps:
  pkg.installed:
    - pkgs:
      - postgresql
      - postgresql-contrib
      - libpq-dev
      - python-psycopg2

{% for project, info in DJANGOS.iteritems() %}
database-django-{{ project }}:
  postgres_user.present:
    - name: {{ info.get('db_user') }}
    - password: {{ info.get('db_pass') }}
  postgres_database.present:
    - name: {{ info.get('db_name') }}
    - owner: {{ info.get('db_user') }}
{% endfor %}
{% endif %}
