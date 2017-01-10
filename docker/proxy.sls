docker-proxy-volume:
  dockerng.volume_present:
    - name: proxy-certs
    - driver: local

docker-proxy-container:
  dockerng.running:
    - name: proxy
    - image: jwilder/nginx-proxy
    - port_bindings: 80:80,443:443
    - binds:
        - proxy-certs:/etc/nginx/certs
        - /var/run/docker.sock:/tmp/docker.sock:ro
