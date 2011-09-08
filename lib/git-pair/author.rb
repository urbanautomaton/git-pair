module GitPair
  class Author

    ValidAuthorStringRegex = /^\s*([^<]+)<([^>]+)>\s*$/

    class InvalidAuthorString < TypeError; end

    def self.all
      Config.all_author_strings.map { |string| new(string) }
    end

    def self.find_all(abbrs)
      raise MissingConfigurationError, "Please add some authors first" if all.empty?
      abbrs.map { |abbr| self.find(abbr) }
    end

    def self.find(abbr)
      all.find { |author| author.match?(abbr) } ||
        raise(NoMatchingAuthorsError, "no authors matched #{abbr}")
    end

    def self.email(authors)
      if authors.length == 1
        authors.first.email
      else
        initials_string = '+' + authors.map { |a| a.initials }.join('+')
        Config.default_email.sub("@", "#{initials_string}@")
      end
    end

    def self.exists?(author)
      self.all.find { |a| a.name == author.name }
    end

    def self.valid_string?(author_string)
      author_string =~ ValidAuthorStringRegex
    end

    attr_reader :name, :email

    def initialize(string)
      unless Author.valid_string?(string)
        raise(InvalidAuthorString, "\"#{string}\" is not a valid name and email")
      end

      string =~ ValidAuthorStringRegex
      @name = $1.to_s.strip
      @email = $2.to_s.strip
    end

    def <=>(other)
      first_name <=> other.first_name
    end

    def initials
      name.split.map { |word| word[0].chr }.join.downcase
    end

    def first_name
      name.split.first.downcase
    end

    def last_name
      name.split.last.downcase
    end

    def match?(abbr)
      abbr.downcase == initials
    end
  end
end
