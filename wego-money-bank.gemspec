version_file = 'lib/wego_money_bank/version'
require File.expand_path("", __FILE__)

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

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday_middleware", "0.10.0"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
end
