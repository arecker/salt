{% from "redis/map.jinja" import redis with context %}

redis-packages:
  pkg.installed:
    - pkgs: {{ redis.packages }}

redis-service:
  service.running:
    - name: {{ redis.service }}
    - enable: True
    - watch:
        - pkg: redis-packages
