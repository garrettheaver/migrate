require_relative './lib/migrate'

Gem::Specification.new do |s|
  s.name = 'migrate'
  s.version = Migrate::VERSION
  s.licenses = ['MIT']
  s.summary = 'Basic SQL only migration tool'
  s.description = 'A basic tool for managing SQL database migrations'
  s.authors = ['Garrett Heaver']
  s.files = Dir['{lib, bin}/**/*'] + %w(LICENSE)
  s.executables << 'migrate'
  s.require_paths = ['lib']
  s.homepage = 'https://github.com/garrettheaver/migrate'
  s.add_dependency 'sequel', '~> 4.36', '>= 4.36.0'
  s.add_development_dependency 'rspec', '~> 3.5', '>= 3.5.0'
end

