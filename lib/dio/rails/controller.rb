# frozen_string_literal: true

require 'dio'

module Dio
  module Rails
    # Dio::Rails::Controller enables to inject dependencies to
    # Rails controllers.
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
