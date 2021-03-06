# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{typhoeus_spec_cache}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Balatero"]
  s.date = %q{2010-05-20}
  s.description = %q{A plugin to help you dynamically manage HTTP caching for your specs.}
  s.email = %q{dbalatero@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown",
     "README.markdown.html"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "lib/typhoeus/instance_exec.rb",
     "lib/typhoeus/response_marshalling.rb",
     "lib/typhoeus/spec_cache.rb",
     "lib/typhoeus/spec_cache_macros.rb",
     "lib/typhoeus_spec_cache.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/typhoeus/spec_cache_macros_spec.rb",
     "spec/typhoeus/spec_cache_spec.rb",
     "typhoeus_spec_cache.gemspec"
  ]
  s.homepage = %q{http://github.com/dbalatero/typhoeus_spec_cache}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A plugin to help you dynamically manage HTTP caching for your specs.}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/typhoeus/spec_cache_macros_spec.rb",
     "spec/typhoeus/spec_cache_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

