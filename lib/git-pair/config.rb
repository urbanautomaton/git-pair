module GitPair
  module Config
    extend self

    DEFAULT_PATTERN = "devs+%abbr+%abbr@%domain"

    def all_author_strings
      `git config --global --get-all git-pair.authors`.split("\n")
    end

    def pattern
      if get_pattern.length > 0
        get_pattern
      else
        DEFAULT_PATTERN
      end
    end

    def get_pattern
      `git config --get git-pair.pattern`.strip
    end

    def set_pattern(pattern)
      `git config --global --replace-all git-pair.pattern "#{pattern}"`
    end

    def remove_pattern
      `git config --global --unset-all git-pair.pattern`
    end

    def add_author(author)
      unless Author.exists?(author)
        `git config --global --add git-pair.authors "#{author.name} <#{author.email}>"`
      end
    end

    def remove_author(name)
      `git config --global --unset-all git-pair.authors "^#{name} <"`
      `git config --global --remove-section git-pair` if all_author_strings.empty?
    end

    def switch(authors)
      authors.sort!
      `git config user.name "#{authors.map { |a| a.name }.join(' + ')}"`
      `git config user.email "#{pair_email(authors)}"`
    end

    def reset
      `git config --remove-section user`
    end

    def default_email
      `git config --global --get user.email`.strip
    end

    def default_domain
      default_email.split('@').last
    end

    def current_author
      `git config --get user.name`.strip
    end

    def current_email
      `git config --get user.email`.strip
    end

    private
    def pair_email(authors)
      if authors.size == 1
        return authors.first.email
      end

      email = pattern.dup

      authors.each do |author|
        email.sub! '%name', author.first_name
        email.sub! '%last', author.last_name
        email.sub! '%abbr', author.initials
      end

      if email =~ /%domain/
        email.sub!('%domain', domain(authors.first))
      end

      email
    end

    def domain(author)
      if default_domain.length > 0
        default_domain
      else
        author.email.split('@').last
      end
    end
  end
end
