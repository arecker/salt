{% for volume, info in salt['pillar.get']('volumes', {}).iteritems() %}
docker-volumes-{{ volume }}:
  dockerng.volume_present:
    - name: {{ volume }}
    - driver: {{ info.get('driver', 'local') }}
    - driver_opts: {{ info.get('options', {}) }}
{% endfor %}
