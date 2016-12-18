require 'serverspec'

set :backend, :exec

describe 'docker' do

  containers = [
    'reckerdogsdata',
    'reckerdogsdb',
    'reckerdogs'
  ]

  containers.each do |container|

    it "should have a running \"#{container}\" container" do
      expect(docker_container(container)).to be_running
    end

    it "should have \"#{container}\" container configured with volumes" do
      expect(docker_container(container)).to have_volume('/var/lib/mysql', '/var/www/html/wp-content')
    end

  end

end
