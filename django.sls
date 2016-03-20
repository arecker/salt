{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% set USER = pillar.get('user') %}
{% for project, info in DJANGOS.iteritems() %}
{% set env_root = info.get('virtualenv', '/home/' + USER + '/.virtualenvs/' + project) %}
{% set python = env_root + '/bin/python' %}
{% set default_settings = info.get('src') + project + '/settings/prod.py' %}
{% set settings = info.get('prod_settings', default_settings) %}
{% set default_settings_mod = project + '.settings.prod' %}
{% set settings_mod = info.get('prod_settings_module', default_settings_mod) %}
{{ info.get('root') }}:
  file.directory:
    - user: {{ USER }}
    - group: www-data
    - mode: 775
    - recurse:
      - user
      - group

{{ info.get('static_root') }}:
  file.directory:
    - user: {{ USER }}
    - group: www-data
    - mode: 775
    - recurse:
      - user
      - group

{{ info.get('media_root') }}:
  file.directory:
    - user: {{ USER }}
    - group: www-data
    - mode: 775
    - recurse:
      - user
      - group

django-{{ project }}-env-var:
  environ.setenv:
    - name: DJANGO_SETTINGS_MODULE
    - value: {{ settings_mod }}

django-{{ project }}-settings:
  file.managed:
    - name: {{ settings }}
    - source: salt://configs/settings.py
    - template: jinja
    - user: {{ USER }}
    - context:
        INFO: {{ info }}
  require:
    - id: django-{{ project }}-env-var

django-{{ project }}-migrate:
  cmd.run:
    - name: {{ python }} manage.py migrate
    - user: {{ USER }}
    - cwd: {{ info.get('src') }}
  require:
    - file: {{ settings }}
    - id: django-{{ project }}-env-var

django-{{ project }}-collectstatic:
  cmd.run:
    - name: {{ python }} manage.py collectstatic --noinput
    - user: {{ USER }}
    - cwd: {{ info.get('src') }}
  require:
    - file: {{ settings }}
    - directory: {{ info.get('media_root') }}
    - directory: {{ info.get('static_root') }}
    - id: django-{{ project }}-env-var
{% endfor %}
