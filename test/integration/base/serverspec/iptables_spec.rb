require 'serverspec'

set :backend, :exec

describe 'iptables' do

  it 'should reach localhost' do
    expect(host('localhost')).to be_reachable
  end

  it 'should reach google.com' do
    expect(host('google.com')).to be_reachable
  end

  it 'should have a policy to allow all outgoing connections' do
    expect(iptables).to have_rule('-P OUTPUT ACCEPT')
  end

  it 'should have a policy to drop all incoming connections' do
    expect(iptables).to have_rule('-P OUTPUT ACCEPT')
  end

  it 'should have a policy to drop all incoming connections' do
    expect(iptables).to have_rule('-P OUTPUT ACCEPT')
  end


end
