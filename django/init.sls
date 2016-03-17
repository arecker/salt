include:
  - .packages
  
{% set djangos = salt['pillar.get']('djangos', {}) %}
{% for django, info in djangos.iteritems() %}
{% set root = info.get('root', '/usr/src/' + django) %}
{% set env = info.get('virtualenv', '/home/alex/.virtualenvs/' + django) %}
{% set reqs = info.get('requirements', root + '/requirements/common.txt') %}
{% if info.get('git') %}
{{ info.get('git') }}:
  git.latest:
    - target: {{ info.get('root', '/usr/src/' + django) }}
  require:
    - pkg: git
{% endif %}

{{ django }}_requirements_repo:
  virtualenv.managed:
    - name: {{ env }}
    - requirements: {{ reqs }}
{{ django }}_requirements_prod:
  virtualenv.managed:
    - name: {{ env }}
    - requirements: salt://django/requirements.txt

{{ django }}_database:
  postgres_user.present:
    - name: {{ info.get('db_user') }}
    - password: {{ info.get('db_pass') }}
  postgres_database.present:
    - name: {{ info.get('db_name') }}
    - owner: {{ info.get('db_user') }}


{{ root }}/{{ django }}/settings/prod.py:
  file:
    - managed
    - source: salt://django/templates/settings.py.jinja
    - template: jinja
    - user: alex
    - group: alex
    - mode: 755
    - context:
        project: {{ django }}
        secret_key: {{ info.get('secret_key') }}
        allowed_hosts: {{ info.get('allowed_hosts') }}
        db_user: {{ info.get('db_user') }}
        db_name: {{ info.get('db_name') }}
        db_pass: {{ info.get('db_pass') }}
        db_host: {{ info.get('db_host', '127.0.0.1') }}
        db_port: {{ info.get('db_port', '5432') }}
        static_root: {{ info.get('static_root') }}
        media_root: {{ info.get('media_root') }}
        log_path: {{ info.get('log_path') }}

{{ django }}_env_settings:
  environ.setenv:
    - name: DJANGO_SETTINGS_MODULE
    - value: {{ django }}.settings.prod

{% set manage = env + '/bin/python ' + root + '/manage.py' %}

{{ manage }} migrate:
  cmd.run

{{ manage }} collectstatic --noinput:
  cmd.run

/etc/systemd/system/{{ django }}.service:
  file:
    - managed
    - source: salt://django/templates/systemd.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - context:
        description: {{ django }}
        user: alex
        working_dir: {{ root }}
        port: {{ info.get('port') }}
        gunicorn: {{ env }}/bin/gunicorn
        wsgi: {{ django }}.wsgi
        log: {{ info.get('log_path') }}

systemctl daemon-reload:
  cmd.run

{{ django }}.service:
  service.running:
    - name: {{ django }}
    - enable: True
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: /etc/systemd/system/{{ django }}.service
{% endfor %}
