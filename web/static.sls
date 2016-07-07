web-static-packages:
  pkg.installed:
    - name: git

{% set STATICS = salt['pillar.get']('statics', {}) %}
{% for site, info in STATICS.iteritems() %}
{% set git = info.get('git', None) %}
{% set root = info.get('root') %}
{% set user = info.get('user') %}

{% if git %}
web-static-{{ site }}-git:
  git.latest:
    - name: {{ git }}
    - target: {{ root }}
    - require:
        - pkg: web-static-packages
{% endif %}

web-static-{{ site }}-target:
  file.directory:
    - name: {{ root }}
    - user: {{ user }}
    - group: www-data
    - dir_mode: 755
    - makedirs: True
    - recurse: [user, group, mode]

web-static-{{ site }}-hostname:
  host.present:
    - ip: 127.0.0.1
    - name: {{ info.get('host') }}
{% endfor %}

web-static-hosts:
  file.managed:
    - name: /etc/nginx/sites-enabled/static
    - source: salt://web/files/static.nginx
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - require:
        - pkg: web-packages
        {% for site, info in STATICS.iteritems() %}
        - host: web-static-{{ site }}-hostname
        - file: web-static-{{ site }}-target
        {% if info.get('git', None ) %}
        - git: web-static-{{ site }}-git
        {% endif %}
        {% endfor %}
    - context:
        statics: {{ STATICS }}
