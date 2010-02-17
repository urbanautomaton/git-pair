C_BOLD, C_REVERSE, C_RED, C_RESET = "\e[1m", "\e[7m", "\e[91m", "\e[0m"

module GitPair

  VERSION = File.read(File.join(File.dirname(__FILE__), "git-pair", "VERSION")).strip

  C_BOLD, C_REVERSE, C_RED, C_RESET = "\e[1m", "\e[7m", "\e[91m", "\e[0m"


  class NoMatchingAuthorsError < ArgumentError; end
  class MissingConfigurationError < RuntimeError; end


  module Commands
    def add(author_string)
      @config_changed = true
      authors = Helpers.author_strings_with_new(author_string)
      remove_all
      authors.each do |name_and_email|
        `git config --global --add git-pair.authors "#{name_and_email}"`
      end
    end

    def remove(name)
      @config_changed = true
      `git config --global --unset-all git-pair.authors "^#{name} <"`
      `git config --global --remove-section git-pair` if Helpers::author_strings.empty?
    end

    def remove_all
      @config_changed = true
      `git config --global --unset-all git-pair.authors`
    end

    def config_change_made?
      @config_changed
    end

    def reset
      `git config --remove-section user`
    end

    def switch(abbreviations)
      raise MissingConfigurationError, "Please add some authors first" if Helpers.author_names.empty?

      names = abbreviations.map { |abbrev|
        name = Helpers.author_name_from_abbreviation(abbrev)
        raise NoMatchingAuthorsError, "no authors matched #{abbrev}" if name.nil?
        name
      }

      sorted_names = names.uniq.sort_by { |name| name.split.last }
      `git config user.name "#{sorted_names.join(' + ')}"`
      initials = sorted_names.map { |name| name.split.map { |word| word[0].chr }.join.downcase }
      `git config user.email "#{Helpers.email(*initials)}"`

      # TODO: prompt for email if not already known
    end

    extend self
  end


  module Helpers
    def display_string_for_config
      "#{C_BOLD}     Author list: #{C_RESET}" + author_names.join("\n                  ")
    end

    def display_string_for_current_info
      "#{C_BOLD}  Current author: #{C_RESET}" + current_author + "\n" +
      "#{C_BOLD}   Current email: #{C_RESET}" + current_email + "\n "
    end

    def author_strings
      `git config --global --get-all git-pair.authors`.split("\n")
    end

    def author_strings_with_new(author_string)
      strings = author_strings.push(author_string)

      strings.reject! { |str|
        strings.select { |s| parse_author_string(s).first == parse_author_string(str).first }.size != 1
      }
      strings.push(author_string) if !strings.include?(author_string)
      strings.sort_by { |str| parse_author_string(str).first }
    end

    def author_names
      author_strings.map { |line| parse_author_string(line).first }.sort_by { |name| name.split.last.to_s }
    end

    def email(*initials_list)
      if initials_list.size > 1
        initials_string = initials_list.map { |initials| "+#{initials}" }.join
        default_email.strip.sub("@", "#{initials_string}@")
      else
        author_email_from_abbreviation(initials_list.first)
      end
    end

    def default_email
      `git config --global --get user.email`.strip
    end

    def current_author
      `git config --get user.name`.strip
    end

    def current_email
      `git config --get user.email`.strip
    end

    def author_string_from_abbreviation(abbrev)
      # initials
      author_strings.each do |name|
        return name if abbrev.downcase == name.split.map { |word| word[0].chr }.join.downcase
      end

      # start of a name
      author_strings.each do |name|
        return name if name.gsub(" ", "") =~ /^#{abbrev}/i
      end

      # includes the letters in order
      author_strings.detect do |name|
        name =~ /#{abbrev.split("").join(".*")}/i
      end
    end

    def author_name_from_abbreviation(abbrev)
      parse_author_string(author_string_from_abbreviation(abbrev)).first
    end

    def author_email_from_abbreviation(abbrev)
      parse_author_string(author_string_from_abbreviation(abbrev)).last
    end

    def parse_author_string(author_string)
      author_string =~ /^(.+)\s+<([^>]+)>$/
      [$1.to_s, $2.to_s]
    end

    def abort(error_message, extra = "")
      super "#{C_RED}#{C_REVERSE} Error: #{error_message} #{C_RESET}\n" + extra
    end

    extend self
  end
end
