{% if pillar.get('redis', False) %}
redis-pkg:
  pkg.installed:
    - pkgs:
        - redis-server

redis-service:
  service.running:
    - name: redis-server
    - enable: True
    - require:
        - pkg: redis-pkg
{% endif %}
