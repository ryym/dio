# frozen_string_literal: true

require 'spec_helper'

describe Dio::Container do
  describe '#register' do
    it 'registers a given block as a factory' do
      container = Dio::Container.new
      factory = -> { 'hello' }
      container.register(:greet, &factory)
      expect(container.factory(:greet)).to eq(factory)
    end
  end

  describe '#load' do
    it 'runs a factory to load an object' do
      container = Dio::Container.new
      container.register(:greet) do |someone = 'world'|
        "Hello, #{someone}"
      end
      expect(container.load(:greet)).to eq('Hello, world')
      expect(container.load(:greet, 'dio')).to eq('Hello, dio')
    end
  end
end
