require 'serverspec'

set :backend, :exec

describe host('localhost') do
  it { should be_reachable }
end

describe host('google.com') do
  it { should be_reachable }
end

describe iptables do
  it { should have_rule('-P INPUT DROP') }
  it { should have_rule('-P OUTPUT ACCEPT') }
end
