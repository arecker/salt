{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
django-packages:
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

django-postgres-service:
  service.running:
    - name: postgresql
    - enable: True
    - require:
        - pkg: django-packages

{% for project, info in DJANGOS.iteritems() %}
{% set python = salt['utils.join'](info.get('venv'), 'bin/python') %}
{% set settings = salt['utils.join'](info.get('src'), project, 'settings/prod.py') %}
django-{{ project }}-git:
  git.latest:
    - name: {{ info.get('git') }}
    - target: {{ info.get('src') }}
    - user: {{ info.get('user') }}
    - require:
        - pkg: django-packages

django-{{ project }}-virtualenv-repo:
  virtualenv.managed:
    - name: {{ info.get('venv') }}
    - user: {{ info.get('user') }}
    - cwd: {{ info.get('src') }}
    - system_site_packages: False
    - requirements: {{ info.get('requirements') }}
    - require:
        - git: django-{{ project }}-git
        - pkg: django-packages

django-{{ project }}-virtualenv-prod:
  virtualenv.managed:
    - name: {{ info.get('venv') }}
    - user: {{ info.get('user') }}
    - system_site_packages: False
    - requirements: salt://web/files/requirements.txt
    - require:
        - virtualenv: django-{{ project }}-virtualenv-repo
        - pkg: django-packages

django-{{ project }}-database-user:
  postgres_user.present:
    - name: {{ info.get('db_user') }}
    - password: {{ info.get('db_pass') }}
    - require:
        - service: django-postgres-service

django-{{ project }}-database:
  postgres_database.present:
    - name: {{ info.get('db_name') }}
    - owner: {{ info.get('db_user') }}
    - require:
        - postgres_user: django-{{ project }}-database-user
        - service: django-postgres-service

django-{{ project }}-log:
  file.managed:
    - name: {{ info.get('log') }}
    - user: {{ info.get('user') }}
    - group: {{ info.get('user') }}
    - makedirs: True
    - mode: 770

django-{{ project }}-settings:
  file.managed:
    - name: {{ settings }}
    - source: salt://web/files/settings.py
    - template: jinja
    - user: {{ info.get('user') }}
    - context:
        project: {{ project }}
        info: {{ info }}
    - require:
        - git: web-django-{{ project }}-git

django-{{ project }}-migrate:
  cmd.run:
    - name: {{ python }} manage.py migrate
    - cwd: {{ info.get('src') }}
    - env:
        - DJANGO_SETTINGS_MODULE: {{ project }}.settings.prod
    - require:
        - postgres_user: django-{{ project }}-database-user
        - postgres_database: django-{{ project }}-database
        - virtualenv: django-{{ project }}-virtualenv-repo
        - virtualenv: django-{{ project }}-virtualenv-prod
        - pkg: django-packages
        - service: django-postgres-service
        - file: django-{{ project }}-log
{% endfor %}
