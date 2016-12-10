{% from "nginx/map.jinja" import nginx with context %}
nginx-package:
  pkg.installed:
    - pkgs:
        - {{ nginx.package }}

{% set sites = salt['pillar.get']('nginx', {}) %}
{% if sites.get('php', False) %}
{% endif %}

nginx-config:
  file.managed:
    - name: {{ nginx.config }}
    - source: salt://nginx/files/config.nginx
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - require:
        - pkg: nginx-package

nginx-default-page:
  file.managed:
    - name: {{ nginx.root }}/html/index.html
    - source: salt://nginx/files/default.html
    - user: {{ nginx.user }}
    - group: {{ nginx.group }}
    - makedirs: True
    - require:
        - pkg: nginx-package

nginx-default-image:
  file.managed:
    - name: {{ nginx.root }}/html/anakin.gif
    - source: salt://nginx/files/anakin.gif
    - user: {{ nginx.user }}
    - group: {{ nginx.group }}
    - makedirs: True
    - require:
        - pkg: nginx-package

nginx-service:
  service.running:
    - name: {{ nginx.service }}
    - enable: True
    - reload: True
    - watch:
        - pkg: nginx-package
        - file: nginx-config

include:
  - nginx.hosts
