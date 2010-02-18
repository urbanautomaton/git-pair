require 'optparse'

module GitPair
  module Command
    extend self

    def run!(args)
      parser = OptionParser.new do |opts|
        opts.banner = highlight('General Syntax:')
        opts.separator '  git pair [reset | authors | options]'

        opts.separator ' '
        opts.separator highlight('Options:')
        opts.on '-a', '--add NAME',    'Add an author. Format: "Author Name <author@example.com>"' do |name| 
          Commands.add name
        end
        opts.on '-r', '--remove NAME', 'Remove an author. Use the full name.' do |name| 
          Commands.remove name
        end
        opts.on '-d', '--reset', 'Reset current author to default (global) config' do
          Commands.reset
        end

        opts.separator ' '
        opts.separator highlight('Switching authors:')
        opts.separator '  git pair AA [BB]                   Where AA and BB are any abbreviation of an'
        opts.separator ' '*37 + 'author\'s name. You can specify one or more authors.'

        opts.separator ' '
        opts.separator highlight('Resetting authors:')
        opts.separator '  git pair reset                     Reverts to the user specified in your Git configuration.'

        opts.separator ' '
        opts.separator highlight('Current config:')
        opts.separator author_list.split("\n")
        opts.separator ' '
        opts.separator current_author_info.split("\n")
      end

      args = parser.parse!(args).dup

      if Commands.config_change_made?
        puts author_list
      elsif args.any?
        Commands.switch(args)
        puts current_author_info
      else
        puts parser.help
      end

    rescue OptionParser::MissingArgument
      abort "missing required argument", parser.help
    rescue OptionParser::InvalidOption, OptionParser::InvalidArgument => e
      abort e.message.sub(':', ''), parser.help
    rescue NoMatchingAuthorsError => e
      abort e.message, "\n" + author_list
    rescue MissingConfigurationError => e
      abort e.message, parser.help
    end

    def author_list
      "     #{bold 'Author list:'} #{Helper.author_names.join "\n                  "}"
    end

    def current_author_info
      "  #{bold 'Current author:'} #{Helper.current_author}\n" +
      "   #{bold 'Current email:'} #{Helper.current_email}\n "
    end

    def abort(error_message, extra = "")
      super red(" Error: #{error_message}\n") + extra
    end

    def highlight(string)
      "#{C_REVERSE}#{string}#{C_RESET}"
    end

    def bold(string)
      "#{C_BOLD}#{string}#{C_RESET}"
    end

    def red(string)
      "#{C_RED}#{C_REVERSE}#{string}#{C_RESET}"
    end

  end
end

