{% set djangos = pillar.get('djangos', {}) %}
{% if djangos %}
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
{% endif %}
