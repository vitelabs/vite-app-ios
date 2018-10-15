# -*- encoding: utf-8 -*-
# stub: danger 5.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "danger".freeze
  s.version = "5.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Orta Therox".freeze, "Juanito Fatas".freeze]
  s.date = "2018-10-09"
  s.description = "Stop Saying 'You Forgot To\u2026' in Code Review".freeze
  s.email = ["orta.therox@gmail.com".freeze, "katehuang0320@gmail.com".freeze]
  s.executables = ["danger".freeze]
  s.files = ["bin/danger".freeze]
  s.homepage = "https://github.com/danger/danger".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "2.6.14".freeze
  s.summary = "Like Unit Tests, but for your Team Culture.".freeze

  s.installed_by_version = "2.6.14" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<claide>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<claide-plugins>.freeze, [">= 0.9.2"])
      s.add_runtime_dependency(%q<git>.freeze, ["~> 1.5"])
      s.add_runtime_dependency(%q<colored2>.freeze, ["~> 3.1"])
      s.add_runtime_dependency(%q<faraday>.freeze, ["~> 0.9"])
      s.add_runtime_dependency(%q<faraday-http-cache>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<octokit>.freeze, ["~> 4.7"])
      s.add_runtime_dependency(%q<kramdown>.freeze, ["~> 1.5"])
      s.add_runtime_dependency(%q<terminal-table>.freeze, ["~> 1"])
      s.add_runtime_dependency(%q<cork>.freeze, ["~> 0.1"])
      s.add_runtime_dependency(%q<no_proxy_fix>.freeze, [">= 0"])
    else
      s.add_dependency(%q<claide>.freeze, ["~> 1.0"])
      s.add_dependency(%q<claide-plugins>.freeze, [">= 0.9.2"])
      s.add_dependency(%q<git>.freeze, ["~> 1.5"])
      s.add_dependency(%q<colored2>.freeze, ["~> 3.1"])
      s.add_dependency(%q<faraday>.freeze, ["~> 0.9"])
      s.add_dependency(%q<faraday-http-cache>.freeze, ["~> 1.0"])
      s.add_dependency(%q<octokit>.freeze, ["~> 4.7"])
      s.add_dependency(%q<kramdown>.freeze, ["~> 1.5"])
      s.add_dependency(%q<terminal-table>.freeze, ["~> 1"])
      s.add_dependency(%q<cork>.freeze, ["~> 0.1"])
      s.add_dependency(%q<no_proxy_fix>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<claide>.freeze, ["~> 1.0"])
    s.add_dependency(%q<claide-plugins>.freeze, [">= 0.9.2"])
    s.add_dependency(%q<git>.freeze, ["~> 1.5"])
    s.add_dependency(%q<colored2>.freeze, ["~> 3.1"])
    s.add_dependency(%q<faraday>.freeze, ["~> 0.9"])
    s.add_dependency(%q<faraday-http-cache>.freeze, ["~> 1.0"])
    s.add_dependency(%q<octokit>.freeze, ["~> 4.7"])
    s.add_dependency(%q<kramdown>.freeze, ["~> 1.5"])
    s.add_dependency(%q<terminal-table>.freeze, ["~> 1"])
    s.add_dependency(%q<cork>.freeze, ["~> 0.1"])
    s.add_dependency(%q<no_proxy_fix>.freeze, [">= 0"])
  end
end
