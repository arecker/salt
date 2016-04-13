docker-deps:
  pkg.installed:
    - pkgs: [ python-pip ]

docker-python-deps:
  pip.installed:
    - name: docker-py
    - reload_modules: True
    - require:
        - pkg: docker-deps

docker-install:
  cmd.script:
    - name: salt://services/files/install_docker.sh
    - unless: docker --version
    - require:
        - pkg: docker-deps
        - pip: docker-python-deps

docker-service:
  service.running:
    - name: docker
    - enable: True
    - require:
        - pip: docker-python-deps
        - cmd: docker-install

docker-test-image:
  dockerng.running:
    - name: hello-world
    - image: hello-world
    - require:
        - cmd: docker-install
        - pip: docker-python-deps
        - pkg: docker-deps
        - service: docker-service

{% set djangos = pillar.get('djangos', {}) %}
{% for project, info in djangos.iteritems() %}
docker-{{ project }}-image:
  dockerng.running:
    - name: {{ project }}
    - image: {{ info.get('image') }}
    - port_bindings: {{ info.get('port') }}:8000
    - environment:
        - HOST: {{ info.get('host') }}
        - SECRET_KEY: {{ info.get('secret') }}
        - DB_NAME: {{ info.get('db_name') }}
        - DB_USER: {{ info.get('db_user') }}
        - DB_PASS: {{ info.get('db_pass') }}
    - require:
        - cmd: docker-install
        - pip: docker-python-deps
        - pkg: docker-deps
        - service: docker-service
        - sls: services.postgresql
{% endfor %}
