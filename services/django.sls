django-packages:
  pkg.installed:
    - pkgs:
        - gcc
        - git
        - libjpeg-dev
        - libpq-dev
        - python
        - python-dev
        - python-imaging
        - python-psycopg2
        - python-virtualenv
        - zlib1g
        - zlib1g-dev

{% set djangos = pillar.get('djangos', {}) %}
{% for project, info in djangos.iteritems() %}
{% set target = info.get('src', '/home/' + info.get('user') + '/git/' + project) %}
{% set venv_root = info.get('venv_root', '/home/' + info.get('user') + '/.virtualenvs/' + project) %}
{% set python = venv_root + '/bin/python' %}
{% set manage = python + ' ' + target + '/manage.py' %}
django-{{ project }}-git:
  git.latest:
    - name: {{ info.get('git') }}
    - branch: {{ info.get('git_branch', 'master') }}
    - target: {{ target }}
    - user: {{ info.get('user') }}
    - force_reset: True
    - require:
        - pkg: django-packages

django-{{ project }}-log:
  file.managed:
    - name: {{ info.get('log') }}
    - user: {{ info.get('user') }}
    - makedirs: True

django-{{ project }}-virtualenv:
  virtualenv.managed:
    - name: {{ venv_root }}
    - user: {{ info.get('user') }}
    - system_site_packages: False
    - requirements: {{ info.get('requirements', target + '/requirements.txt' )}}
    - require:
        - pkg: django-packages

django-{{ project }}-virtualenv-prod:
  virtualenv.managed:
    - name: {{ venv_root }}
    - user: {{ info.get('user') }}
    - system_site_packages: False
    - requirements: salt://services/files/requirements.txt
    - require:
        - pkg: django-packages

django-{{ project }}-prod-settings:
  file.managed:
    - name: {{ target + '/' + project + '/prod_settings.py' }}
    - source: salt://services/files/django_settings.py
    - user: {{ info.get('user') }}
    - template: jinja
    - context:
        SECRET_KEY: {{ info.get('secret') }}
        HOST: {{ info.get('host') }}
        DB_NAME: {{ info.get('db_name') }}
        DB_USER: {{ info.get('db_user') }}
        DB_PASS: {{ info.get('db_pass') }}
        STATIC_ROOT: {{ info.get('static') + '/static' }}
        MEDIA_ROOT: {{ info.get('static') + '/media' }}
        LOG_FILE: {{ info.get('log') }}
        REDIS_CACHE_NO: {{ info.get('redis_cache_no') }}
        REDIS_BROKER_NO: {{ info.get('redis_broker_no') }}
        EMAIL_HOST: {{ info.get('email_host') }}
        EMAIL_USER: {{ info.get('email_user') }}
        EMAIL_PASS: {{ info.get('email_pass') }}
        EMAIL_PORT: {{ info.get('email_port') }}
    - require:
        - git: django-{{ project }}-git

django-{{ project }}-settings:
  file.append:
    - name: {{ target + '/' + project + '/settings.py' }}
    - text: "
try:
    from prod_settings import *
except ImportError:
    pass"
    - require:
        - git: django-{{ project }}-git

django-{{ project }}-migrate:
  cmd.run:
    - name: {{ manage  + ' migrate' }}
    - require:
        - file: django-{{ project }}-prod-settings
        - virtualenv: django-{{ project }}-virtualenv
        - virtualenv: django-{{ project }}-virtualenv-prod

django-{{ project }}-collectstatic:
  cmd.run:
    - name: {{ manage + ' collectstatic --no-input' }}
    - require:
        - file: django-{{ project }}-prod-settings
        - virtualenv: django-{{ project }}-virtualenv
        - virtualenv: django-{{ project }}-virtualenv-prod

django-{{ project }}-gunicorn:
  file.managed:
    - name: {{ '/etc/systemd/system/' + project + '-gunicorn.service' }}
    - source: salt://services/files/gunicorn.service
    - template: jinja
    - user: root
    - context:
        PROJECT: {{ project }}
        USER: {{ info.get('user') }}
        WORKING_DIR: {{ target }}
        WSGI: {{ project + '.wsgi' }}
        LOG: {{ info.get('log') }}
        WORKERS: {{ info.get('workers', '3') }}
        GUNICORN: {{ venv_root + '/bin/gunicorn' }}
        PORT: {{ info.get('port') }}
  service.running:
    - name: {{ project + '-gunicorn.service' }}
    - enable: True
    - require:
        - virtualenv: django-{{ project }}-virtualenv
        - virtualenv: django-{{ project }}-virtualenv-prod
        - file: django-{{ project }}-log
        - file: django-{{ project }}-prod-settings
        - file: django-{{ project }}-settings
        - file: django-{{ project }}-gunicorn

django-{{ project }}-celery:
  file.managed:
    - name: {{ '/etc/systemd/system/' + project + '-celery.service' }}
    - source: salt://services/files/celery.service
    - template: jinja
    - user: root
    - context:
        PROJECT: {{ project }}
        USER: {{ info.get('user') }}
        WORKING_DIR: {{ target }}
        LOG: {{ info.get('log') }}
        CELERY: {{ venv_root + '/bin/celery' }}
  service.running:
    - name: {{ project + '-celery.service' }}
    - enable: True
    - require:
        - virtualenv: django-{{ project }}-virtualenv
        - virtualenv: django-{{ project }}-virtualenv-prod
        - file: django-{{ project }}-log
        - file: django-{{ project }}-prod-settings
        - file: django-{{ project }}-settings
        - file: django-{{ project }}-celery
{% endfor %}
