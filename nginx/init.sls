{% set vhosts = salt['pillar.get']('vhosts', {}) %}
nginx:
  pkg.installed: []
  service.running:
    - watch:
        - pkg: nginx
        - file: /etc/nginx/nginx.conf
        - file: /etc/nginx/sites-enabled/default

/etc/nginx/nginx.conf:
  file:
    - managed
    - source: salt://nginx/templates/nginx.conf.jinja
    - user: root
    - group: root
    - mode: 640

/etc/nginx/sites-enabled/default:
  file:
    - managed
    - source: salt://nginx/templates/default.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640

{% for vhost, info in vhosts.iteritems() %}
{% if info.get('tar') %}
{{ vhost }}_tar:
  archive.extracted:
    - name: /var/www/
    - source: {{ info.get('tar') }}
    - tar_options: J
    - archive_format: tar
    - if_missing: {{ info.get('root') }}
    - user: www-data
    - group: www-data
{% endif %}
{% endfor %}

git:
  pkg.installed: []

{% for vhost, info in vhosts.iteritems() %}
{% if info.get('git') %}
{{ info.get('git') }}:
  git.latest:
    - target: {{ info.get('root') }}
  require:
    - pkg: git
{% endif %}
{% endfor %}

{% for vhost, info in vhosts.iteritems() %}
{% if info.get('root') %}
{{ info.get('root') }}:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755
    - exclude_pat: .git
    - recurse:
      - user
      - group
{% endif %}
{% endfor %}

{% for vhost, info in vhosts.iteritems() %}
{{ vhost }}_host:
  host.present:
    - ip: 127.0.0.1
    - name: {{ info.get('server_name') }}
{% endfor %}
