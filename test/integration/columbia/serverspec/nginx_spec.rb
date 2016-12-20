require 'serverspec'

set :backend, :exec

describe 'nginx' do

  it 'should be installed' do
    expect(package('nginx')).to be_installed
  end

  it 'should be running' do
    expect(service('nginx')).to be_running
  end

  it 'should be enabled' do
    expect(service('nginx')).to be_enabled
  end

  it 'should be configured' do
    expect(file('/etc/nginx/nginx.conf')).to be_file
  end

  it 'should be valid' do
    expect(command('nginx -t').exit_status).to eq(0)
  end

  it 'should be defaulted' do
    expect(host('localhost')).to be_resolvable
    expect(command('curl --silent localhost').stdout).to match('Anakin')
  end

  it 'should serve bobrosssearch.local' do
    expect(host('bobrosssearch.local')).to be_resolvable
    expect(host('bobrosssearch.local').ipaddress).to eq('127.0.0.1')
    expect(command('curl --silent -L --insecure https://bobrosssearch.local').stdout).to match('Bob Ross Search')
  end

  it 'should redirect http://bobrosssearch.local to https://bobrosssearch.local' do
    expect(command('curl --silent -L --insecure http://bobrosssearch.local').stdout).to match('Bob Ross Search')
  end

  it 'should serve reckerdogs.local' do
    expect(host('reckerdogs.local')).to be_resolvable
    expect(host('reckerdogs.local').ipaddress).to eq('127.0.0.1')
    expect(command('curl --silent -L --insecure https://reckerdogs.local').stdout).to match('WordPress')
  end

  it 'should serve alexrecker.com' do
    expect(host('alexrecker.local')).to be_resolvable
    expect(host('alexrecker.local').ipaddress).to eq('127.0.0.1')
  end

  it 'should proxy to random.png' do
    expect(command('curl --silent -L --insecure https://alexrecker.local/random.png').stdout).to match('No pictures to pick from')
  end

end
