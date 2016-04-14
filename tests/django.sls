django-blog-db-exists:
  cmd.script:
    - name: salt://tests/files/django_blog_db_exists
    - user: postgres

django-blog-log-exists:
  cmd.run:
    - name: test -f /home/travis/logs/blog.log
