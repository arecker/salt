require 'serverspec'

set :backend, :exec

describe 'certbot' do

  it 'should be installed' do
    expect(package('certbot')).to be_installed
  end

  it 'should be scheduled' do
    entry = '* 1 * * 1 certbot renew --quiet --pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx"'
    expect(cron).to have_entry(entry)
  end

end
