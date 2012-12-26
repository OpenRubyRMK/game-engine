# -*- mode: ruby; coding: utf-8 -*-

ENGINE_GEMSPEC = Gem::Specification.new do |spec|

  # Project information
  spec.name        = "openrubyrmk-engine"
  spec.summary     = "The OpenRubyRMK’s game engine"
  spec.description =<<-DESCRIPTION
This is the OpenRubyRMK’s underlying game engine that
actually makes your games run.
  DESCRIPTION
  spec.version     = File.read("VERSION").strip.gsub("-", ".")
  spec.author      = "The OpenRubyRMK team"
  spec.email       = "openrubyrmk@googlemail.com"

  # Requirements
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 1.9.2"
  spec.add_dependency("ruby-tmx")
  spec.add_dependency("gosu")
  spec.add_development_dependency("turn")
  spec.add_development_dependency("paint")

  # Gem contents
  spec.files         = `git ls-files`.split("\n")
  spec.has_rdoc         = true
  spec.extra_rdoc_files = ["README.rdoc", "COPYING"]
  spec.rdoc_options << "-t" << "The Engine’s RDocs" << "-m" << "README.rdoc"

end
