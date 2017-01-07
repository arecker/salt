require 'serverspec'

set :backend, :exec

describe 'docker package' do
  it 'should be installed' do
    expect(package('docker-engine')).to be_installed
  end
  it 'should be running' do
    expect(service('docker')).to be_running
  end
end

describe 'docker proxy' do
  it 'should be pulled' do
    expect(docker_image('jwilder/nginx-proxy')).to exist
  end
  it 'should be running' do
    expect(docker_container('proxy')).to be_running
  end
  {
    'alexrecker.local/subscribe/' => /Subscribe | Blog by Alex Recker/,
    'alexrecker.local/random.png' => /No pictures to pick from/,
    'reckerdogs.local' => /WordPress/,
  }.each do |target,expected|
    it "should proxy to #{target}" do
      expect(command("curl -L #{target}").stdout).to match(expected)
    end
  end
end

describe 'docker volumes' do
  {
    'reckerdogs' => ['/var/www/html/wp-content'],
    'reckerdogs-db' => ['/var/lib/mysql'],
    'subscribah-db' => ['/var/lib/postgresql/data']
  }.each do |container, volumes|
    volumes.each do |v|
      it "should have made volume #{v} on #{container}" do
        expect(docker_container(container)).to have_volume(v)
      end
    end
  end
end
