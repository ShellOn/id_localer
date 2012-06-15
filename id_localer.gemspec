# -*- encoding: utf-8 -*-
require File.expand_path('../lib/id_localer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["ShellChen"]
  gem.email         = ["chengjhong@gmail.com"]
  gem.description   = %q{IdLocaler is a rack middleware that set the i18n.locale for your application}
  gem.summary       = %q{IdLocaler set the language by detecting the url params (Ex: www.domain.com/es), cookie locale's key value and the HTTP_ACCEPT_LANGUAGE}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "id_localer"
  gem.require_paths = ["lib"]
  gem.version       = IdLocaler::VERSION
end
