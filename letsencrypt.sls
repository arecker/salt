{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% set STATICS = salt['pillar.get']('statics', {}) %}
{% set email = salt['pillar.get']('email') %}
{% set lets_encrypt = '/opt/letsencrypt/letsencrypt-auto' %}

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
    - name: {{ lets_encrypt }} renew && nginx -s reload
    - user: root
    - hour: 1
    - onlyif: test -f {{ lets_encrypt }}
