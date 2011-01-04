require './moty'
require 'ics'

# Parse movies from calendar export and create movies in db.
events = ICS::Event.file(File.open('movies.ics'))
events.each do |event|
  movie = Movie.new do |m|
    m.name = event.summary
    m.watched_on = event.started_on
  end
  movie.save
end
