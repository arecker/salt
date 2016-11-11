{% set hosts = salt['pillar.get']('hosts', {}) %}
{% set hosts_present = hosts.get('present', {}) %}
{% set hosts_absent = hosts.get('absent', {}) %}

{% for name, address in hosts_present.iteritems() %}
hosts-present-{{ name }}:
  host.present:
    - ip: {{ address }}
    - names: [ {{ name }} ]
{% endfor %}

{% for name, address in hosts_absent.iteritems() %}
hosts-absent-{{ name }}:
  host.absent:
    - ip: {{ address }}
    - names: [ {{ name }} ]
{% endfor %}
