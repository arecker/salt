require 'serverspec'

set :backend, :exec

describe 'git' do
  it 'should be instaled' do
    expect(package('git')).to be_installed
  end
end
