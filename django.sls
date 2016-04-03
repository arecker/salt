{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% set USER = pillar.get('user') %}
{% for project, info in DJANGOS.iteritems() %}
{% set python = salt['helpers.get_python_path'](USER, project, info) %}
{% set settings = salt['helpers.get_settings_path'](project, info) %}
{% set settings_mod = salt['helpers.get_settings_module'](project, info) %}
{% for path in ['root', 'static_root', 'media_root'] %}
{{ info.get(path) }}:
  file.directory:
    - user: {{ USER }}
    - group: www-data
    - mode: 775
    - recurse:
      - user
      - group
{% endfor %}

{{ info.get('log') }}:
  file.managed:
    - user: {{ USER }}
    - makedirs: True

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
    - file: {{ info.get('log') }}
    - id: django-{{ project }}-env-var
    - sls: virtualenv
    - sls: database

django-{{ project }}-collectstatic:
  cmd.run:
    - name: {{ python }} manage.py collectstatic --noinput
    - user: {{ USER }}
    - cwd: {{ info.get('src') }}
  require:
    - file: {{ settings }}
    - file: {{ info.get('log') }}
    - directory: {{ info.get('media_root') }}
    - directory: {{ info.get('static_root') }}
    - id: django-{{ project }}-env-var
    - sls: virtualenv

django-{{ project }}-mail-send:
  cron.present:
    - user: {{ USER }}
    - minute: '*/1'
    - name: cd {{ info.get('src') }} && {{ python }} manage.py send_mail >> {{ info.get('log') }} 2>&1

django-{{ project }}-mail-retry:
  cron.presnt:
    - user: {{ USER }}
    - minute: '*/20'
    - name: cd {{ info.get('src') }} && {{ python }} manage.py retry_deferred >> {{ info.get('log') }} 2>&1

django-{{ project }}-mail-purge:
  cron.present:
    - user: {{ USER }}
    - minute: '*/5'
    - name: cd {{ info.get('src') }} && {{ python }} manage.py purge_mail_log 7 >> {{ info.get('log') }} 2>&1
{% endfor %}
