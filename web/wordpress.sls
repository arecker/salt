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
    - require:
        - file: wordpress-src
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
{% endfor %}

{% endif %}
