{% set git = pillar.get('git', {}) %}
{% if git %}
git-package:
  pkg.installed:
    - name: git

{% for project, info in git.iteritems() %}
git-{{ project }}-target:
  file.directory:
    - makedirs: True
    - name: {{ info['target'] }}
    - user: {{ info.get('user', 'root') }}
    - require:
        - pkg: git-package

git-{{ project }}-repo:
  git.latest:
    - name: {{ info['url'] }}
    - target: {{ info['target'] }}
    - user: {{ info.get('user', 'root') }}
    - require:
      - pkg: git-package
{% endfor %}
{% endif %}
