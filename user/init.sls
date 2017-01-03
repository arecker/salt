user-packages:
  pkg.installed:
    - pkgs: [ bash, sudo, zsh ]

include:
  - user.create
  - user.ssh
