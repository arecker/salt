{% set virtualenvs = pillar.get('virtualenvs', {}) %}
{% if virtualenvs %}
virtualenv-pkg:
  pkg.installed:
    - pkgs:
        - python-dev
        - python-virtualenv
        - libjpeg-dev

{% for venv, info in virtualenvs.iteritems() %}
virtualenv-{{ venv }}:
  virtualenv.managed:
    - name: {{ info['root'] }}
    - requirements: {{ info['requirements'] }}
    - user: {{ info['user'] }}
    - require:
        - pkg: virtualenv-pkg
{% endfor %}
{% endif %}
