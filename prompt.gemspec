$: << File.join(File.dirname(__FILE__), "lib")
require 'prompt'

Gem::Specification.new do |s|
  s.name        = 'prompt'
  s.version     = Prompt::VERSION
  s.summary     = 'A micro framework that makes it easy to build slick command-line applications'
  s.description = 'Prompt makes it easy to build slick command-line applications with tab completion, command history, and built-in help'
  s.authors     = ["Mike Smith"]
  s.email       = 'mike@sticknet.net'

  s.require_paths = ["lib"]
  s.files         = ["README.md", "CHANGELOG.md", "LICENSE.txt"]
  s.files         += Dir["lib/**/*.rb"]
  s.files         += Dir["spec/**/*.rb"]
  s.files         += Dir["examples/**/*"]
  s.homepage      = 'http://github.com/mudynamics/prompt'

  s.required_ruby_version = '>= 1.9.2' # because Readline.line_buffer is required
end
