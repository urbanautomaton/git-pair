module GitPair
  class Author
    
    def self.all
      Config.all_author_strings.map { |string| new(string) }
    end

    def self.find(abbrs)
      raise MissingConfigurationError, "Please add some authors first" if all.empty?

      abbrs.map do |abbr|
        author = all.find { |author| author.match?(abbr) }
        raise NoMatchingAuthorsError, "no authors matched #{abbr}" if author.nil?
        author
      end

    end

    def self.email(authors)
      if authors.length == 1
        authors.first.email
      else
        initials_string = '+' + authors.map { |a| a.initials }.join('+')
        Config.default_email.sub("@", "#{initials_string}@")
      end
    end

    attr_reader :name, :email

    def initialize(string)
      string =~ /^(.+)\s+<([^>]+)>$/
      @name = $1.to_s 
      @email = $2.to_s
    end

    def <=>(other)
      name.split.last <=> other.name.split.last
    end

    def initials
      name.split.map { |word| word[0].chr }.join.downcase
    end

    def match?(abbr)
      abbr.downcase == initials
    end

  end
end
