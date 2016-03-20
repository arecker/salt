{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% set USER = pillar.get('user') %}
{% for project, info in DJANGOS.iteritems() %}
{% set python = salt['helpers.get_python_path'](USER, project, info) %}
{% set settings = salt['helpers.get_settings_path'](project, info) %}
{% set settings_mod = salt['helpers.get_settings_module'](project, info) %}
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
