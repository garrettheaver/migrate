Gem::Specification.new do |s|
  s.name = 'migrate'
  s.version = '0.1.1'
  s.licenses = ['MIT']
  s.summary = 'Basic SQL only migration tool'
  s.description = 'A basic tool for managing SQL database migrations'
  s.authors = ['Garrett Heaver']
  s.files = Dir['lib/**/*'] + %w(LICENSE)
  s.require_paths = ['lib']
  s.homepage = 'https://github.com/garrettheaver/migrate'
end

