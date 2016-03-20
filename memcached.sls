memcached:
  pkg.installed: []
  service.running:
    - enable: true
    - watch:
      - pkg: memcached
