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

ufw-enable:
  cmd.run:
    - name: ufw enable
    - require:
      - pkg: ufw
