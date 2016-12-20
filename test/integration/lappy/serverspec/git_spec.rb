require 'serverspec'

set :backend, :exec

describe 'git' do

  it 'should be instaled' do
    expect(package('git')).to be_installed
  end

  ['/home/alex/git/blog', '/home/alex/git/emacs', '/home/alex/.emacs.d'].each do |repo|
    it "should have cloned #{repo} as alex" do
      expect(file(repo)).to be_directory
      expect(file(repo)).to be_owned_by 'alex'
    end
  end

end
