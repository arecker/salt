{% set systemd = salt['pillar.get']('systemd', {}) %}

{% if systemd %}
systemd-reload:
  module.run:
    - name: service.systemctl_reload
    - onchanges:
        {% for job, info in systemd.iteritems() %}
        - file: systemd-{{ job }}-file
        {% endfor %}
{% endif %}

{% for job, info in systemd.iteritems() %}
systemd-{{ job }}-file:
  file.managed:
    - name: /etc/systemd/system/{{ job }}.service
    - source: salt://services/files/systemd.service
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
