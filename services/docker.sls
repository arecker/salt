docker-deps:
  pkg.installed:
    - pkgs: [ python-pip ]

docker-python-deps:
  pip.installed:
    - name: docker-py==0.6.0
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
        - pkg: docker-python-deps
        - cmd: docker-install

ubuntu:
  docker.pulled:
    - tag: latest
    - require:
        - cmd: docker-install
