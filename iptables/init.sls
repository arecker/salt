{% from "iptables/map.jinja" import iptables with context %}
iptables-package:
  pkg.installed:
    - pkgs: {{ iptables.packages }}

iptables-policy-input:
  iptables.set_policy:
    - chain: INPUT
    - policy: DROP
    - require:
        - pkg: iptables-package

iptables-policy-output:
  iptables.set_policy:
    - chain: OUTPUT
    - policy: ACCEPT
    - require:
        - pkg: iptables-package

{% for name, info in iptables.get('rules', {}).iteritems() %}
{% set connstate = info.get('connstate', False) %}
{% set dport = info.get('dport', False) %}
{% set proto = info.get('proto', False) %}
{% set source = info.get('source', False) %}
iptables-rule-{{ name }}:
  iptables.append:
    - chain: {{ info['chain'] }}
    {% if connstate %}
    - connstate: {{ connstate }}
    {% endif %}
    - jump: {{ info['jump'] }}
    {% if source %}
    - source: {{ source }}
    {% endif %}
    {% if dport %}
    - dport: {{ dport }}
    {% endif %}
    {% if proto %}
    - proto: {{ proto }}
    {% endif %}
    - save: True
    - unless:
        - iptables: iptables-rule-{{ name }}-present
    - require:
        - iptables: iptables-policy-input
        - iptables: iptables-policy-output
{% endfor %}

{% for key, info in salt['pillar.get']('iptables', {}).iteritems() %}
iptables-{{ key }}:
  iptables.append:
    - chain: {{ info['chain'] }}
    - proto: {{ info['proto'] }}
    - state: {{ info['state'] }}
    - dport: {{ info['dport'] }}
    - jump: {{ info['jump'] }}
    - require:
        - iptables: iptables-policy-input
{% endfor %}

{% if salt['grains.get']('vagrant', False) %}
iptables-rule-vagrant:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - dport: 2222
    - jump: ACCEPT
    - save: True
    - require:
        - iptables: iptables-policy-input
{% endif %}

{% if salt['grains.get']('master', False) %}
iptables-rule-master-1:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - state: new
    - dport: 4505
    - jump: ACCEPT
    - save: True
    - require:
        - iptables: iptables-policy-input

iptables-rule-master-2:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - state: new
    - dport: 4506
    - jump: ACCEPT
    - save: True
    - require:
        - iptables: iptables-policy-input
{% endif %}
