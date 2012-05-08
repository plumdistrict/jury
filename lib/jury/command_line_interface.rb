require 'fileutils'
require 'jury/tchk'

require 'pp'

$VALID_COMMANDS = %w[help init]


module Jury
  class CommandLineInterface
    include Jury::Tchk

    def create_filesystem   # CB(2), BB(4)
      # PRECONDITION -- current_directory not inside/under template_directory
      current_directory = Dir.pwd
      template_directory = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'template'))
      set_of_files = Dir.glob(File.join(template_directory, "*"))
      FileUtils.cp_r set_of_files, current_directory

      # The above copy will not create empty directories, it seems.  Either that,
      # or gem metadata refuses to accept that an empty template/spec directory
      # holds value to me.  To work around this problem, we will need to create
      # this directory manually if it doesn't already exist.
      spec_directory = File.join(current_directory, "spec")
      FileUtils.mkdir(spec_directory) if !File.directory?(spec_directory)
    end

    def show_help_message   # BB(3,1), BB(3,3)
      puts <<EOM
USAGE: #{@argv[0]} <command> <...>

Commands supported includes:
  init - initialize a new Jury instance.
  help - show this message.
EOM
    end

    def main(argv)  # US(3)
      type_error if !is_array_of_T(argv, String, 1)

      @argv = argv
      if !argv[1].nil? then
        command = argv[1].downcase
      else
        command = 'help'
      end

      case command
      when 'init'
        create_filesystem  # BB(3,2)
      else
        show_help_message  # BB(3,1) /\ BB(3,3)
      end
    end
  end
end
