# encoding: UTF-8

require 'fileutils'

module RepoFixture

  class Fixture
    DEFAULT_STRATEGY = :zip

    attr_reader :repo

    def initialize(repo)
      @repo = repo

      if repo.git('config --global user.email').strip.empty?
        repo.git('config --global user.email "fake@example.com"')
      end

      if repo.git('config --global user.name').strip.empty?
        repo.git('config --global user.name "Fake Person"')
      end
    end

    # Copies files into the repo.
    # Optional block receives each file, return value is the desired path inside the archive.
    def copy_files(files)
      Array(files).each do |file|
        output_file = if block_given?
          yield file
        else
          file
        end

        output_file = File.join(repo.working_dir, output_file)
        FileUtils.mkdir_p(File.dirname(output_file))
        FileUtils.cp(file, output_file)
      end
    end

    def respond_to?(method)
      repo.respond_to?(method)
    end

    def method_missing(method, *args, &block)
      repo.send(method, *args, &block)
    end

    def export(export_file, strategy = DEFAULT_STRATEGY)
      strategy_class_for(strategy).export(export_file, self)
    end

    def sh(command)
      repo.in_repo { `#{command}` }
    end

    private

    def strategy_class_for(strategy)
      RepoFixture.strategy_class_for(strategy)
    end
  end

end
