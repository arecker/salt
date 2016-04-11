{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
web-django-packages:
  pkg.installed:
    - pkgs:
      - git
      - gcc
      - libjpeg-dev
      - python-dev
      - python-virtualenv
      - python-imaging
      - libjpeg-dev
      - zlib1g
      - zlib1g-dev
      - postgresql
      - postgresql-contrib
      - libpq-dev
      - python-psycopg2

web-django-postgres-service:
  service.running:
    - name: postgresql
    - enable: True
    - require:
        - pkg: web-django-packages

{% for project, info in DJANGOS.iteritems() %}
{% set python = salt['utils.join'](info.get('venv'), 'bin/python') %}
{% set settings = salt['utils.join'](info.get('src'), project, 'settings/prod.py') %}
web-django-{{ project }}-git:
  git.latest:
    - name: {{ info.get('git') }}
    - target: {{ info.get('src') }}
    - user: {{ info.get('user') }}
    - require:
        - pkg: web-django-packages

web-django-{{ project }}-virtualenv-repo:
  virtualenv.managed:
    - name: {{ info.get('venv') }}
    - user: {{ info.get('user') }}
    - cwd: {{ info.get('src') }}
    - system_site_packages: False
    - requirements: {{ info.get('requirements') }}
    - require:
        - git: web-django-{{ project }}-git
        - pkg: web-django-packages

web-django-{{ project }}-virtualenv-prod:
  virtualenv.managed:
    - name: {{ info.get('venv') }}
    - user: {{ info.get('user') }}
    - system_site_packages: False
    - requirements: salt://web/files/requirements.txt
    - require:
        - virtualenv: web-django-{{ project }}-virtualenv-repo
        - pkg: web-django-packages

web-django-{{ project }}-database-user:
  postgres_user.present:
    - name: {{ info.get('db_user') }}
    - password: {{ info.get('db_pass') }}
    - require:
        - service: web-django-postgres-service

web-django-{{ project }}-database:
  postgres_database.present:
    - name: {{ info.get('db_name') }}
    - owner: {{ info.get('db_user') }}
    - require:
        - postgres_user: web-django-{{ project }}-database-user
        - service: web-django-postgres-service

web-django-{{ project }}-log:
  file.managed:
    - name: {{ info.get('log') }}
    - user: {{ info.get('user') }}
    - group: {{ info.get('user') }}
    - makedirs: True
    - mode: 770

web-django-{{ project }}-settings:
  file.managed:
    - name: {{ settings }}
    - source: salt://web/files/settings.py
    - template: jinja
    - user: {{ info.get('user') }}
    - context:
        project: {{ project }}
        info: {{ info }}

web-django-{{ project }}-migrate:
  cmd.run:
    - name: {{ python }} manage.py migrate
    - cwd: {{ info.get('src') }}
    - env:
        - DJANGO_SETTINGS_MODULE: {{ project }}.settings.prod
    - require:
        - postgres_user: web-django-{{ project }}-database-user
        - postgres_database: web-django-{{ project }}-database
        - virtualenv: web-django-{{ project }}-virtualenv-repo
        - virtualenv: web-django-{{ project }}-virtualenv-prod
        - pkg: web-django-packages
        - service: web-django-postgres-service
        - file: web-django-{{ project }}-log
{% endfor %}
