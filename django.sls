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

/home/{{ USER }}/bin/{{ project }}_mail.sh:
  file.managed:
    - user: {{ USER }}
    - mode: 755
    - template: jinja
    - source: salt://configs/mailer.sh
    - makedirs: True
    - context:
        PYTHON: {{ python }}
        SRC: {{ info.get('src') }}
        SETTINGS: {{ settings_mod }}
        LOG: {{ info.get('log') }}
        PROJECT: {{ project }}

django-{{ project }}-mail-send:
  cron.present:
    - user: {{ USER }}
    - minute: '*/1'
    - name: /home/{{ USER }}/bin/{{ project }}_mail.sh send_mail
    - require:
        - file: /home/{{ USER }}/bin/{{ project }}_mail.sh

django-{{ project }}-mail-retry:
  cron.present:
    - user: {{ USER }}
    - minute: '*/20'
    - name: /home/{{ USER }}/bin/{{ project }}_mail.sh retry_deferred
    - require:
        - file: /home/{{ USER }}/bin/{{ project }}_mail.sh
{% endfor %}
