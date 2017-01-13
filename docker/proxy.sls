docker-proxy-volume-certs:
  dockerng.volume_present:
    - name: proxy-certs
    - driver: local

docker-proxy-volume-vhosts:
  dockerng.volume_present:
    - name: proxy-vhosts
    - driver: local

docker-proxy-volume-html:
  dockerng.volume_present:
    - name: proxy-html
    - driver: local

docker-proxy-container:
  dockerng.running:
    - name: proxy
    - image: jwilder/nginx-proxy
    - port_bindings: 80:80,443:443
    - binds:
        - proxy-certs:/etc/nginx/certs:ro
        - proxy-vhosts:/etc/nginx/vhost.d
        - proxy-html:/usr/share/nginx/html
        - /var/run/docker.sock:/tmp/docker.sock:ro
    - require:
        - dockerng: docker-proxy-volume-certs
        - dockerng: docker-proxy-volume-vhosts
        - dockerng: docker-proxy-volume-html

docker-letsencrypt-container:
  dockerng.running:
    - name: letsencrypt
    - image: jrcs/letsencrypt-nginx-proxy-companion
    - binds:
        - proxy-certs:/etc/nginx/certs:rw
        - proxy-vhosts:/etc/nginx/vhost.d
        - proxy-html:/usr/share/nginx/html
        - /var/run/docker.sock:/var/run/docker.sock:ro
    - require:
        - dockerng: docker-proxy-container
