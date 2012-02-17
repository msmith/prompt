$: << File.join(File.dirname(__FILE__), "lib")
require 'prompt'

Gem::Specification.new do |s|
  s.name        = 'prompt'
  s.version     = Prompt::VERSION
  s.summary     = 'A small framework that makes it easy to build slick command-line applications'
  s.description = 'Prompt makes it easy to build slick command-line applications with Tab Completion, Command History, and Built-in Help'
  s.authors     = ["Mike Smith"]
  s.email       = 'mike@sticknet.net'

  s.require_paths = ["lib"]
  s.files         = ["README.md"]
  s.files         += Dir["lib/**/*.rb"]
  s.files         += Dir["spec/**/*.rb"]
  s.files         += Dir["examples/**/*"]
  s.homepage      = 'http://github.com/mudynamics/prompt'

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
end
