ufw:
  pkg.installed: []

ufw-default-deny-incoming:
  cmd.run:
    - name: ufw default deny incoming
    - require:
      - pkg: ufw

ufw-default-allow-outgoing:
  cmd.run:
    - name: ufw default allow outgoing
    - require:
        - pkg: ufw

ufw-allow-ssh:
  cmd.run:
    - name: ufw allow {{ pillar.get('ssh_port') }}
    - require:
        - pkg: ufw

ufw-allow-web-plain:
  cmd.run:
    - name: ufw allow 80
    - require:
        - pkg: ufw

ufw-allow-web-ssl:
  cmd.run:
    - name: ufw allow 443
    - require:
        - pkg: ufw

ufw-enable:
  cmd.run:
    - name: ufw enable
    - require:
      - pkg: ufw
      - cmd: ufw-allow-web-ssl
      - cmd: ufw-allow-web-plain
      - cmd: ufw-allow-ssh
      - cmd: ufw-default-allow-outgoing
      - cmd: ufw-default-deny-incoming
