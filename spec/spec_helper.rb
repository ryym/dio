# frozen_string_literal: true

require 'dio'
require 'dio/rails'

RSpec.configure do |conf|
  conf.before(:each) do
    Dio.reset_state
  end
end
