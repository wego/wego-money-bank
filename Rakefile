require "bundler/gem_tasks"
task :default => :spec

desc "Open an irb session preloaded with this library"
task :console do
  require 'wego-money-bank'
  require 'pry'
  Pry.start
end
