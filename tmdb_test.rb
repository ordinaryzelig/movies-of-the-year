require 'active_support'
require 'active_support/core_ext'
require 'tmdb_party'
require 'awesome_print'

tmdb = TMDBParty::Base.new('73da8f822edb8f522a650c123e25f38e')
ap tmdb.search('harry potter')
