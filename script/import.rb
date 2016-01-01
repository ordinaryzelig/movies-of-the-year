require_relative '../models/movie'
require 'awesome_print'

module Import

  module_function

  def call(year)
    # Import movies from .ics.
    events =
      Icalendar
        .parse(File.open('movies.ics'))
        .first
        .events

    # Filter movies from this year.
    events.select! { |event| event.dtstart.year == year }

    Movie.transaction do
      # Create movies in db.
      events.each do |event|
        begin
          movie = Movie.new_from_event(event)
        rescue
          puts "Error with #{event.summary.inspect}"
          raise
        end
        movie.save!
      end
    end

    # Output.
    puts "#{events.size} imported."
    puts "#{Movie.count} movies total."
  end

end
