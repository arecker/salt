{% set jobs = salt['pillar.get']('systemd', {}) %}

{% if jobs %}
systemd-reload:
  module.run:
    - name: service.systemctl_reload
    - onchanges:
        {% for job in jobs.keys() %}
        - file: systemd-{{ job }}-file
        {% endfor %}
{% endif %}

{% if jobs %}
{% for job, info in jobs.iteritems() %}
systemd-{{ job }}-file:
  file.managed:
    - name: /etc/systemd/system/{{ job }}.service
    - source: salt://systemd/files/service.jinja
    - template: jinja
    - context:
        DESCRIPTION: {{ info.get('description', job) }}
        USER: {{ info.get('user', 'root') }}
        GROUP: {{ info.get('group', 'root') }}
        ENVIRONMENT: {{ info.get('environment', []) }}
        WORKING_DIR: {{ info.get('dir', None) }}
        EXEC_START: {{ info['start'] }}
        PRE_START: {{ info.get('prestart', []) }}

systemd-{{ job }}-service:
  service.running:
    - name: {{ job }}
    - enable: True
    - watch:
      - module: systemd-reload
{% endfor %}
{% endif %}
