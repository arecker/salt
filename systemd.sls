{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% set USER = pillar.get('user') %}
{% for project, info in DJANGOS.iteritems() %}
{% set service = salt['helpers.get_service'](project, info) %}
{% set service_no_ext = salt['helpers.get_service'](project, info, chop=True) %}
{% set service_path = salt['helpers.get_service_path'](project, info) %}
{% set wsgi_mod =  salt['helpers.get_wsgi_module'](project, info) %}
{% set gunicorn_path = salt['helpers.get_gunicorn_path'](USER, project, info) %}
{{ service_path }}:
  file.managed:
    - source: salt://configs/systemd.service.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - context:
        description: {{ project }}
        user: {{ USER }}
        working_dir: {{ info['src'] }}
        port: {{ info['port'] }}
        log: {{ info['log'] }}
        workers: {{ info.get('workers', 3) }}
        wsgi: {{ wsgi_mod }}
        gunicorn: {{ gunicorn_path }}

{{ service }}:
  service.running:
    - name: {{ service_no_ext }}
    - enable: True
    - reload: True
    - require:
      - file: {{ service_path }}
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: {{ service_path }}
{% endfor %}
