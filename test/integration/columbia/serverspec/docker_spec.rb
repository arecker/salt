require 'serverspec'

set :backend, :exec

CONTAINERS = {

  'proxy' => {
    'image' => 'jwilder/nginx-proxy'
  },

  'bob' => {
    'image' => 'arecker/bobrosssearch.com'
  },

  'reckerdogs-database' => {
    'image' => 'mysql',
  },

  'reckerdogs-wordpress' => {
    'image' => 'wordpress',
  }

}

VOLUMES = {
  'proxy-certs' => nil,
  'reckerdogs-database' => 'auto.cnf',
  'reckerdogs-wordpress' => 'wp-config.php'
}

describe package('docker-engine') do
  it { should be_installed }
end

describe service('docker') do
  it { should be_running }
end

VOLUMES.each do |volume, file|
  volume_root = '/var/lib/docker/volumes'
  describe file(File.join(volume_root, volume, '_data')) do
    it { should exist }
    it { should be_directory }
    if !file.nil?
      describe file(File.join(volume_root, volume, '_data', file)) do
        it { should exist }
      end
    end
  end
end

CONTAINERS.each do |container, info|
  describe docker_image(info.fetch('image')) do
    it { should exist }
  end
  describe docker_container(container) do
    it { should be_running }
  end
end
