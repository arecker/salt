docker-proxy-container:
  dockerng.running:
    - name: proxy
    - image: jwilder/nginx-proxy
    - port_bindings: 80:80,443:443
    - binds: /var/run/docker.sock:/tmp/docker.sock:ro
