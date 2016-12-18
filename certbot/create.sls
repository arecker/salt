{% from "certbot/map.jinja" import certbot with context %}
{% for site, info in salt['pillar.get']('nginx').iteritems() %}
{% set cert_exists = 'test -d /etc/letsencrypt/live/' + info['host'] %}
certbot-{{ site }}-stop:
  service.dead:
    - name: nginx
    - unless: {{ cert_exists }}
    - onlyif: which nginx

certbot-{{ site }}-download:
  cmd.run:
    - name: certbot certonly --standalone --standalone-supported-challenges http-01 -d {{ info['host'] }} --agree-tos --email alex@reckerfamily.com
    - unless: {{ cert_exists }}
    - require:
      - service: certbot-{{ site }}-stop
{% endfor %}

certbot-nginx-start:
  service.running:
    - name: nginx
    - require:
      {% for site in salt['pillar.get']('nginx').keys() %}
      - cmd: certbot-{{ site }}-download
      {% endfor %}
    - onlyif: which nginx
