# frozen_string_literal: true

require 'spec_helper'

describe Dio::Injector do
  describe '#register' do
    it 'registers a given block to its provider' do
      provider = spy('provider')
      injector = Dio::Injector.new(provider)
      injector.register(:greet) {}
      expect(provider).to have_received(:register)
    end

    it 'adds an injection process to object loading' do
      provider = Dio::Provider.new
      injector = Dio::Injector.new(provider)

      expect(injector).to receive(:inject)
      injector.register(:greet) {}
      provider.load(:greet)
    end

    it 'registers a given object as a block to its provider'

    context 'if both of object and block are given' do
      it 'raises an error'
    end
  end

  describe '#inject' do
    it 'injects dependencies using the internal method' do
      target = spy('target')
      Dio::Injector.new.inject(target)
      expect(target).to have_received(:__dio_inject__)
    end

    context 'if a given object is not be injectable' do
      it 'raises an error' do
        expect do
          Dio::Injector.new.inject([])
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe '#create' do
    it 'instantiate a given class with injection' do
      injector = Dio::Injector.new
      expect(injector).to receive(:inject)
      injector.create(String)
    end
  end
end
