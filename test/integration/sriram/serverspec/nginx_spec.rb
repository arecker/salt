require 'serverspec'

set :backend, :exec

describe 'nginx' do
  [
    'sarahrecker.local',
    'blog.sarahrecker.local'
  ].each do |domain|
    it "should serve #{domain}" do
      expect(host(domain)).to be_resolvable
      expect(host(domain).ipaddress).to eq('127.0.0.1')
      expect(command("curl --silent -L --insecure https://#{domain}").stdout).to match('WordPress')
    end
  end
end
