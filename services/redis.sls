redis-pkg:
  pkg.installed:
    - pkgs:
        - redis-server
        - redis-tools

redis-service:
  service.running:
    - name: redis
    - enable: True
    - require:
        - pkg: redis-pkg
