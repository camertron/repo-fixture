# encoding: UTF-8

require 'spec_helper'
require 'pathname'

include RepoFixture

describe RepoFixture do
  let(:fixture_class) { RepoFixture }

  describe '#create' do
    it 'yields a fixture object' do
      fixture_class.create do |fixture|
        expect(fixture).to be_a(Fixture)
      end
    end
  end

  describe '#load' do
    it 'calls load on the appropriate strategy class' do
      file = './test.zip'
      mock(ZipStrategy).load(file)
      fixture_class.load(file)
    end
  end

  describe '#strategy_class_for' do
    it 'returns the strategy class for the strategy name' do
      expect(fixture_class.strategy_class_for(:zip)).to eq(ZipStrategy)
    end

    it "raises an error if the strategy doesn't exist" do
      expect(lambda { fixture_class.strategy_class_for(:foo) }).to raise_error(ArgumentError)
    end
  end
end
