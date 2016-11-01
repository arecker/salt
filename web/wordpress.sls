{% set wordpress = pillar.get('wordpress', {}) %}

wordpress-packages:
  pkg.installed:
    - name: unzip

{% if wordpress %}
wordpress-src:
  file.managed:
    - makedirs: True
    - name: /opt/wordpress.tar.gz
    - source: https://wordpress.org/wordpress-4.6.1.tar.gz
    - source_hash: md5=ca0b978fd702eac033830ca2d0784b79

wordpress-ssh-src:
  file.managed:
    - makedirs: True
    - name: /opt/
    - source: https://downloads.wordpress.org/plugin/ssh-sftp-updater-support.0.7.1.zip
    - source_hash: md5=803fd37b61a28f1d671bae51e52db0bb

{% for site, info in wordpress.iteritems() %}
wordpress-{{ site }}-tar:
  cmd.run:
    - name: mkdir -p {{ info['root'] }} && tar -xf /opt/wordpress.tar.gz -C {{ info['root'] }} --strip-components 1
    - require:
        - file: wordpress-src

wordpress-{{ site }}-root:
  file.directory:
    - makedirs: True
    - name: {{ info['root'] }}
    - user: {{ info.get('user', 'www-data') }}
    - group: www-data
    - recurse: [user, group, mode]
    - require:
        - cmd: wordpress-{{ site }}-tar

wordpress-{{ site }}-ssh-plugin:
  cmd.run:
    - runas: {{ info.get('user', 'www-data') }}
    - name: unzip /opt/ssh-sftp-updater-support.0.7.1.zip
    - cwd: {{ info['root'] }}/wp-content/plugins
    - require:
        - pkg: wordpress-packages
        - file: wordpress-ssh-src

wordpress-{{ site }}-uploads:
  file.directory:
    - makedirs: True
    - name: {{ info['root'] }}/wp-content/uploads
    - user: {{ info.get('user', 'www-data') }}
    - group: www-data
    - recurse: [user, group, mode]
    - require:
        - cmd: wordpress-{{ site }}-tar

wordpress-{{ site }}-config:
  file.managed:
    - name: {{ info['root'] + '/wp-config.php' }}
    - source: salt://web/files/wordpress-config.php.jinja
    - user: {{ info.get('user', 'www-data') }}
    - group: www-data
    - mode: 440
    - template: jinja
    - context:
        DB_NAME: {{ info['db_name'] }}
        DB_USER: {{ info['db_user'] }}
        DB_PASS: {{ info['db_pass'] }}
{% endfor %}

{% endif %}
