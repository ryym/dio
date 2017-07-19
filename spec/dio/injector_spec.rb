# frozen_string_literal: true

require 'spec_helper'

describe Dio::Injector do
  describe '#register' do
    it 'registers a given block to its container' do
      container = spy('container')
      injector = Dio::Injector.new(container)
      injector.register(:greet) {}
      expect(container).to have_received(:register)
    end

    it 'adds an injection process to object loading' do
      container = Dio::Container.new
      injector = Dio::Injector.new(container)

      greet = double('greet')
      allow(greet).to receive(:__dio_inject__)

      expect(injector).to receive(:inject)
      injector.register(:greet) { greet }
      container.load(:greet)
    end

    it 'registers a given object as a block to its container' do
      container = Dio::Container.new
      injector = Dio::Injector.new(container)

      injector.register(:greet, :hello)
      expect(container.load(:greet)).to eq(:hello)
    end

    context 'if both of object and block are given' do
      it 'raises an error' do
        expect do
          Dio::Injector.new.register(:key, :value) {}
        end.to raise_error(ArgumentError)
      end
    end

    context 'if neither object nor block is given' do
      it 'raises an error' do
        expect do
          Dio::Injector.new.register(:key)
        end.to raise_error(ArgumentError)
      end
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
