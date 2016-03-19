{% set STATICS = salt['pillar.get']('statics', {}) %}
git:
  pkg.installed: []

GIT_SSL_NO_VERIFY=1:
  environ.setenv:
    - value: "1"

{% if STATICS %}
{% for site, info in STATICS.iteritems() %}
{% if info.get('git') %}
{{ info.get('git') }}:
  git.latest:
    - user: www-data
    - target: {{ info.get('root') }}
{% endif %}
{% endfor %}
{% endif %}
