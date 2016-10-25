{% set nginx = pillar.get('nginx', {}) %}

{% if nginx %}
nginx-package:
  pkg.installed:
    - name: nginx

nginx-config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://web/files/nginx.conf
    - user: root
    - group: root
    - mode: 640
    - require:
        - pkg: nginx-package

nginx-sites-enabled:
  file.managed:
    - name: /etc/nginx/sites-enabled/default
    - source: salt://files/web/nginx-sites.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - context:
        sites: {{ nginx }}
    - require:
        - pkg: nginx-package
        - file: default-www

nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
        - pkg: nginx-package
    - watch:
        - file: nginx-config
{% endif %}
