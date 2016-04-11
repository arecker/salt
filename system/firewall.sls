firewall-packages:
  pkg.installed:
    - pkgs:
        - ufw

firewall-default-outgoing:
  cmd.run:
    - name: ufw default allow outgoing
    - require:
        - pkg: firewall-packages

firewall-default-incoming:
  cmd.run:
    - name: ufw default deny incoming
    - require:
        - pkg: firewall-packages

firewall-ssh:
  cmd.run:
    - name: ufw allow {{ pillar.get('ssh_port', 22) }}
    - require:
        - pkg: firewall-packages

firewall-http:
  cmd.run:
    - name: ufw allow 80
    - require:
        - pkg: firewall-packages

firewall-https:
  cmd.run:
    - name: ufw allow 443
    - require:
        - pkg: firewall-packages

firewall-enable:
  cmd.run:
    - name: ufw enable --force
    - require:
        - pkg: firewall-packages
        - cmd: firewall-default-outgoing
        - cmd: firewall-default-incoming
        - cmd: firewall-http
        - cmd: firewall-https
