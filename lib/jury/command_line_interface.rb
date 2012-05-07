require 'jury/tchk'


$VALID_COMMANDS = %w[help init]


module Jury
  class CommandLineInterface
    include Jury::Tchk

    def create_filesystem   # BB(4)
      puts "#create_filesystem invoked"
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
