{% set USER = salt['pillar.get']('user') %}
{% set STATICS = salt['pillar.get']('statics', {}) %}
{% set DJANGOS = salt['pillar.get']('djangos', {}) %}
git:
  pkg.installed: []

GIT_SSL_NO_VERIFY=1:
  environ.setenv:
    - value: "1"
    - require:
        - pkg: git

{% if STATICS %}
{% for site, info in STATICS.iteritems() %}
{% if info.get('git') %}
{{ info.get('git') }}:
  git.latest:
    - user: www-data
    - target: {{ info.get('root') }}
    - require:
        - pkg: git
{% endif %}
{% endfor %}
{% endif %}

{% if DJANGOS %}
{% for project, info in DJANGOS.iteritems() %}
{% if info.get('git') %}
{{ info.get('git') }}:
  git.latest:
    - user: {{ USER }}
    - target: {{ info.get('src') }}
    - require:
        - pkg: git
{% endif %}
{% endfor %}
{% endif %}

letsencrypt-client-git:
  git.latest:
    - name: https://github.com/letsencrypt/letsencrypt
    - target: /opt/letsencrypt
    - require:
        - pkg: git
