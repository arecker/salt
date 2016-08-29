web-packages:
  pkg.installed:
    - pkgs:
        - nginx

web-nginx-config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://web/files/nginx.conf
    - user: root
    - group: root
    - mode: 640
    - require:
        - pkg: web-packages

web-nginx-default-page:
  file.managed:
    - name: /var/www/html/index.html
    - source: salt://web/files/default.html
    - user: www-data
    - group: www-data
    - mode: 644
    - makedirs: True

web-nginx-default-host:
  file.managed:
    - name: /etc/nginx/sites-enabled/default
    - source: salt://web/files/default.nginx
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - require:
        - pkg: web-packages
        - file: web-nginx-default-page

include:
  - web.static
  - web.django

web-nginx-service:
  service.running:
    - enable: True
    - name: nginx
    - watch:
        - pkg: web-packages
        - file: web-nginx-config
        - file: web-nginx-default-page
        - file: web-nginx-default-host

web-nginx-reload:
  cmd.run:
    - name: nginx -s reload
