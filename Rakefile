# -*- mode: ruby; coding: utf-8 -*-
gem "rdoc"
require "rake"
require "rake/clean"
require "rubygems/package_task"

ENV["RDOCOPT"] = "" if ENV["RDOCOPT"]
CLOBBER.include("doc")

load "openrubyrmk-engine.gemspec"
Gem::PackageTask.new(ENGINE_GEMSPEC).define
