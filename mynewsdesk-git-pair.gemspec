# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "git-pair/version"

Gem::Specification.new do |s|
  s.name        = "mynewsdesk-git-pair"
  s.version     = Git::Pair::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Kampmeier", "Adam McCrea", "Jon Distad", "ingemar", "Jonas Forsberg"]
  s.email       = "dev@mynewsdesk.com"
  s.homepage    = "http://github.com/mynewsdesk/git-pair"
  s.summary     = "Configure git to commit as more than one author"
  s.description = "A git porcelain for pair programming. Changes git-config's user.name and user.email settings so you can commit as more than one author."


  s.rubyforge_project = "git-pair"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'cucumber', "~> 1.0"
  s.add_development_dependency 'rspec', "~> 2.6.0"
end
