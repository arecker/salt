{% from "mysql/map.jinja" import mysql with context %}

mysql-packages:
  pkg.installed:
    - pkgs: {{ mysql.packages }}
    - unless: which mysql  # Travis installs its own version, apparently

mysql-pip-packages:
  pip.installed:
    - name: mysql-python
    - reload_modules: True
    - require:
        - pkg: mysql-packages

mysql-service:
  service.running:
    - name: {{ mysql.service }}
    - enable: True
    - watch:
        - pkg: mysql-packages
        - pip: mysql-pip-packages

{% for db, info in salt['pillar.get']('mysql', {}).iteritems() %}
mysql-{{ db }}-db:
  mysql_database.present:
    - name: {{ db }}
    - require:
        - service: mysql-service

mysql-{{ db }}-user:
  mysql_user.present:
    - name: {{ info['user'] }}
    - password: {{ info.get('password', None) }}
    - host: {{ info.get('host', 'localhost') }}
    - require:
        - service: mysql-service

mysql-{{ db }}-grants:
  mysql_grants.present:
    - database: {{ db }}.*
    - user: {{ info['user'] }}
    - grant: all privileges
    - require:
        - mysql_user: mysql-{{ db }}-user
        - mysql_database: mysql-{{ db }}-db
{% endfor %}
