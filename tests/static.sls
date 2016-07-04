static-pip-reqs:
  pip.installed:
    - name: requests
    - reload_modules: True

static-bob:
  cmd.script:
    - name: salt://tests/files/static_bob

static-blog-jekyll:
  cmd.script:
    - name: salt://tests/files/static_alexrecker
    - runas: travis
    - require:
        - pip: static-pip-reqs
