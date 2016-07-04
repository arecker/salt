static-bob:                     # bobrosssearch.com should be live
  cmd.script:
    - name: salt://tests/files/static_bob

static-blog-jekyll:
  cmd.script:
    - name: salt://tests/files/static_alexrecker
    - runas: travis
