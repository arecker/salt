{% set info = salt['pillar.get']('auth', {}) %}

{{ salt['pillar.get']('user') }}:
  user.present: []
