# frozen_string_literal: true

require 'forwardable'
require 'dio/provider'
require 'dio/loader'

module Dio
  # Injector executes dependency injection.
  class Injector
    extend Forwardable

    def_delegators :@provider, :register, :wrap_load, :clear_wrap_loads

    def initialize(provider = Dio::Provider.new)
      @provider = provider
      @original_provider = nil
    end

    def inject(target)
      unless target.respond_to?(:__dio_inject__)
        raise 'The given object does not include Dio module'
      end
      loader = Loader.new(@provider, target)
      target.__dio_inject__(loader)
      target
    end

    def override(deps)
      unless overridden?
        @original_provider = @provider
        @provider = @provider.dup
      end
      @provider.register_all(deps)
    end

    def remove_overrides
      return unless overridden?
      @provider = @original_provider
      @original_provider = nil
    end

    def overridden?
      !@original_provider.nil?
    end
  end
end
