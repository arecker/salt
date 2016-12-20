require 'serverspec'

set :backend, :exec

describe 'user' do

  it 'should exist' do
    expect(user('alex')).to exist
  end

  it 'should be a sudoer' do
    expect(user('alex')).to belong_to_group('sudo')
  end

  it 'should have a home directory' do
    home = file('/home/alex')
    expect(home).to exist
    expect(home).to be_directory
  end

  it 'should have a login shell' do
    expect(user('alex')).to have_login_shell('/bin/bash')
  end

  it 'should not have an authorized key' do
    expect(file('/home/alex/.ssh/authorized_keys')).to_not exist
  end


end
