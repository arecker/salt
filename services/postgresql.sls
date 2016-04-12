postgresql-packages:
  pkg.installed:
    - pkgs:
        - postgresql

postgresql-service:
  service.running:
    - name: postgresql
    - enable: True
    - require:
        - pkg: postgresql-packages
    - watch:
        - pkg: postgresql-packages
