# frozen_string_literal: true

require 'spec_helper'

describe Dio::ModuleBase do
  State = Dio::State
  Injector = Dio::Injector
  Equip = Dio::Equip

  describe '.injector' do
    it 'returns the default injector' do
      injector = Injector.new
      dio = Equip.equip_dio(injector_id: :default, injector: injector)
      expect(dio.injector).to eq(injector)
    end

    context 'when a key is given' do
      it 'returns an injector associated with the key' do
        injector = Injector.new
        state = State.new
        state.register_injector(:hello, injector)
        dio = Equip.equip_dio(injector_id: :a, state: state)
        expect(dio.injector(:hello)).to eq(injector)
      end
    end
  end

  context 'when included' do
    def new_includer(**args)
      args[:injector_id] = :test unless args.key?(:injector_id)
      Class.new do
        include Equip.equip_dio(**args)
      end
    end

    describe '.inject' do
      it 'stores a given injection block' do
        clazz = new_includer
        injection_proc = -> {}
        clazz.inject(&injection_proc)
        expect(clazz.__dio_injection_proc__).to eq(injection_proc)
      end
    end

    describe '.injectable' do
      def includer_with_mock
        injector = spy('test_injector')
        clazz = new_includer(injector: injector)
        [clazz, injector]
      end

      it 'works without arguments' do
        clazz, injector = includer_with_mock
        clazz.injectable
        expect(injector).to have_received(:register).with(clazz)
      end

      it 'accepts factory block' do
        clazz, injector = includer_with_mock
        clazz.injectable { 'hello' }
        expect(injector).to have_received(:register) do |key, &block|
          expect([key, block.call]).to eq([clazz, 'hello'])
        end
      end

      it 'accepts subkey' do
        clazz, injector = includer_with_mock
        clazz.injectable(:hello)
        expect(injector).to have_received(:register).with([clazz, :hello])
      end

      it 'accepts subkey and factory' do
        clazz, injector = includer_with_mock
        clazz.injectable(:hello) { 'hello' }
        expect(injector).to have_received(:register) do |key, &block|
          expect([key, block.call]).to eq([[clazz, :hello], 'hello'])
        end
      end
    end

    describe '.provide' do
      it 'registers a given factory' do
        injector = spy('test_injector')
        clazz = new_includer(injector: injector)
        clazz.provide(:module_a) { 'hello' }
        expect(injector).to have_received(:register).with(:module_a)
      end
    end

    describe '.__dio_inject__' do
      it 'executes registered injection block' do
        got_loader = nil
        injection_proc = ->(loader) { got_loader = loader }
        clazz = new_includer
        clazz.instance_variable_set(:@__dio_injection_proc__, injection_proc)

        loader = double('loader')
        clazz.new.__dio_inject__(loader)
        expect(got_loader).to eq(loader)
      end
    end
  end
end
