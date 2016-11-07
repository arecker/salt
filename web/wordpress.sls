{% set wordpress = pillar.get('wordpress', {}) %}

{% if wordpress %}
wordpress-src:
  file.managed:
    - makedirs: True
    - name: /opt/wordpress.tar.gz
    - source: https://wordpress.org/wordpress-4.6.1.tar.gz
    - source_hash: md5=ca0b978fd702eac033830ca2d0784b79

{% for site, info in wordpress.iteritems() %}
wordpress-{{ site }}-tar:
  cmd.run:
    - name: mkdir -p {{ info['root'] }} && tar -xf /opt/wordpress.tar.gz -C {{ info['root'] }} --strip-components 1
    - unless: test -d {{ info['root'] }}/wp-content
    - require:
        - file: wordpress-src

wordpress-{{ site }}-root:
  file.directory:
    - makedirs: True
    - name: {{ info['root'] }}
    - user: www-data
    - group: www-data
    - recurse: [user, group, mode]
    - require:
        - cmd: wordpress-{{ site }}-tar

wordpress-{{ site }}-uploads:
  file.directory:
    - makedirs: True
    - name: {{ info['root'] }}/wp-content/uploads
    - user: www-data
    - group: www-data
    - recurse: [user, group, mode]
    - require:
        - cmd: wordpress-{{ site }}-tar

wordpress-{{ site }}-sshkey:
  cmd.run:
    - name: |
        ssh-keygen -t rsa -b 4096 -N '' -f ~/.ssh/wordpress && \
        echo "from='127.0.0.1' $(cat ~/.ssh/wordpress.pub)" >> ~/.ssh/authorized_keys
    - runas: {{ info['user'] }}
    - unless: test -f ~/.ssh/wordpress

wordpress-{{ site }}-sshpermissions:
  cmd.run:
    - name: chown {{ info['user'] }}:www-data .ssh/wordpress*
    - cwd: /home/{{ info['user'] }}
    - require:
        - cmd: wordpress-{{ site }}-sshkey

wordpress-{{ site }}-config:
  file.managed:
    - name: {{ info['root'] + '/wp-config.php' }}
    - source: salt://web/files/wordpress-config.php.jinja
    - user: {{ info['user'] }}
    - group: www-data
    - mode: 440
    - template: jinja
    - context:
        DB_NAME: {{ info['db_name'] }}
        DB_USER: {{ info['db_user'] }}
        DB_PASS: {{ info['db_pass'] }}
        USER: {{ info['user'] }}
{% endfor %}

# TODO: https://www.digitalocean.com/community/tutorials/how-to-configure-secure-updates-and-installations-in-wordpress-on-ubuntu

{% endif %}
