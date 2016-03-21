{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% set USER = pillar.get('user') %}
virtualenv-deps:
  pkg.installed:
    - pkgs:
      - gcc
      - libjpeg-dev
      - python-dev
      - python-virtualenv
      - python-imaging
      - libjpeg-dev
      - zlib1g
      - zlib1g-dev

{% for project, info in DJANGOS.iteritems() %}
{% set virtualenv_root = salt['helpers.get_virtualenv_path'](USER, project, info) %}
virtualenv-{{ project }}-repo:
  virtualenv.managed:
    - name: {{ virtualenv_root }}
    - user: {{ USER }}
    - system_site_packages: False
    - cwd: {{ info.get('src') }}
    - requirements: {{ info.get('requirements') }}
virtualenv-{{ project }}-prod:
  virtualenv.managed:
    - name: {{ virtualenv_root }}
    - user: {{ USER }}
    - system_site_packages: False
    - requirements: salt://requirements.txt
{% endfor %}
