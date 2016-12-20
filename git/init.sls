{% set git = salt['pillar.get']('git', {}) %}

git-package:
  pkg.installed:
    - name: git

{% for project, info in git.iteritems() %}
{% set depth = info.get('depth', None) %}
git-{{ project }}:
  git.latest:
    - name: {{ info['url'] }}
    - target: {{ info['target'] }}
    - user: {{ info.get('user', 'root') }}
    {% if depth %}
    - depth: {{ depth }}
    {% endif %}
    - require:
      - pkg: git-package
{% endfor %}
