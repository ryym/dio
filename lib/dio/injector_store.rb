# frozen_string_literal: true

require 'dio/injector'

module Dio
  # InjectorStore manages Dio::Injector instances.
  class InjectorStore
    def initialize(injectors = {})
      @injectors = injectors
    end

    def register_and_load(id, injector = nil)
      injector ||= @injectors[id]
      if injector.nil?
        injector = Dio::Injector.new
      elsif injector != @injectors[id]
        raise "Injector ID #{id} is already used for another injector"
      end
      @injectors[id] = injector
    end

    def load(id)
      @injectors[id]
    end

    def delete(id)
      @injectors.delete(id)
    end
  end
end
