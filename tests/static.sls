static-tests-reqs:
  pip.installed:
    - name: requests

static-bob:
  cmd.script:
    - name: salt://tests/files/static_bob

static-blog-jekyll:
  cmd.script:
    - name: salt://tests/files/static_alexrecker
    - runas: travis
      - require:
        - pip: django-test-reqs
