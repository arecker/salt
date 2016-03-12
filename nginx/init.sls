{% set vhosts = salt['pillar.get']('vhosts', {}) %}
nginx:
  pkg.installed: []
  service:
    - running
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

hosts:
  host.present:
    - ip: 127.0.0.1
    {% for vhost, info in vhosts.iteritems() %}
    - name: {{ info.get('server_name') }}
    {% endfor %}
