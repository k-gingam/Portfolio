# -*- encoding: utf-8 -*-
# stub: libv8-node 18.19.0.0 x86_64-linux lib ext

Gem::Specification.new do |s|
  s.name = "libv8-node".freeze
  s.version = "18.19.0.0"
  s.platform = "x86_64-linux".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze, "ext".freeze]
  s.authors = ["".freeze]
  s.date = "2024-03-23"
  s.description = "Node.JS's V8 JavaScript engine for multiplatform goodness".freeze
  s.email = ["".freeze]
  s.homepage = "https://github.com/rubyjs/libv8-node".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Node.JS's V8 JavaScript engine".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<rake>.freeze, ["~> 12"])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.44.0"])
end
