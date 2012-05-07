Gem::Specification.new do |s|
  s.name          = "jury"
  s.version       = "0.0.1"
  s.date          = "2012-05-07"
  s.summary       = "A minimalist acceptance testing framework using page object pattern."
  s.description   = <<EOSTR
A minimalist acceptance testing framework using page object pattern.  It
greatly simplifies the task of constructing, using, and maintaining page
objects in a Ruby/Capybara/RSpec environment.
EOSTR
  s.authors       = ["Samuel A. Falvo II"]
  s.email         = 'kc5tja@arrl.net'
  s.files         = Dir['lib/*.rb'] + Dir['lib/**/*.rb'] + Dir['bin/*']
  s.bindir        = 'bin'
  s.executables   = ['jury']
  s.homepage      = "http://github.com/plumdistrict/jury"
end

