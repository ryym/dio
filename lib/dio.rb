# frozen_string_literal: true

require 'active_support/concern'
require 'dio/injector'
require 'dio/module_base'

# Dio provides DI functionality.
module Dio
  extend ActiveSupport::Concern
  extend Dio::ModuleBase

  @injector = Dio::Injector.new

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

  def self.use(injector = default_injector)
    Module.new do
      extend ActiveSupport::Concern
      extend ModuleBase
      @injector = injector
    end
  end
end
