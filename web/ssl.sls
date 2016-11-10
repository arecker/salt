ssl-certbot-src:
  file.managed:
    - name: /usr/local/sbin/certbot-auto
    - source: https://dl.eff.org/certbot-auto
    - source_hash: md5=e3848b764200e645b97576a4983213f6
    - user: root
    - group: root
    - mode: 775

ssl-certbot-cron:
  cron.present:
    - name: /usr/local/sbin/certbot-auto renew --quiet
    - user: root
    - minute: 0
    - hour: 0
    - daymonth: 1
    - require:
        - file: ssl-certbot-src
