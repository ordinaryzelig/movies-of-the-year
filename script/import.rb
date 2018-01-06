require_relative '../init'

module Import

  module_function

  def call(year)
    # Import movies from .ics.
    events =
      Icalendar::Calendar
        .parse(File.open('tmp/movies.ics'))
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
          @rollback = true
          puts "Error with #{event.summary.inspect}"
        end
        movie.save!
      end

      raise ActiveRecord::ROLLBACK if @rollback
    end

    # Output.
    puts "#{events.size} imported."
    puts "#{Movie.count} movies total."
  end

end
