# frozen_string_literal: true

require 'dio'

module Dio
  module Rails
    # Dio::Rails::Model enables to inject dependencies to Rails models.
    # Internally, this just add a `after_initialize` that injects dependencies.
    #
    # @example
    #   class User < ApplicationRecord
    #     include Dio::Rails::Model
    #
    #     inject do |dio|
    #       @api = dio.load(UsersAPI)
    #     end
    #
    #     # ...
    #   end
    module Model
      extend ActiveSupport::Concern

      DioForModel = Dio.use(:default)
      include DioForModel
      private_constant :DioForModel

      included do
        after_initialize do |model|
          DioForModel.inject(model)
        end
      end
    end
  end
end
