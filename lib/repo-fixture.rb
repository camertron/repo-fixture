# encoding: UTF-8

require 'tmp-repo'

module RepoFixture
  autoload :Fixture,     'repo-fixture/fixture'
  autoload :ZipStrategy, 'repo-fixture/zip_strategy'

  def self.create
    fixture = Fixture.new(TmpRepo.new)
    yield fixture
    fixture
  end

  def self.load(file, strategy = Fixture::DEFAULT_STRATEGY)
    strategy_class_for(strategy).load(file)
  end

  def self.strategy_class_for(strategy)
    const_str = "#{camelize(strategy.to_s)}Strategy"
    if RepoFixture.const_defined?(const_str)
      RepoFixture.const_get(const_str)
    else
      raise ArgumentError, "'#{strategy}' isn't a valid export strategy."
    end
  end

  private

  def self.camelize(str)
    str.gsub(/(^\w|[-_]\w)/) { $1[-1].upcase }
  end
end
