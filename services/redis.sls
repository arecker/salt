redis-pkg:
  pkg.installed:
    - pkg:
        - redis-server
        - redis-tools

redis-service:
  service.running:
    - name: redis
    - enable: True
    - watch:
        - pkg: redis-pkg
