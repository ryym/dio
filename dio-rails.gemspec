# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'dio/rails/version'

Gem::Specification.new do |s|
  s.name        = 'dio-rails'
  s.version     = Dio::Rails::VERSION
  s.authors     = ['ryym']
  s.email       = ['ryym.64@gmail.com']
  s.homepage    = 'https://github.com/ryym/dio'
  s.summary     = 'Dependency Injection for Rails'
  s.description = 'Dependency Injection for Rails'
  s.license     = 'MIT'

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1.2'

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'sqlite3'
end
