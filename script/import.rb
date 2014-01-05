require_relative '../db/db'
require_relative '../models/movie'
require 'ics'
require 'awesome_print'

# Import movies from .ics.
events = ICS::Event.file(File.open('movies.ics'))

year = ARGV.fetch(0) { raise "Missing year arg" }

# Filter movies from this year.
events.select! { |event| event.dtstart.starts_with?(year) }

Movie.transaction do
  # Create movies in db.
  events.each do |event|
    puts event.summary
    movie = Movie.new_from_event(event)
    if movie.valid?
      movie.save!
    else
      ap movie
    end
  end
  #raise ActiveRecord::Rollback
end

# Output.
puts "#{events.size} imported."
puts "#{Movie.count} movies total."
