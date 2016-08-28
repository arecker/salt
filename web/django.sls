{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% if DJANGOS %}
{% for project, info in DJANGOS.iteritems() %}
django-{{ project }}-static:
  file.directory:
    - name: {{ info.get('static') }}
    - user: {{ info.get('user') }}
    - group: www-data
    - dir_mode: 755
    - makedirs: True
    - recurse: [user, group, mode]

django-{{ project }}-hostname:
  host.present:
    - ip: 127.0.0.1
    - name: {{ info.get('host') }}
{% endfor %}

django-hosts:
  file.managed:
    - name: /etc/nginx/sites-enabled/django
    - source: salt://web/files/django.nginx
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - context:
        djangos: {{ DJANGOS }}
    - require:
        - pkg: web-packages
          {% for project, info in DJANGOS.iteritems() %}
        - host: django-{{ project }}-hostname
          {% endfor %}
{% endif %}
