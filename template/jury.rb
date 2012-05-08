# Include Capybara DSL

require 'capybara/rspec'
include Capybara::DSL

# Support for multiple, concurrently-running Jury instances.

begin
  e = ENV['CAPYBARA_PORT_OFFSET'].to_i
rescue
  e = 0
end
Capybara.server_port = 8800 + e

# Include commonly used testing tools

require 'lib/page_object'
require 'lib/helper'
require 'lib/user'
require 'lib/credit_card'

# Make all the available helpers known to Jury.

Dir["lib/helpers/*_helper.rb"].each {|file| require file}

# Import all of our configuration settings.

unless ENV['JURY_CONFIG'] then
  puts <<-EOH

You must define the JURY_CONFIG environment variable first.  This environment
variable refers to a specific configuration file.  For example, if you have a
configuration file named config-beta.rb inside your Jury project's directory,
then you can invoke your tests like so:

    JURY_CONFIG=config-beta rspec -I.  # ...etc...

Similarly, if you have a configuration located outside of the Jury project's
directory, you can invoke as follows:

    JURY_CONFIG=/tmp/my_config.rb rspec -I.  # ..etc..

EOH
  exit 1
end
require ENV['JURY_CONFIG']

