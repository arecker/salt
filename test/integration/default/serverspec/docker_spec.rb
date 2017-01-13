require 'serverspec'

set :backend, :exec

CONTAINERS = {
  'nginx-proxy' => 'jwilder/nginx-proxy',
  'nginx-ssl' => 'jrcs/letsencrypt-nginx-proxy-companion'
}

describe package('docker-engine') do
  it { should be_installed }
end

describe service('docker') do
  it { should be_running }
end

CONTAINERS.each do |container, image|
  describe docker_image(image) do
    it { should exist }
  end
  describe docker_container(container) do
    it { should be_running }
  end
end
