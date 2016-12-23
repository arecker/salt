require 'serverspec'

set :backend, :exec

describe 'docker' do
  containers = [
    'blog-wp',
    'blog-db',
    'portfolio-wp',
    'portfolio-db'
  ]

  containers.each do |container|
    it "should have a running \"#{container}\" container" do
      expect(docker_container(container)).to be_running
    end
  end
end
