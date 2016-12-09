{% from "virtualenv/map.jinja" import virtualenv with context %}
virtualenv-packages:
  pkg.installed:
    - pkgs: {{ virtualenv.packages }}

{% for env, info in salt['pillar.get']('virtualenv', {}).iteritems() %}
virtualenv-{{ env }}:
  virtualenv.managed:
    - name: {{ info['root'] }}
    - requirements: {{ info['requirements'] }}
    - user: {{ info['user'] }}
    - require:
        - pkg: virtualenv-packages
{% endfor %}
