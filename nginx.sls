{% set STATICS = salt['pillar.get']('statics', {}) %}
{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% set email = salt['pillar.get']('email') %}
{% set lets_encrypt = '/opt/letsencrypt/letsencrypt-auto' %}

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
    - watch:
        - file: /var/www/html/index.html
        {% for site, info in STATICS.iteritems() %}
        - cmd: letsencrypt-{{ site }}-cert
        {% endfor %}

/var/www/html/index.html:
  file:
    - managed
    - source: salt://configs/default.html
    - user: www-data
    - group: www-data
    - mode: 775

{% for site, info in STATICS.iteritems() %}
letsencrypt-{{ site }}-cert:
  cmd.run:
    - name: "{{ lets_encrypt }} certonly \
              --agree-tos \
              --server https://acme-v01.api.letsencrypt.org/directory \
              --email {{ email }}
              -a webroot \
              --webroot-path={{ info.get('root') }} \
              -d {{ info.get('server_name') }}"
    - unless: test -d /etc/letsencrypt/live/{{ info.get('server_name') }}
    - onlyif: test -f {{ lets_encrypt }}
{% endfor %}

letsencrypt-renew-cron:
  cron.present:
    - name: {{ lets_encrypt }} renew && systemctl reload nginx
    - user: root
    - hour: 1
    - onlyif: test -f {{ lets_encrypt }}
