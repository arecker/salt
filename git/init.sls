{% set git = salt['pillar.get']('git', {}) %}

git-package:
  pkg.installed:
    - name: git

{% for project, info in git.iteritems() %}
git-{{ project }}:
  git.latest:
    - name: {{ info['url'] }}
    - target: {{ info['target'] }}
    - user: {{ info.get('user', 'root') }}
    - require:
      - pkg: git-package
{% endfor %}
