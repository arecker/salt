require 'serverspec'

set :backend, :exec

CONTAINERS = {

  'proxy' => {
    'image' => 'jwilder/nginx-proxy'
  },

  'reckerdogs-db' => {
    'image' => 'mysql',
  },

  'reckerdogs' => {
    'image' => 'wordpress',
  }

}

describe package('docker-engine') do
  it { should be_installed }
end

describe service('docker') do
  it { should be_running }
end

CONTAINERS.each do |container, info|
  describe docker_image(info.fetch('image')) do
    it { should exist }
  end
  describe docker_container(container) do
    it { should be_running }
  end
end
