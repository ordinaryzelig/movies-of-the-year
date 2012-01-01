require_relative 'movie'
require 'ics'
require 'awesome_print'

# Import movies from .ics.
events = ICS::Event.file(File.open('movies.ics'))

# Filter movies from this year.
events.select! { |event| event.started_on.year == 2011 }

# Filter movies with ratings.
events.select! { |event| event.summary.match /\)$/ }

# Create movies in db.
events.each do |event|
  Movie.new do |mov|
    mov.name_with_rating = event.summary
    mov.watched_on = event.started_on
    mov.save!
  end
end

# Output.
puts "#{events.size} imported."
puts "#{Movie.count} movies total."
