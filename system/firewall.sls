firewall-package:
  pkg.installed:
    - pkgs: [ iptables ]

firewall-flush:
  iptables.flush:
    - require:
        - pkg: firewall-package

firewall-policy-input:
  iptables.set_policy:
    - chain: INPUT
    - policy: DROP
    - require:
        - iptables: firewall-flush

firewall-policy-output:
  iptables.set_policy:
    - chain: OUTPUT
    - policy: ACCEPT
    - require:
        - iptables: firewall-flush

firewall-rule-established:
  iptables.append:
    - chain: INPUT
    - connstate: ESTABLISHED,RELATED
    - jump: ACCEPT
    - save: True
    - require:
        - iptables: firewall-policy-input

firewall-rule-local:
  iptables.append:
    - chain: INPUT
    - source: 127.0.0.1
    - jump: ACCEPT
    - save: True
    - require:
        - iptables: firewall-policy-input

firewall-rule-docker:
  iptables.append:
    - chain: INPUT
    - source: 172.17.0.0/16
    - jump: ACCEPT
    - save: True
    - require:
        - iptables: firewall-policy-input

firewall-rule-ssh:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - dport: 22
    - jump: ACCEPT
    - save: True
    - require:
        - iptables: firewall-policy-input

firewall-rule-http:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - dport: 80
    - jump: ACCEPT
    - save: True
    - require:
        - iptables: firewall-policy-input

firewall-rule-https:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - dport: 443
    - jump: ACCEPT
    - save: True
    - require:
        - iptables: firewall-policy-input

{% if salt['grains.get']('vagrant', False) %}
firewall-rule-vagrant:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - dport: 2222
    - jump: ACCEPT
    - save: True
    - require:
        - iptables: firewall-policy-input
{% endif %}
