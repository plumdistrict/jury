$VALID_COMMANDS = %w[help init]


module Jury
  module Tchk
    def type_error
      raise Exception.new, "Type error"
    end


    def is_string(s)
      return s.kind_of?(String)
    end

    def is_array_of_T(ary, type = nil, minimum_length = 0)
      is_an_array = ary.kind_of?(Array)

      if !type.nil? then
        type_error if !type.kind_of?(Class)
        all_elements_of_type = ary.all? { |e| e.kind_of?(type) }
      else
        all_elements_of_type = true
      end

      minimum_length_met = ary.size >= minimum_length

      return is_an_array && all_elements_of_type && minimum_length_met
    end
  end


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
