# This isn't really a model.
# Use TMDB to gather additional data like release date.
# Search should be accurate and hopefully return only 1 result.
# If more than 1 result is returned, prompt user.

require 'active_support/core_ext'
require 'tmdb_party'

TMDB = TMDBParty::Base.new(ENV['TMDB_KEY'])

module MovieDataFetcher

  class << self

    def search(name)
      movies = TMDB.search(name)
    end

    # List each movie with an index.
    # Prompt for input.
    # Return movie matching input.
    def prompt(movies)
      movies.each_with_index do |movie, i|
        puts "#{i + 1}. #{movie.name} (#{movie.released}, #{movie.imdb_id})"
      end
      print "> "
      input = STDIN.gets.chomp.to_i
      valid_input = (1..movies.size).include?(input)
      if valid_input
        movie = movies[input - 1]
      else
        # Recurse.
        prompt(movies)
      end
    end

  end

end
