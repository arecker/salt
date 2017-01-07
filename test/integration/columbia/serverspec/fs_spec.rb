require 'serverspec'

set :backend, :exec

DIRECTORIES = [
  '/home/alex/bin',
  '/home/alex/images',
  '/home/alex/public/alexrecker.com',
  '/home/alex/public/alexandmarissa.com'
]

DIRECTORIES.each do |d|
  describe file(d) do
    it { should be_directory }
    it { should be_owned_by('alex') }
  end
end
