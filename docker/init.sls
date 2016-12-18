{% if grains['oscodename'] == 'jessie' %}
docker-repo:
  pkgrepo.managed:
    - humanname: Docker
    - name: deb https://apt.dockerproject.org/repo debian-jessie main
    - file: /etc/apt/sources.list.d/docker.list
    - keyid: 58118E89F3A912897C070ADBF76221572C52609D
    - keyserver: hkp://p80.pool.sks-keyservers.net:80
    - require_in:
        - pkg: docker-packages
{% elif grains['oscodename'] == 'trusty' %}
docker-repo:
  pkgrepo.managed:
    - humanname: Docker
    - name: deb https://apt.dockerproject.org/repo ubuntu-trusty main
    - file: /etc/apt/sources.list.d/docker.list
    - keyid: 58118E89F3A912897C070ADBF76221572C52609D
    - keyserver: hkp://p80.pool.sks-keyservers.net:80
    - require_in:
        - pkg: docker-packages
{% endif %}

docker-packages:
  pkg.installed:
    - pkgs:
        - docker-engine
        - python-pip

docker-packages-pip:
  pip.installed:
    - name: docker-py
    - reload_modules: True
    - require:
      - pkg: docker-packages

docker-service:
  service.running:
    - name: docker
    - enable: True
    - watch:
        - pkg: docker-packages

{% for image, info in salt['pillar.get']('docker', {}).iteritems() %}
{% set environment = info.get('environment', {}) %}
docker-{{ image }}:
  dockerng.running:
    - name: {{ image }}
    - image: {{ info['image'] }}
    - links: {{ info.get('links', []) }}
    - port_bindings: {{ info.get('publish', []) }}
    - ports: {{ info.get('expose', []) }}
    - binds: {{ info.get('binds', [] )}}
    - restart_policy: always
    {% if environment %}
    - environment:
      {% for key, val in environment.iteritems() %}
      - "{{ key }}": "{{ val }}"
      {% endfor %}
    {% endif %}
{% endfor %}
