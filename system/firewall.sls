firewall-package:
  pkg.installed:
    - pkgs: [ iptables ]

firewall-flush:
  iptables.flush:
    - require:
        - pkg: firewall-package
