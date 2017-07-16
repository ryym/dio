# frozen_string_literal: true

require 'active_support/concern'
require 'dio/injector'
require 'dio/injector_store'
require 'dio/dio_base'

# Dio provides DI functionality.
module Dio
  extend ActiveSupport::Concern
  extend Dio::DioBase

  @injector = Dio::Injector.new
  @injectors = InjectorStore.new(default: @injector)

  def self.injector(id = :default)
    @injectors.load(id)
  end

  def self.default_injector
    @injector
  end

  def self.wrap_load(&loader)
    @injector.wrap_load(&loader)
  end

  def self.clear_wrap_loads
    @injector.clear_wrap_loads
  end

  def self.override(alts)
    @injector.override(alts)
  end

  def self.remove_overrides
    @injector.remove_overrides
  end

  def self.with(deps)
    @injector.with(deps)
  end

  def self.use(injector_id, injector = nil)
    injectors = @injectors

    Module.new do
      extend ActiveSupport::Concern
      extend DioBase

      @injector = injectors.register(injector_id, injector)

      def injector(key = nil)
        key.nil? ? @injector : Dio.injector(key)
      end
    end
  end
end
