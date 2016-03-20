{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% set USER = pillar.get('user') %}
virtualenv-deps:
  pkg.installed:
    - pkgs:
      - gcc
      - libjpeg-dev
      - python-dev
      - python-virtualenv

{% for project, info in DJANGOS.iteritems() %}
{% set default_env = '/home/' + USER + '/.virtualenvs/' + project %}
{% set virtualenv_root = info.get('virtualenv', default_env) %}
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