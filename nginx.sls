{% set STATICS = salt['pillar.get']('statics', {}) %}
{% set DJANGOS = salt['pillar.get']('djangos', {}) %}

/var/www:
  file.directory:
    - user: www-data
    - group: www-data
    - recurse:
      - user
      - group

nginx:
  pkg.installed: []
  service.running:
    - enable: true
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-enabled/default

/etc/nginx/nginx.conf:
  file:
    - managed
    - source: salt://configs/nginx.conf
    - user: root
    - group: root
    - mode: 640

/etc/nginx/sites-enabled/default:
  file:
    - managed
    - source: salt://configs/nginx_default.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - context:
        STATICS: {{ STATICS }}
        DJANGOS: {{ DJANGOS }}

/var/www/html/index.html:
  file:
    - managed
    - source: salt://configs/default.html
    - user: www-data
    - group: www-data
    - mode: 775
