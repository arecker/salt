{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
{% set USER = pillar.get('user') %}
