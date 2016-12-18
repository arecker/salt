{% from "certbot/map.jinja" import certbot with context %}

certbot-cron:
  cron.present:
    - name: certbot renew --quiet --pre-hook "{{ certbot.nginx_stop }}" --post-hook "{{ certbot.nginx_start }}"
    - hour: 1
    - dayweek: 1
