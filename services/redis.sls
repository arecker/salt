redis-packages:
  pkg.installed:
    - pkgs:
        - redis-server

redis-service:
  service.running:
    - name: redis-server
    - enable: True
    - require:
        - pkg: redis-packages
    - watch:
        - pkg: redis-packages
