# git-pair

A git porcelain for changing `user.name` and `user.email` so you can commit as
more than one author.

## Usage

Install the gem:

    gem install edgecase-git-pair

And here's how to use it!

    $ git pair

    General Syntax:
      git pair [reset | authors | options]

    Options:
        -a, --add AUTHOR                 Add an author. Format: "Author Name <author@example.com>"
        -r, --remove NAME                Remove an author. Use the full name.
        -d, --reset                      Reset current author to default (global) config
            --pattern PATTERN            Set email pattern. Example: "dev+%name+%name@%domain"
                                           %name   - First name
                                           %last   - Last name
                                           %abbr   - Abbreviation
                                           %domain - Use domain from global config
            --remove-pattern             Reset the current email pattern to default.


    Switching authors:
      git pair aa [bb]                   Where AA and BB are any abbreviation of an
                                         author's name. You can specify one or more authors.

    Current config:
         Author list: Adam McCrea
                      Jon Distad

      Current author: Jon Distad + Adam McCrea
       Current email: devs+jd+am@edgecase.com

## How does it work?

The list of authors is maintained in the global git configuration file.
The current author is set in the git configuration local to the project.
The email address for a pair is generated using the default email address
from the global configuration along with the developer abbreviations.

## About this version

This was forked from http://github.com/edgecase/git-pair, which its turn
was forked from http://github.com/chrisk/git-pair. Many thanks to
Chris Kampmeier for the original version.  Jon Distad and Ehren Murdick's
version added the --reset option and did a great job refactoring the code.

We updated the gem to depend on Bundler rather than Jeweler and added
the option to configure how the pair's email address is generated since
the hardcoded one didn't adopt to the one we got by using Hitch.

## License

Copyright (c) 2009 Chris Kampmeier. See `LICENSE` for details.
