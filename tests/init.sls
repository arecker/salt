tests-reqs:
  pip.installed:
    - name: requests

include:
  - tests.static
  - tests.django
  - require:
      - pip: test-reqs
