include:
  - services.postgresql

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
