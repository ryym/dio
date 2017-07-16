# frozen_string_literal: true

require 'dio/injector'

module Dio
  # InjectorStore manages Dio::Injector instances.
  class InjectorStore
    def initialize(injectors = {})
      @injectors = injectors
    end

    def register(id, injector = nil)
      if @injectors.key?(id)
        injector ||= @injectors[id]
        if injector != @injectors[id]
          raise "Injector ID #{id} is already used for another injector"
        end
      elsif injector.nil?
        injector = Dio::Injector.new
      end

      @injectors[id] = injector
    end

    def load(id)
      @injectors[id]
    end

    def remove(id)
      @injectors.remove(id)
    end

    def ids
      @injectors.keys
    end
  end
end
