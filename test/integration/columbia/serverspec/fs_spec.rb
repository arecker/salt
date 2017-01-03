require 'serverspec'

set :backend, :exec

describe 'fs' do
  [
    'bin',
    'data',
    'public/alexrecker.com',
    'public/alexandmarissa.com',
    'public/bobrosssearch.com'
  ].each do |path|
    it "should have created #{path} as alex" do
      target = file(File.join('/home/alex', path))
      expect(target).to be_directory
      expect(target).to be_owned_by('alex')
    end
  end
end
