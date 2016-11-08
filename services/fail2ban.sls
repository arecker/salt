fail2ban-pkg:
  pkg.installed:
    - name: fail2ban

fail2ban-config:
  file.managed:
    - name: /etc/fail2ban/jail.local
    - source: salt://services/files/fail2ban.conf
    - user: root
    - group: root
    - mode: 644
    - require:
        - pkg: fail2ban-pkg

fail2ban-service:
  service.running:
    - name: fail2ban
    - enable: True
    - watch:
        - pkg: fail2ban-pkg
        - file: fail2ban-config
