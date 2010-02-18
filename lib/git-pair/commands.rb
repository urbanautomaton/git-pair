module GitPair
  module Commands
    extend self

    def add(author_string)
      @config_changed = true
      authors = Helper.author_strings_with_new(author_string)
      remove_all
      authors.each do |name_and_email|
        `git config --global --add git-pair.authors "#{name_and_email}"`
      end
    end

    def remove(name)
      @config_changed = true
      `git config --global --unset-all git-pair.authors "^#{name} <"`
      `git config --global --remove-section git-pair` if Helper::author_strings.empty?
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
      raise MissingConfigurationError, "Please add some authors first" if Helper.author_names.empty?

      names = abbreviations.map { |abbrev|
        name = Helper.author_name_from_abbreviation(abbrev)
        raise NoMatchingAuthorsError, "no authors matched #{abbrev}" if name.nil?
        name
      }

      sorted_names = names.uniq.sort_by { |name| name.split.last }
      `git config user.name "#{sorted_names.join(' + ')}"`
      initials = sorted_names.map { |name| name.split.map { |word| word[0].chr }.join.downcase }
      `git config user.email "#{Helper.email(*initials)}"`

      # TODO: prompt for email if not already known
    end

  end
end
