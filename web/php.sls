php-package:
  pkg.installed:
    - pkgs:
        - php5
        - php5-cli
        - php5-fpm
        - php5-gd
        - php5-mysql
        {% if grains['os'] == 'Ubuntu' %}
        - libssh2-php
        {% elif grains['os'] == 'Debian' %}
        - php5-ssh2
        {% endif %}

php-info:
  file.managed:
    - name: /var/www/html/info.php
    - contents: <?php phpinfo(); ?>
    - user: www-data
    - group: www-data
    - makedirs: True
    - require:
        - pkg: php-package

php-service:
  service.running:
    - name: php5-fpm
    - enable: True
    - reload: True
    - require:
        - pkg: php-package
    - watch:
        - pkg: php-package
