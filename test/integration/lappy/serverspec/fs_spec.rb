require 'serverspec'

set :backend, :exec

describe 'fs' do

  it 'should have created /home/alex/bin as alex' do
    bin = file('/home/alex/bin')
    expect(bin).to be_directory
    expect(bin).to be_owned_by('alex')
  end

end
