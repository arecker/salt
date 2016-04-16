django-test-reqs:
  pip.installed:
    - name: requests

django-blog-db-exists:
  cmd.script:
    - name: salt://tests/files/django_blog_db_exists
    - user: postgres

django-blog-logs-exist:
  cmd.run:
    - name: |
        test -d /home/travis/logs/blog/ &&
        test -f /home/travis/logs/blog/django.log

django-blog-web:
  cmd.script:
    - name: salt://tests/files/django_blog
    - require:
        - pip: django-test-reqs
