{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
web-django-packages:
  pkg.installed:
    - pkgs:
      - git
      - gcc
      - libjpeg-dev
      - python-dev
      - python-virtualenv
      - python-imaging
      - libjpeg-dev
      - zlib1g
      - zlib1g-dev

{% for project, info in DJANGOS.iteritems() %}
{% set python = salt['utils.join'](info.get('venv'), 'bin/python') %}
web-django-{{ project }}-git:
  git.latest:
    - name: {{ info.get('git') }}
    - target: {{ info.get('src') }}
    - user: {{ info.get('user') }}
    - require:
        - pkg: web-django-packages

web-django-{{ project }}-virtualenv-repo:
  virtualenv.managed:
    - name: {{ info.get('venv') }}
    - user: {{ info.get('user') }}
    - cwd: {{ info.get('src') }}
    - system_site_packages: False
    - requirements: {{ info.get('requirements') }}
    - require:
        - git: web-django-{{ project }}-git
        - pkg: web-django-packages

web-django-{{ project }}-virtualenv-prod:
  virtualenv.managed:
    - name: {{ info.get('venv') }}
    - user: {{ info.get('user') }}
    - system_site_packages: False
    - requirements: salt://web/files/requirements.txt
    - require:
        - virtualenv: web-django-{{ project }}-virtualenv-repo
        - pkg: web-django-packages
{% endfor %}
