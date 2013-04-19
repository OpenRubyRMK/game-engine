# -*- mode: ruby; coding: utf-8 -*-
gem "rdoc"
require "rake"
require "rake/clean"
require "rake/testtask"
require "rubygems/package_task"

ENV["RDOCOPT"] = "" if ENV["RDOCOPT"]
CLOBBER.include("doc")

load "openrubyrmk-engine.gemspec"

Gem::PackageTask.new(ENGINE_GEMSPEC)do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
  pkg.need_tar_bz2 = true
  pkg.need_tar_gz = true
end


Rake::TestTask.new do |t|
    t.libs =["."]
    def t.run_code
      "-e \"require 'rake'; ARGV.each{|f| ruby f}\""
    end
    t.test_files = FileList["data/scripts/2.0/tests/test*.rb"]
end