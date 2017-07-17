# frozen_string_literal: true

require 'spec_helper'

describe Dio::Provider do
  describe '#register' do
    it 'registers a given block as a factory' do
      provider = Dio::Provider.new
      factory = -> { 'hello' }
      provider.register(:greet, &factory)
      expect(provider.factory(:greet)).to eq(factory)
    end
  end

  describe '#load' do
    it 'runs a factory to load an object' do
      provider = Dio::Provider.new
      provider.register(:greet) do |someone = 'world'|
        "Hello, #{someone}"
      end
      expect(provider.load(:greet)).to eq('Hello, world')
      expect(provider.load(:greet, 'dio')).to eq('Hello, dio')
    end

    context 'with load wrapping' do
      it 'runs load wrappers in the registered order' do
        provider = Dio::Provider.new
        provider.register(:greet) { 'hello' }

        logs = []
        Array.new(3) do |i|
          provider.wrap_load do |ctx|
            logs << i
            ctx.next
          end
        end

        greet = provider.load(:greet)
        expect(greet).to eq('hello')
        expect(logs).to eq([0, 1, 2])
      end
    end
  end
end
