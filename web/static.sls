{% set STATICS = salt['pillar.get']('statics', {}) %}
{% for site, info in STATICS.iteritems() %}
{% set git = info.get('git', None) %}
{% set root = info.get('root') %}

web-static-packages:
  pkg.installed:
    - name: git

{% if git %}
web-static-{{ site }}-git:
  git.latest:
    - name: {{ git }}
    - target: {{ root }}
    - require:
        - pkg: web-static-packages
{% endif %}
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
    - context:
        statics: {{ STATICS }}
