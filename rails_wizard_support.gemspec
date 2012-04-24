Gem::Specification.new do |s|
	s.name = "rails_wizard_support"
	s.version = "0.1.0"
	s.summary = "Support library for writing wizard models in Rails"
	s.email = "hongli@phusion.nl"
	s.homepage = "https://github.com/phusion/rails_wizard_support"
	s.description = "Support library for writing wizard models in Rails."
  s.authors = ["Hongli Lai"]
	s.add_dependency("activesupport", ">= 3.0.0")
	
	s.files = Dir[
		"rails_wizard_support.gemspec",
    "lib/**/*"
	]
end
