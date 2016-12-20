{% for dir, info in salt['pillar.get']('directories', {}).iteritems() %}
{{ dir }}:
  file.directory:
    - user: {{ info.get('user', None) }}
    - group: {{ info.get('group', None) }}
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - recurse: [ user, group, mode ]
{% endfor %}
