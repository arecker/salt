user-packages:
  pkg.installed:
    - pkgs: [ bash, sudo, zsh ]


include:
  - user.create
  {% if 'server' in salt['grains.get']('roles', []) %}
  - user.ssh
  {% endif %}
