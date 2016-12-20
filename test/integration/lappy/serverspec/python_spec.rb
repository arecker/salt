require 'serverspec'

set :backend, :exec

describe 'python' do

  it 'should be installed' do
    expect(package('python')).to be_installed
  end

  it 'should be callable' do
    expect(command('python --version').exit_status).to eq(0)
  end

  it 'should be virtualizeable' do
    expect(command('virtualenv --version').exit_status).to eq(0)
  end

end
