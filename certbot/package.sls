{% if grains['oscodename'] == 'jessie' %}
certbot-jessie-backports:
  pkgrepo.managed:
    - humanname: Jessie Backports
    - name: deb http://ftp.debian.org/debian jessie-backports main
    - file: /etc/apt/sources.list.d/backports.list
    - require_in:
      - pkg: certbot-package
{% elif grains['oscodename'] == 'trusty' %}
certbot-trusty-ppa:
  pkgrepo.managed:
    - ppa: certbot/certbot
{% endif %}

certbot-package:
  pkg.installed:
    {% if grains['oscodename'] == 'jessie' %}
    - fromrepo: jessie-backports
    {% endif %}
    - name: certbot
