# encoding: UTF-8

require 'zip'
require 'fileutils'

module RepoFixture
  class ZipStrategy

    class << self
      def export(output_file, fixture)
        repo = fixture.repo
        working_dir_path_length = repo.working_dir.to_s.length
        Zip::File.open(output_file, Zip::File::CREATE) do |zipfile|
          Dir.glob("#{repo.working_dir}/**/**", File::FNM_DOTMATCH).each do |file|
            if File.file?(file)
              # plus 1 to remove the leading slash
              relative_file = file[(working_dir_path_length + 1)..-1]
              zipfile.add(relative_file, file)
            end
          end
        end
      end

      def load(file)
        output_dir = TmpRepo.random_dir

        Zip::File.open(file) do |zipfile|
          zipfile.each do |entry|
            output_file = File.join(output_dir, entry.name)
            FileUtils.mkdir_p(File.dirname(output_file))
            entry.extract(output_file)
          end
        end

        Fixture.new(
          TmpRepo.new(output_dir)
        )
      end
    end

  end
end
