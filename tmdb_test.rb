require 'active_support'
require 'active_support/core_ext'
require 'tmdb_party'
require 'awesome_print'

tmdb = TMDBParty::Base.new(ENV.fetch('TMDB_KEY'))
ap tmdb.search('harry potter')
