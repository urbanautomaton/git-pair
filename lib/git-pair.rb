$:.unshift File.dirname(__FILE__)

require 'git-pair/command'
require 'git-pair/author'
require 'git-pair/config'

module GitPair

  VERSION = File.read(File.join(File.dirname(__FILE__), "git-pair", "VERSION")).strip

  class NoMatchingAuthorsError < ArgumentError; end
  class MissingConfigurationError < RuntimeError; end

end
