require 'repo-fixture'

zipfile = '/Users/legrandfromage/Desktop/fixture.zip'

fixture = RepoFixture.create do |fix|
  fix.copy_files(Dir.glob('./spec/fixture_files/**')) do |file|
    file.gsub(/\A\.\/spec\/fixture_files/, '')
  end

  fix.add_all
  fix.commit('Committing all files foobarbaz')
end

fixture.export(zipfile)
fixture.unlink

fixture = RepoFixture.load(zipfile)
puts fixture.sh('ls -lah')
fixture.unlink
File.unlink(zipfile)
