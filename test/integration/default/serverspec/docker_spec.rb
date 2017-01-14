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

describe command('docker -v') do
  its(:exit_status) { should eq 0 }
end

describe command('docker-compose -v') do
  its(:exit_status) { should eq 0 }
end

CONTAINERS.each do |container, image|
  describe docker_image(image) do
    it { should exist }
  end
  describe docker_container(container) do
    it { should be_running }
  end
end
