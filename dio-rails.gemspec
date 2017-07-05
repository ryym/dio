$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dio/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dio-rails"
  s.version     = Dio::Rails::VERSION
  s.authors     = ["ryym"]
  s.email       = ["ryym.64@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Dio::Rails."
  s.description = "TODO: Description of Dio::Rails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.2"

  s.add_development_dependency "sqlite3"
end
