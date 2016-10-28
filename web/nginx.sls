{% set nginx = pillar.get('nginx', {}) %}

{% if nginx %}
nginx-package:
  pkg.installed:
    - pkgs:
        - nginx
        - php5-fpm

nginx-config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://web/files/nginx-config.conf
    - user: root
    - group: root
    - mode: 640
    - require:
        - pkg: nginx-package

nginx-default:
  file.managed:
    - name: /var/www/html/index.html
    - source: salt://web/files/nginx-default.html
    - user: www-data
    - group: www-data
    - makedirs: True
    - require:
        - pkg: nginx-package

nginx-sites:
  file.managed:
    - name: /etc/nginx/sites-enabled/default
    - source: salt://web/files/nginx-sites.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - context:
        sites: {{ nginx }}
    - require:
        - pkg: nginx-package
        - file: nginx-default
        - file: nginx-config

nginx-hosts:
  host.present:
    - ip: 127.0.0.1
    - names: [ {% for site, info in nginx.iteritems() %} {{ info['host'] }}, {% endfor %} ]

nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
        - pkg: nginx-package
    - watch:
        - file: nginx-default
        - file: nginx-config
        - file: nginx-sites
{% endif %}
