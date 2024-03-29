
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ridgepole/replace_db_task/version"

Gem::Specification.new do |spec|
  spec.name          = "ridgepole-replace_db_task"
  spec.version       = Ridgepole::ReplaceDbTask::VERSION
  spec.authors       = ["Takahiro Ooishi"]
  spec.email         = ["taka0125@gmail.com"]

  spec.summary       = %q{Replace rails db:migrate to use ridgepole}
  spec.description   = %q{Replace rails db:migrate to use ridgepole}
  spec.homepage      = "https://github.com/taka0125/ridgepole-replace_db_task"

  spec.files         = Dir['LICENSE', 'README.md', 'lib/**/*', 'exe/**/*', 'sig/**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 5.0"
  spec.add_dependency "activesupport", ">= 5.0"
  spec.add_dependency "ridgepole", ">= 1.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
