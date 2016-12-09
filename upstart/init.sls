{% set jobs = salt['pillar.get']('upstart', {}) %}

{% if jobs %}
upstart-reload:
  cmd.run:
    - name: initctl reload-configuration
    - onchanges:
        {% for job in jobs.keys() %}
        - file: upstart-{{ job }}-file
        {% endfor %}
{% endif %}

{% if jobs %}
{% for job, info in jobs.iteritems() %}
upstart-{{ job }}-file:
  file.managed:
    - name: /etc/init/{{ job }}.conf
    - source: salt://upstart/files/upstart.jinja
    - template: jinja
    - context:
        DESCRIPTION: {{ info.get('description', job) }}
        USER: {{ info.get('user', 'root') }}
        GROUP: {{ info.get('group', 'root') }}
        WORKING_DIR: {{ info.get('dir', None) }}
        START: {{ info['start'] }}

upstart-{{ job }}-service:
  service.running:
    - name: {{ job }}
    - enable: True
    - watch:
        - cmd: upstart-reload
{% endfor %}
{% endif %}
