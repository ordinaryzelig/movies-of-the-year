require_relative '../spec_helper'

describe Movie do

  before do
    ActiveRecord::Base.connection.execute 'delete from movies;'
  end

  it '.new_from_event returns new Movie object with data from event' do
    event = ICS::Event.new(
      summary: 'Harry Potter (4,y)',
      dtstart: '2012-12-31 12:34',
    )
    movie = Movie.new_from_event(event)

    movie.name.must_equal 'Harry Potter'
    movie.rating.must_equal 4
    movie.watched_before.must_equal true
    movie.watched_on.must_equal Date.civil(2012, 12, 31)
  end

  it 'validates #rating to be nil or between 1 and 5' do
    movie = Movie.new
    # Rating is nil, valid.
    movie.valid?
    movie.errors[:rating].must_be_empty
    # Rating is 0, not valid.
    movie.rating = 0
    movie.valid?
    movie.errors[:rating].wont_be_nil
    # Rating is 1, valid.
    movie.rating = 1
    movie.valid?
    movie.errors[:rating].must_be_empty
  end

  it 'assigns sort name when name assigned' do
    movie = Movie.new(name: 'The Dark Knight')
    movie.sort_name.must_equal 'Dark Knight'
  end

  it '.watched_in returns movies watched in year' do
    movie1 = Movie.create!(name: 'beginning of year',  watched_on: '2011-1-1')
    movie2 = Movie.create!(name: 'end of year',        watched_on: '2011-12-31')
    movies = Movie.watched_in(2011)
    [movie1, movie2].each do |movie|
      movies.must_include movie
    end
  end

  it '#event_summary= parses and assigns title with rating and watched_before' do
    summary = 'Harry Potter (4,y)'
    movie = Movie.new(event_summary: summary)

    movie.name.must_equal 'Harry Potter'
    movie.rating.must_equal 4
    movie.watched_before.must_equal true
  end

end
