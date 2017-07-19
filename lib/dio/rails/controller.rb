# frozen_string_literal: true

require 'dio'

module Dio
  module Rails
    # Dio::Rails::Controller enables to inject dependencies to Rails controllers.
    # Internally, this just add a `before_action` that injects dependencies.
    #
    # @example
    #   class UsersController < ApplicationController
    #     include Dio::Rails::Controller
    #
    #     inject do |dio|
    #       @api = dio.load(UsersAPI)
    #     end
    #
    #     # ...
    #   end
    module Controller
      extend ActiveSupport::Concern

      DioForController = Dio.use(:default)
      include DioForController

      included do
        before_action do
          DioForController.inject(self)
        end
      end
    end
  end
end
