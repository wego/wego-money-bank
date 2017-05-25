lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wego_money_bank/version'

Gem::Specification.new do |s|
  s.name = 'wego-money-bank'
  s.date = Time.now.utc.strftime('%Y-%m-%d')
  s.version = WegoMoneyBank::VERSION
  s.homepage = "https://github.com/wego/{s.name}"
  s.authors = ['Michael Valladolid']
  s.email = 'geeks@wego.com'
  s.description = 'This gem provides functionality for calculating '\
    'exchange rates using the wego currency exchange rate API.'
  s.summary = 'Wego money bank'

  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "money", "~> 6.9"

  s.add_development_dependency "bundler", "~> 1.15"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "monetize", "~> 1.7.0"

  s.add_development_dependency "rspec"
  s.add_development_dependency "webmock", "~> 3.0.1"
  s.add_development_dependency "rspec-nc"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-remote"
  s.add_development_dependency "pry-nav"
end
