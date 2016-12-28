require 'serverspec'

set :backend, :exec

describe 'docker' do
  containers = [
    'bob-proxy',
    'blog-proxy',
    'wedding-proxy',
    'random.png',
    'reckerdogs-db',
    'reckerdogs-wp',
    'moolah-redis',
    'moolah-db',
    'moolah-gunicorn',
    'moolah-celery',
    'moolah-nginx'
  ]

  containers.each do |container|
    it "should have a running \"#{container}\" container" do
      expect(docker_container(container)).to be_running
    end
  end
end
