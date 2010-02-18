module GitPair
  module Helper
    extend self

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

  end
end
