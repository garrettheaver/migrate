require_relative './lib/migrate'

Gem::Specification.new do |s|
  s.name = 'migrate'
  s.version = Migrate::VERSION
  s.licenses = ['MIT']
  s.summary = 'Basic database migration tool'
  s.description = 'A basic tool for managing database migrations'
  s.authors = ['Garrett Heaver']
  s.files = Dir['{lib, bin}/**/*'] + %w(LICENSE)
  s.executables << 'migrate'
  s.require_paths = ['lib']
  s.homepage = 'https://github.com/garrettheaver/migrate'
  s.add_dependency 'sequel', '~> 5.101', '>= 5.101.0'
  s.add_development_dependency 'rspec', '~> 3.13'
end

