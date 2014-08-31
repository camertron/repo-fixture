# encoding: UTF-8

require 'spec_helper'

include RepoFixture

describe ZipStrategy do
  let(:fixture_class) { RepoFixture }

  describe '#export' do
    it 'creates a zip file containing all the files in the repo' do
      fixture_file = './test.zip'

      fixture = fixture_class.create do |fixture|
        fixture.create_file('myfile.txt') { |f| f.write('foobarbaz') }
        fixture.add_all
        fixture.commit('Committing a foo file')
      end

      fixture.export(fixture_file, :zip)

      Zip::File.open(fixture_file) do |zipfile|
        zipfile.glob('myfile.txt').first.tap do |entry|
          expect(entry.get_input_stream.read).to eq('foobarbaz')
        end

        expect(zipfile.glob('.git/COMMIT_EDITMSG').first).to_not be_nil
      end

      fixture.unlink
      File.unlink(fixture_file)
    end
  end

  context 'with a created fixture' do
    before(:each) do
      fixture = fixture_class.create do |fixture|
        fixture.create_file('myfile.txt') { |f| f.write('foobarbaz') }
        fixture.add_all
        fixture.commit('Committing a foo file')
      end

      @fixture_file = Pathname('./test.zip')
      fixture.export(@fixture_file, :zip)
      expect(@fixture_file).to exist
      fixture.unlink
    end

    after(:each) do
      File.unlink(@fixture_file)
    end

    describe '#load' do
      it 'should load a fixture using the given strategy' do
        fixture = fixture_class.load(@fixture_file)

        Dir.glob("#{fixture.working_dir}/**/**", File::FNM_DOTMATCH).tap do |files|
          ['.git/COMMIT_EDITMSG', 'myfile.txt'].each do |expected_file|
            expect(files).to include(File.join(fixture.working_dir, expected_file))
          end
        end

        fixture.unlink
      end
    end
  end
end
