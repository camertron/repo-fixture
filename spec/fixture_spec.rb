# encoding: UTF-8

require 'spec_helper'

include RepoFixture

describe Fixture do
  let(:fixture_class) { Fixture }
  let(:fixture) { Fixture.new(TmpRepo.new) }

  after(:each) do
    fixture.unlink
  end

  describe '#copy_files' do
    it 'copies files into the repo' do
      path = File.dirname(__FILE__)

      files_to_copy = Dir.glob(
        File.join(File.expand_path('./fixture_files', path), '**')
      )

      expect(files_to_copy.size).to be > 0

      fixture.copy_files(files_to_copy) do |file|
        file[(path.length + 1)..-1]
      end

      copied_files = Dir.glob("#{fixture.working_dir}/**/**").select do |file|
        File.file?(file)
      end

      expect(copied_files.size).to eq(files_to_copy.size)

      files_to_copy.each do |file_to_copy|
        expect(copied_files).to include(
          File.join(fixture.working_dir, file_to_copy[(path.length + 1)..-1])
        )
      end
    end
  end

  describe '#working_dir' do
    it 'forwards messages to the underlying TmpRepo instance' do
      expect(fixture).to respond_to(:working_dir)
      expect(fixture.working_dir.to_s).to start_with(Dir.tmpdir)
    end

    it "doesn't forward methods that TmpRepo doesn't understand" do
      expect(fixture).to_not respond_to(:foobar)
      expect(lambda { fixture.foobar }).to raise_error(NoMethodError)
    end
  end

  describe '#sh' do
    it 'executes arbitrary commands in the context of the working directory' do
      # Use include here instead of equality to avoid a test failure when
      # running on systems that add a prefix to their tmp directory (i.e. MacOS).
      expect(fixture.sh('pwd').strip).to include(fixture.working_dir.to_s)
    end
  end

  describe '#export' do
    it 'calls export on the given strategy class' do
      output_file = './test.zip'
      strategy = :zip

      mock.proxy(ZipStrategy).export(output_file, fixture)
      fixture.export(output_file, strategy)

      File.unlink(output_file)
    end
  end
end
