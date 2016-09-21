nginx-package:
  pkg.installed:
    - name: nginx

nginx-config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://files/nginx.conf
    - user: root
    - group: root
    - mode: 640
    - require:
        - pkg: nginx-package

default-www:
  file.managed:
    - name: /var/www/html/index.html
    - source: salt://files/default.html
    - user: www-data
    - group: www-data
    - mode: 644
    - makedirs: True

{% for site, info in pillar.get('sites', {}).iteritems() %}

{% if info.get('git', False) %}
{{ site }}-git:
  git.latest:
    - name: {{ info['git'] }}
    - target: {{ info['root'] }}
    - force_reset: true
    - user: {{ info.get('user', 'www-data') }}
{% endif %}

{{ site }}-www:
  file.directory:
    - name: {{ info['root'] }}
    - user: {{ info.get('user', 'www-data') }}
    - group: www-data
    - makedirs: True
    - recurse: [user, group, mode]

{{ site }}-hostname:
  host.present:
    - ip: 127.0.0.1
    - name: {{ info.get('host', 'localhost') }}
{% endfor %}

nginx-sites-enabled:
  file.managed:
    - name: /etc/nginx/sites-enabled/default
    - source: salt://files/default.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - context:
        sites: {{ pillar.get('sites', {}) }}
    - require:
        - pkg: nginx-package
        - file: default-www

nginx-service:
  service.running:
    - name: nginx
    - reload: true
    - watch:
        - pkg: nginx-package
        - file: nginx-config
        - file: nginx-sites-enabled
        - file: default-www
        {% for site, info in pillar.get('sites', {}).iteritems() %}
        - file: {{ site }}-www
        - host: {{ site }}-hostname
        {% endfor %}
