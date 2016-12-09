nginx-hosts:
  host.present:
    - ip: 127.0.0.1
    - names: [ {% for site, info in salt['pillar.get']('nginx', {}).iteritems() %} {{ info['host'] }}, {% endfor %} ]
