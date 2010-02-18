require 'optparse'

module GitPair
  module Command
    extend self

    def run!(args)
      parser = OptionParser.new do |opts|
        opts.banner = Helper.highlight('General Syntax:')
        opts.separator '  git pair [reset | authors | options]'

        opts.separator ' '
        opts.separator Helper.highlight('Options:')
        opts.on '-a', '--add NAME',    'Add an author. Format: "Author Name <author@example.com>"' do |name| 
          Commands.add name
        end
        opts.on '-r', '--remove NAME', 'Remove an author. Use the full name.' do |name| 
          Commands.remove name
        end

        opts.separator ' '
        opts.separator Helper.highlight('Switching authors:')
        opts.separator '  git pair AA [BB]                   Where AA and BB are any abbreviation of an'
        opts.separator ' '*37 + 'author\'s name. You can specify one or more authors.'

        opts.separator ' '
        opts.separator Helper.highlight('Resetting authors:')
        opts.separator '  git pair reset                     Reverts to the user specified in your Git configuration.'

        opts.separator ' '
        opts.separator Helper.highlight('Current config:')
        opts.separator Helper.display_string_for_config.split("\n")
        opts.separator ' '
        opts.separator Helper.display_string_for_current_info.split("\n")
      end

      unused_options = parser.parse!(args).dup

      if Commands.config_change_made?
        puts Helper.display_string_for_config
      elsif unused_options.include?('reset')
        Commands.reset
        puts Helper.display_string_for_current_info
      elsif unused_options.any?
        Commands.switch(unused_options)
        puts Helper.display_string_for_current_info
      else
        puts parser.help
      end

    rescue OptionParser::MissingArgument
      Helper.abort "missing required argument", parser.help
    rescue OptionParser::InvalidOption, OptionParser::InvalidArgument => e
      Helper.abort e.message.sub(':', ''), parser.help
    rescue NoMatchingAuthorsError => e
      Helper.abort e.message, "\n" + Helper.display_string_for_config
    rescue MissingConfigurationError => e
      Helper.abort e.message, parser.help
    end
  end

end

