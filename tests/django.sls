djang-test-reqs:
  pip.installed:
    - name: requests

django-blog-db-exists:
  cmd.script:
    - name: salt://tests/files/django_blog_db_exists
    - user: postgres

django-blog-web:
  cmd.script:
    - name: salt://tests/files/django_blog
    - require:
        - pip: django-test-reqs
