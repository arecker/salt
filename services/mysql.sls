{% set mysql = pillar.get('mysql', {}) %}
{% set mysql_databases = mysql.get('databases', []) %}
{% set mysql_users = mysql.get('users', {}) %}
{% if mysql %}
mysql-packages:
  pkg.installed:
    - pkgs:
        - mysql-server
        - python-pip

mysql-service:
  service.running:
    - name: mysql
    - enable: True
    - require:
        - pkg: mysql-packages

mysql-pip-packages:
  pip.installed:
    - name: mysql-python
    - reload_modules: True
    - require:
        - pkg: mysql-packages

{% for db in mysql_databases %}
mysql-database-{{ db }}:
  mysql_database.present:
    - name: {{ db }}
    - require:
        - service: mysql-service
{% endfor %}

{% for user, info in mysql_users.iteritems() %}
mysql-user-{{ user }}:
  mysql_user.present:
    - name: {{ user }}
    - password: {{ info.get('password', None) }}
    - host: {{ info.get('host', 'localhost') }}
    - require:
        - service: mysql-service

{% for db, privs in info.get('grants', {}).iteritems() %}
mysql-grants-{{ user }}-{{ db }}:
  mysql_grants.present:
    - database: {{ db }}.*
    - user: {{ user }}
    - grant: {{ privs }}
    - require:
        - mysql_user: mysql-user-{{ user }}
        - mysql_database: mysql-database-{{ db }}
{% endfor %}

{% endfor %}

{% endif %}
