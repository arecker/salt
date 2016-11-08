fail2ban-pkg:
  pkg.installed:
    - name: fail2ban

fail2ban-service:
  service.running:
    - name: fail2ban
    - enable: True
    - watch:
        - pkg: fail2ban
